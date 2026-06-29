import HTML
import Saga

func imageAsset(_ name: String) -> String {
  "\(Site.imageAssetPath)\(name)"
}

struct ResponsiveImage {
  let baseName: String
  let widths: [Int]
  let width: Int
  let height: Int
  let sizes: String

  var webpSrcset: String {
    srcset(fileExtension: "webp")
  }

  var pngSrcset: String {
    srcset(fileExtension: "png")
  }

  var fallback: String {
    path(fileExtension: "png", width: width)
  }

  var preload: ImagePreload {
    ImagePreload(
      href: path(fileExtension: "webp", width: width),
      srcset: webpSrcset,
      sizes: sizes,
      type: "image/webp"
    )
  }

  private func path(fileExtension: String, width: Int) -> String {
    imageAsset("\(baseName)-\(width).\(fileExtension)")
  }

  private func srcset(fileExtension: String) -> String {
    widths
      .sorted()
      .map { "\(path(fileExtension: fileExtension, width: $0)) \($0)w" }
      .joined(separator: ", ")
  }
}

extension ResponsiveImage {
  static let bentoSizes = "(min-width: 768px) 312px, calc((100vw - 56px) / 2)"

  static let bentoPortrait1 = ResponsiveImage(
    baseName: "bento-portrait-1",
    widths: [312, 624],
    width: 624,
    height: 896,
    sizes: bentoSizes
  )

  static let bentoPortrait2 = ResponsiveImage(
    baseName: "bento-portrait-2",
    widths: [312, 624],
    width: 624,
    height: 896,
    sizes: bentoSizes
  )

  static let bentoWide1 = ResponsiveImage(
    baseName: "bento-wide-1",
    widths: [312, 624],
    width: 624,
    height: 432,
    sizes: bentoSizes
  )

  static let bentoWide2 = ResponsiveImage(
    baseName: "bento-wide-2",
    widths: [312, 624],
    width: 624,
    height: 432,
    sizes: bentoSizes
  )

  static let youtubeAvatar = ResponsiveImage(
    baseName: "youtube-avatar",
    widths: [64, 128],
    width: 128,
    height: 128,
    sizes: "64px"
  )

  static let discordAvatar = ResponsiveImage(
    baseName: "discord-avatar",
    widths: [64, 128],
    width: 128,
    height: 128,
    sizes: "64px"
  )

  static let chargeblast = ResponsiveImage(
    baseName: "chargeblast",
    widths: [48, 96],
    width: 96,
    height: 96,
    sizes: "24px"
  )
}

func assetImage(
  _ name: String,
  alt: String,
  class className: String,
  width: Int? = nil,
  height: Int? = nil,
  loading: String? = nil,
  fetchPriority: String? = nil
) -> Node {
  var customAttributes: [String: String] = [:]
  if let fetchPriority {
    customAttributes["fetchpriority"] = fetchPriority
  }

  return img(
    alt: alt,
    class: className,
    decoding: "async",
    height: height.map { "\($0)" },
    loading: loading,
    src: imageAsset(name),
    width: width.map { "\($0)" },
    customAttributes: customAttributes
  )
}

func waveAnimation(alt: String) -> Node {
  picture {
    source(srcset: imageAsset("wave-58.webp"), type: "image/webp")
    assetImage("wave-58.gif", alt: alt, class: Theme.Home.wave, width: 58, height: 56, loading: "eager")
  }
}

func responsiveImage(
  _ image: ResponsiveImage,
  alt: String,
  class className: String,
  loading: String = "lazy",
  fetchPriority: String? = nil
) -> Node {
  var customAttributes: [String: String] = [:]
  if let fetchPriority {
    customAttributes["fetchpriority"] = fetchPriority
  }

  return picture {
    source(sizes: image.sizes, srcset: image.webpSrcset, type: "image/webp")
    source(sizes: image.sizes, srcset: image.pngSrcset, type: "image/png")
    img(
      alt: alt,
      class: className,
      decoding: "async",
      height: "\(image.height)",
      loading: loading,
      sizes: image.sizes,
      src: image.fallback,
      srcset: image.pngSrcset,
      width: "\(image.width)",
      customAttributes: customAttributes
    )
  }
}

struct CardBadge {
  let icon: SiteIcon
  let className: String
}

enum CardLeading {
  case avatar(image: ResponsiveImage, badge: CardBadge)
  case icon(SiteIcon, className: String)
  case image(name: String, className: String)
  case responsiveImage(image: ResponsiveImage, className: String)
}

