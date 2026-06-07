import HTML
import Saga

func homeAsset(_ name: String) -> String {
  "\(Site.homeAssetPath)\(name)"
}

struct HomeResponsiveImage {
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
    homeAsset("optimized/\(baseName)-\(width).\(fileExtension)")
  }

  private func srcset(fileExtension: String) -> String {
    widths
      .sorted()
      .map { "\(path(fileExtension: fileExtension, width: $0)) \($0)w" }
      .joined(separator: ", ")
  }
}

extension HomeResponsiveImage {
  static let bentoSizes = "(min-width: 768px) 312px, calc((100vw - 56px) / 2)"

  static let bentoPortrait1 = HomeResponsiveImage(
    baseName: "bento-portrait-1",
    widths: [312, 624],
    width: 624,
    height: 896,
    sizes: bentoSizes
  )

  static let bentoPortrait2 = HomeResponsiveImage(
    baseName: "bento-portrait-2",
    widths: [312, 624],
    width: 624,
    height: 896,
    sizes: bentoSizes
  )

  static let bentoWide1 = HomeResponsiveImage(
    baseName: "bento-wide-1",
    widths: [312, 624],
    width: 624,
    height: 432,
    sizes: bentoSizes
  )

  static let bentoWide2 = HomeResponsiveImage(
    baseName: "bento-wide-2",
    widths: [312, 624],
    width: 624,
    height: 432,
    sizes: bentoSizes
  )

  static let youtubeAvatar = HomeResponsiveImage(
    baseName: "youtube-avatar",
    widths: [64, 128],
    width: 128,
    height: 128,
    sizes: "64px"
  )

  static let discordAvatar = HomeResponsiveImage(
    baseName: "discord-avatar",
    widths: [64, 128],
    width: 128,
    height: 128,
    sizes: "64px"
  )

  static let chargeblast = HomeResponsiveImage(
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
    src: homeAsset(name),
    width: width.map { "\($0)" },
    customAttributes: customAttributes
  )
}

func responsiveHomeImage(
  _ image: HomeResponsiveImage,
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

func themedIcon(
  light: String,
  dark: String,
  alt: String = "",
  class className: String
) -> Node {
  span(class: className) {
    img(alt: alt, class: "size-full \(Theme.Shell.hiddenDark)", decoding: "async", src: homeAsset(light))
    img(alt: alt, class: "size-full \(Theme.Shell.visibleDark)", decoding: "async", src: homeAsset(dark))
  }
}

struct CardBadge {
  let light: String
  let dark: String?
  let className: String
}

enum CardLeading {
  case avatar(image: HomeResponsiveImage, badge: CardBadge)
  case icon(light: String, dark: String, className: String)
  case image(name: String, className: String)
  case responsiveImage(image: HomeResponsiveImage, className: String)
}

func siteCard(
  title: String,
  subtitle: String? = nil,
  description: String? = nil,
  href: String? = nil,
  leading: CardLeading? = nil,
  showsArrow: Bool = true
) -> Node {
  let className = !showsArrow && subtitle == nil && description == nil ? Theme.Card.brand : (href == nil ? Theme.Card.staticCard : Theme.Card.linked)

  if let href {
    return a(class: className, href: href) {
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
    themedIcon(light: "arrow-card-light.svg", dark: "arrow-card-dark.svg", class: Theme.Card.arrow)
  }
}

@NodeBuilder
func cardLeading(_ leading: CardLeading?, title: String) -> NodeConvertible {
  if let leading {
    switch leading {
    case let .avatar(image, badge):
      div(class: Theme.Card.avatar) {
        responsiveHomeImage(image, alt: "\(title) profile photo", class: Theme.Card.avatarImage)
        span(class: Theme.Card.badge) {
          if let dark = badge.dark {
            themedIcon(light: badge.light, dark: dark, class: badge.className)
          } else {
            assetImage(badge.light, alt: "", class: badge.className)
          }
        }
      }
    case let .icon(light, dark, className):
      themedIcon(light: light, dark: dark, class: className)
    case let .image(name, className):
      assetImage(name, alt: "", class: className)
    case let .responsiveImage(image, className):
      responsiveHomeImage(image, alt: "", class: className)
    }
  }
}

func homeText(_ text: String) -> Node {
  p(class: Theme.Home.text) { text }
}

func inlineActionLink(title: String, href: String) -> Node {
  a(class: Theme.Card.inlineAction, href: href) {
    themedIcon(light: "arrow-inline-light.svg", dark: "arrow-inline-dark.svg", class: Theme.Card.inlineArrow)
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
