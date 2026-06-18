import HTML
import Saga

func renderAbout(context: PageRenderingContext) -> Node {
  let locale = Site.currentLocale(context.locale)
  let copy = Site.copy(for: locale)
  let canonicalPath = context.translations[locale] ?? Site.localizedAboutPath(for: locale)
  let games = aboutGames(from: context)

  return baseHtml(
    title: copy.aboutTitle,
    description: copy.aboutLead,
    canonicalPath: canonicalPath,
    locale: locale,
    translations: context.translations
  ) {
    pageFrame(activeSection: .about, locale: locale, translations: context.translations) {
      section(class: Theme.About.header) {
        h1(class: Theme.About.pageTitle) { copy.aboutTitle }
        p(class: Theme.About.lead) { copy.aboutLead }
      }

      div(class: Theme.About.body) {
        copy.aboutParagraphs.map { paragraph in
          p(class: Theme.About.text) { paragraph }
        }
      }

      if !games.isEmpty {
        aboutGamesSection(games: games, copy: copy, locale: locale)
      }

      section(class: Theme.About.career) {
        h2(class: Theme.About.careerTitle) { copy.aboutCareerTitle }
        ul(class: Theme.About.careerList) {
          copy.aboutCareerItems.map { item in
            li(class: Theme.About.careerItem) {
              span(class: Theme.About.careerBullet) {}
              span(class: Theme.About.careerItemText) { item }
            }
          }
        }
      }

      if !games.isEmpty {
        aboutGamesScript()
      }
    }
  }
}

private func aboutGames(from context: PageRenderingContext) -> [Item<GameMetadata>] {
  context.allItems
    .compactMap { $0 as? Item<GameMetadata> }
    .sorted {
      let firstOrder = $0.metadata.featuredOrder ?? Int.max
      let secondOrder = $1.metadata.featuredOrder ?? Int.max

      if firstOrder == secondOrder {
        return $0.title < $1.title
      }

      return firstOrder < secondOrder
    }
}

private func aboutGamesSection(games: [Item<GameMetadata>], copy: SiteCopy, locale: String) -> Node {
  section(class: Theme.About.games, id: "games") {
    div(class: Theme.About.gamesHeader) {
      h2(class: Theme.About.gamesTitle) { copy.aboutGamesTitle }
      p(class: Theme.About.gamesDescription) { copy.aboutGamesDescription }
    }

    div(class: Theme.About.gamesGrid) {
      games.map { game in
        aboutGameButton(game: game, copy: copy, locale: locale)
      }
    }

    games.map { game in
      aboutGameDialog(game: game, copy: copy, locale: locale)
    }
  }
}

private func aboutGameButton(game: Item<GameMetadata>, copy: SiteCopy, locale: String) -> Node {
  let modalID = aboutGameModalID(for: game)

  return button(
    class: Theme.About.gameButton,
    type: "button",
    customAttributes: [
      "aria-label": "\(copy.gameOpenDetailsAction): \(game.title)",
      "data-game-modal": modalID,
    ]
  ) {
    aboutGameCover(game)
    span(
      class: "\(Theme.About.gameStatusMarker) \(aboutGameStatusClass(game.metadata.status))",
      customAttributes: ["aria-hidden": "true"]
    ) {}
  }
}

private func aboutGameCover(_ game: Item<GameMetadata>) -> Node {
  if let cover = nonEmpty(game.metadata.cover) {
    return assetImage(cover, alt: "", class: Theme.About.gameCover, loading: "lazy")
  }

  return div(class: Theme.About.gamePlaceholder, customAttributes: ["aria-hidden": "true"]) {
    span(class: Theme.About.gamePlaceholderLinePrimary) {}
    span(class: Theme.About.gamePlaceholderLineSecondary) {}
  }
}

private func aboutGameDialog(game: Item<GameMetadata>, copy: SiteCopy, locale: String) -> Node {
  let modalID = aboutGameModalID(for: game)
  let titleID = "\(modalID)-title"

  return dialog(
    class: Theme.About.gameDialog,
    id: modalID,
    customAttributes: [
      "aria-labelledby": titleID,
      "data-game-dialog": "",
    ]
  ) {
    div(class: Theme.About.gameDialogPanel) {
      header(class: Theme.About.gameDialogHeader) {
        div(class: Theme.About.gameDialogTitleGroup) {
          h3(class: Theme.About.gameDialogTitle, id: titleID) { game.title }
          p(class: Theme.About.gameDialogStatus) { game.metadata.status.label(locale: locale) }
        }

        button(
          class: Theme.About.gameCloseButton,
          type: "button",
          customAttributes: [
            "aria-label": copy.gameCloseAction,
            "data-game-close": "",
          ]
        ) {
          siteIcon(.close, class: Theme.About.gameCloseIcon)
        }
      }

      div(class: Theme.About.gameDialogBody) {
        dl(class: Theme.About.gameMetaList) {
          aboutGameMeta(label: copy.gameSystemLabel, value: game.metadata.system)
          aboutGameMeta(label: copy.gamePlayableOnLabel, value: game.metadata.playableOn)
          aboutGameMeta(label: copy.gameLibraryLabel, value: game.metadata.collection?.label(locale: locale))
          aboutGameMeta(label: copy.gameFormatLabel, value: game.metadata.format?.label(locale: locale))
          aboutGameMeta(label: copy.gameEditionLabel, value: game.metadata.edition)
          aboutGameMeta(label: copy.gameStartedLabel, value: game.metadata.started)
          aboutGameMeta(label: copy.gameFinishedLabel, value: game.metadata.finished)
          aboutGameMeta(label: copy.gamePlaytimeLabel, value: game.metadata.playtime)
        }

        if !game.body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
          div(class: "\(Theme.Markdown.content) \(Theme.About.gameMarkdown)") {
            Node.raw(game.body)
          }
        }

        aboutGameGallery(game: game, copy: copy)

        if let reviewSlug = nonEmpty(game.metadata.reviewSlug) {
          a(class: Theme.About.gameReviewLink, href: "\(Site.localizedNotesPath(for: locale))\(reviewSlug)/") {
            copy.gameReviewAction
          }
        }
      }
    }
  }
}