func siteCard(
  title: String,
  subtitle: String? = nil,
  description: String? = nil,
  href: String? = nil,
  leading: CardLeading? = nil,
  showsArrow: Bool = true,
  opensInNewTab: Bool = false
) -> Node {
  let className = !showsArrow && subtitle == nil && description == nil ? Theme.Card.brand : (href == nil ? Theme.Card.staticCard : Theme.Card.linked)

  if let href {
    return a(
      class: className,
      href: href,
      rel: opensInNewTab ? "noopener noreferrer" : nil,
      target: opensInNewTab ? "_blank" : nil
    ) {
      siteCardContents(
        title: title,
        subtitle: subtitle,
        description: description,
        leading: leading,
        showsArrow: showsArrow
      )
    }
  }

  return div(class: className) {
    siteCardContents(
      title: title,
      subtitle: subtitle,
      description: description,
      leading: leading,
      showsArrow: showsArrow
    )
  }
}

@NodeBuilder
func siteCardContents(
  title: String,
  subtitle: String?,
  description: String?,
  leading: CardLeading?,
  showsArrow: Bool
) -> NodeConvertible {
  div(class: leading == nil ? Theme.Card.content : Theme.Card.contentWithLeading) {
    cardLeading(leading, title: title)
    div(class: Theme.Card.details) {
      p(class: Theme.Card.title) { title }
      if let description {
        p(class: Theme.Card.description) { description }
      }
      if let subtitle {
        p(class: Theme.Card.meta) { subtitle }
      }
    }
  }

  if showsArrow {
    siteIcon(.arrowUpRight, class: Theme.Card.arrow)
  }
}

@NodeBuilder
func cardLeading(_ leading: CardLeading?, title: String) -> NodeConvertible {
  if let leading {
    switch leading {
    case let .avatar(image, badge):
      div(class: Theme.Card.avatar) {
        responsiveImage(image, alt: "\(title) profile photo", class: Theme.Card.avatarImage)
        span(class: Theme.Card.badge) {
          siteIcon(badge.icon, class: badge.className)
        }
      }
    case let .icon(icon, className):
      siteIcon(icon, class: className)
    case let .image(name, className):
      assetImage(name, alt: "", class: className)
    case let .responsiveImage(image, className):
      responsiveImage(image, alt: "", class: className)
    }
  }
}

func homeText(_ text: String) -> Node {
  p(class: Theme.Home.text) { text }
}

func inlineActionLink(title: String, href: String, opensInNewTab: Bool = false) -> Node {
  a(
    class: Theme.Card.inlineAction,
    href: href,
    rel: opensInNewTab ? "noopener noreferrer" : nil,
    target: opensInNewTab ? "_blank" : nil
  ) {
    siteIcon(.arrowUpRight, class: Theme.Card.inlineArrow)
    span { title }
  }
}

func noteCard(_ note: Item<NoteMetadata>, locale: String) -> Node {
  siteCard(
    title: note.title,
    subtitle: "\(note.metadata.displayType.label(locale: locale)) · \(Site.displayDate(note.date, locale: locale))",
    href: note.url
  )
}

func tagList(_ tags: [String]) -> Node {
  ul(class: Theme.Notes.tags) {
    tags.map { tag in
      li {
        span(class: Theme.Notes.tag) { tag }
      }
    }
  }
}

func sortedGames(from context: PageRenderingContext) -> [Item<GameMetadata>] {
  context.allItems
    .compactMap { $0 as? Item<GameMetadata> }
    .filter { $0.metadata.isPublished }
    .sorted { first, second in
      let firstUpdated = first.metadata.updated ?? ""
      let secondUpdated = second.metadata.updated ?? ""

      if firstUpdated != secondUpdated {
        return firstUpdated > secondUpdated
      }

      let firstOrder = first.metadata.featuredOrder ?? Int.max
      let secondOrder = second.metadata.featuredOrder ?? Int.max

      if firstOrder != secondOrder {
        return firstOrder < secondOrder
      }

      return first.title < second.title
    }
}

func publishedReviewSlugs(from context: PageRenderingContext) -> Set<String> {
  Set(
    context.allItems
      .compactMap { $0 as? Item<NoteMetadata> }
      .filter { $0.metadata.isPublished }
      .map(\.filenameWithoutExtension)
  )
}

func gameModalID(for game: Item<GameMetadata>) -> String {
  "game-\(game.filenameWithoutExtension)"
}

func gameStatusClass(_ status: GameStatus) -> String {
  switch status {
  case .playing: Theme.Game.statusPlaying
  case .completed: Theme.Game.statusCompleted
  case .backlog: Theme.Game.statusBacklog
  case .wishlist: Theme.Game.statusWishlist
  }
}

func gameCover(_ game: Item<GameMetadata>, class className: String) -> Node {
  if let cover = nonEmptyString(game.metadata.cover) {
    return assetImage(cover, alt: "", class: className, loading: "lazy")
  }

  return div(class: Theme.Game.placeholder, customAttributes: ["aria-hidden": "true"]) {
    span(class: Theme.Game.placeholderLinePrimary) {}
    span(class: Theme.Game.placeholderLineSecondary) {}
  }
}

func gameDialog(
  game: Item<GameMetadata>,
  copy: SiteCopy,
  locale: String,
  publishedReviewSlugs: Set<String>
) -> Node {
  let modalID = gameModalID(for: game)
  let titleID = "\(modalID)-title"

  return dialog(
    class: Theme.Game.dialog,
    id: modalID,
    customAttributes: [
      "aria-labelledby": titleID,
      "data-game-dialog": "",
    ]
  ) {
    div(class: Theme.Game.dialogPanel) {
      gameVisual(game: game, copy: copy)

      div(class: Theme.Game.dialogBody) {
        div(class: Theme.Game.dialogTitleGroup) {
          h3(class: Theme.Game.dialogTitle, id: titleID) { game.title }
          p(class: Theme.Game.dialogStatus) { game.metadata.status.label(locale: locale) }
        }

        if !game.body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
          div(class: "\(Theme.Markdown.content) \(Theme.Game.markdown)") {
            Node.raw(game.body)
          }
        }

        if let reviewSlug = nonEmptyString(game.metadata.reviewSlug),
           publishedReviewSlugs.contains(reviewSlug) {
          a(class: Theme.Game.reviewLink, href: "\(Site.localizedNotesPath(for: locale))\(reviewSlug)/") {
            copy.gameReviewAction
          }
        }
      }
    }
  }
}

func gameVisual(game: Item<GameMetadata>, copy: SiteCopy) -> Node {
  let gallery = game.metadata.gallery ?? []
  let galleryAttributes: [String: String] = gallery.isEmpty ? [:] : [
    "data-game-gallery": "",
    "data-game-gallery-images": gallery.map(imageAsset).joined(separator: "|"),
    "data-game-gallery-index": "0",
  ]

  return div(
    class: Theme.Game.gallery,
    customAttributes: galleryAttributes
  ) {
    div(class: Theme.Game.galleryStage) {
      if let firstImage = gallery.first {
        img(
          alt: game.title,
          class: Theme.Game.galleryImage,
          decoding: "async",
          loading: "lazy",
          src: imageAsset(firstImage),
          customAttributes: ["data-game-gallery-image": ""]
        )
      } else if let cover = nonEmptyString(game.metadata.cover) {
        assetImage(cover, alt: game.title, class: Theme.Game.galleryImage, loading: "lazy")
      } else {
        div(class: Theme.Game.galleryPlaceholder, customAttributes: ["aria-hidden": "true"]) {
          span(class: Theme.Game.placeholderLinePrimary) {}
          span(class: Theme.Game.placeholderLineSecondary) {}
        }
      }

      button(
        class: Theme.Game.closeButton,
        type: "button",
        customAttributes: [
          "aria-label": copy.gameCloseAction,
          "data-game-close": "",
        ]
      ) {
        siteIcon(.close, class: Theme.Game.closeIcon)
      }

      if gallery.count > 1 {
        button(
          class: "\(Theme.Game.galleryNavButton) \(Theme.Game.galleryPreviousButton)",
          type: "button",
          customAttributes: [
            "aria-label": copy.gameGalleryPreviousAction,
            "data-game-gallery-prev": "",
          ]
        ) {
          siteIcon(.chevronLeft, class: Theme.Game.galleryButtonIcon)
        }

        button(
          class: "\(Theme.Game.galleryNavButton) \(Theme.Game.galleryNextButton)",
          type: "button",
          customAttributes: [
            "aria-label": copy.gameGalleryNextAction,
            "data-game-gallery-next": "",
          ]
        ) {
          siteIcon(.chevronRight, class: Theme.Game.galleryButtonIcon)
        }
      }
    }
  }
}

func gamesScript() -> Node {
  script(defer: true, src: Saga.hashed("/static/scripts/about-games.js"))
}

func nonEmptyString(_ value: String?) -> String? {
  guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty else {
    return nil
  }

  return value
}