@NodeBuilder
private func aboutGameMeta(label: String, value: String?) -> NodeConvertible {
  if let value = nonEmpty(value) {
    div(class: Theme.About.gameMetaItem) {
      dt(class: Theme.About.gameMetaLabel) { label }
      dd(class: Theme.About.gameMetaValue) { value }
    }
  }
}

@NodeBuilder
private func aboutGameGallery(game: Item<GameMetadata>, copy: SiteCopy) -> NodeConvertible {
  if let gallery = game.metadata.gallery, !gallery.isEmpty {
    div(class: Theme.About.gameGallery, customAttributes: ["data-game-gallery": ""]) {
      div(class: Theme.About.gameGalleryHeader) {
        h4(class: Theme.About.gameGalleryTitle) { copy.gameGalleryTitle }
        span(
          class: Theme.About.gameGalleryCounter,
          customAttributes: ["data-game-gallery-counter": ""]
        ) {
          "1 / \(gallery.count)"
        }
      }

      div(class: Theme.About.gameGalleryCarousel) {
        div(class: Theme.About.gameGalleryStage) {
          img(
            alt: game.title,
            class: Theme.About.gameGalleryImage,
            decoding: "async",
            loading: "lazy",
            src: imageAsset(gallery[0]),
            customAttributes: ["data-game-gallery-image": ""]
          )

          if gallery.count > 1 {
            button(
              class: "\(Theme.About.gameGalleryNavButton) \(Theme.About.gameGalleryPreviousButton)",
              type: "button",
              customAttributes: [
                "aria-label": copy.gameGalleryPreviousAction,
                "data-game-gallery-prev": "",
              ]
            ) {
              span(class: Theme.About.gameGalleryButtonGlyph, customAttributes: ["aria-hidden": "true"]) { "<" }
            }

            button(
              class: "\(Theme.About.gameGalleryNavButton) \(Theme.About.gameGalleryNextButton)",
              type: "button",
              customAttributes: [
                "aria-label": copy.gameGalleryNextAction,
                "data-game-gallery-next": "",
              ]
            ) {
              span(class: Theme.About.gameGalleryButtonGlyph, customAttributes: ["aria-hidden": "true"]) { ">" }
            }
          }
        }

        if gallery.count > 1 {
          div(class: Theme.About.gameGalleryThumbs) {
            gallery.enumerated().map { index, image in
              button(
                class: Theme.About.gameGalleryThumb,
                type: "button",
                customAttributes: gameGalleryThumbAttributes(
                  image: image,
                  index: index,
                  title: game.title,
                  copy: copy
                )
              ) {
                img(
                  alt: "",
                  class: Theme.About.gameGalleryThumbImage,
                  decoding: "async",
                  loading: "lazy",
                  src: imageAsset(image)
                )
              }
            }
          }
        }
      }
    }
  }
}

private func gameGalleryThumbAttributes(
  image: String,
  index: Int,
  title: String,
  copy: SiteCopy
) -> [String: String] {
  var attributes = [
    "aria-label": "\(copy.gameGallerySelectAction) \(index + 1): \(title)",
    "data-game-gallery-src": imageAsset(image),
    "data-game-gallery-thumb": "",
    "data-game-gallery-index": "\(index)",
  ]

  if index == 0 {
    attributes["aria-current"] = "true"
    attributes["data-active"] = "true"
  }

  return attributes
}

private func aboutGameModalID(for game: Item<GameMetadata>) -> String {
  "game-\(game.filenameWithoutExtension)"
}

private func aboutGameStatusClass(_ status: GameStatus) -> String {
  switch status {
  case .playing: Theme.About.gameStatusPlaying
  case .completed: Theme.About.gameStatusCompleted
  case .backlog: Theme.About.gameStatusBacklog
  case .wishlist: Theme.About.gameStatusWishlist
  }
}

private func nonEmpty(_ value: String?) -> String? {
  guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty else {
    return nil
  }

  return value
}

private func aboutGamesScript() -> Node {
  script(defer: true, src: Saga.hashed("/static/scripts/about-games.js"))
}
