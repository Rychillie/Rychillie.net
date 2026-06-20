import HTML
import Saga

func sortedGames(from context: PageRenderingContext) -> [Item<GameMetadata>] {
  context.allItems
    .compactMap { $0 as? Item<GameMetadata> }
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

func gameDialog(game: Item<GameMetadata>, copy: SiteCopy, locale: String) -> Node {
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
      header(class: Theme.Game.dialogHeader) {
        div(class: Theme.Game.dialogTitleGroup) {
          h3(class: Theme.Game.dialogTitle, id: titleID) { game.title }
          p(class: Theme.Game.dialogStatus) { game.metadata.status.label(locale: locale) }
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
      }

      div(class: Theme.Game.dialogBody) {
        dl(class: Theme.Game.metaList) {
          gameMeta(label: copy.gameSystemLabel, value: game.metadata.system)
          gameMeta(label: copy.gamePlayableOnLabel, value: game.metadata.playableOn)
          gameMeta(label: copy.gameLibraryLabel, value: game.metadata.collection?.label(locale: locale))
          gameMeta(label: copy.gameFormatLabel, value: game.metadata.format?.label(locale: locale))
          gameMeta(label: copy.gameEditionLabel, value: game.metadata.edition)
          gameMeta(label: copy.gameStartedLabel, value: game.metadata.started)
          gameMeta(label: copy.gameFinishedLabel, value: game.metadata.finished)
          gameMeta(label: copy.gamePlaytimeLabel, value: game.metadata.playtime)
        }

        if !game.body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
          div(class: "\(Theme.Markdown.content) \(Theme.Game.markdown)") {
            Node.raw(game.body)
          }
        }

        gameGallery(game: game, copy: copy)

        if let reviewSlug = nonEmptyString(game.metadata.reviewSlug) {
          a(class: Theme.Game.reviewLink, href: "\(Site.localizedNotesPath(for: locale))\(reviewSlug)/") {
            copy.gameReviewAction
          }
        }
      }
    }
  }
}

@NodeBuilder
func gameMeta(label: String, value: String?) -> NodeConvertible {
  if let value = nonEmptyString(value) {
    div(class: Theme.Game.metaItem) {
      dt(class: Theme.Game.metaLabel) { label }
      dd(class: Theme.Game.metaValue) { value }
    }
  }
}

@NodeBuilder
func gameGallery(game: Item<GameMetadata>, copy: SiteCopy) -> NodeConvertible {
  if let gallery = game.metadata.gallery, !gallery.isEmpty {
    div(class: Theme.Game.gallery, customAttributes: ["data-game-gallery": ""]) {
      div(class: Theme.Game.galleryHeader) {
        h4(class: Theme.Game.galleryTitle) { copy.gameGalleryTitle }
        span(
          class: Theme.Game.galleryCounter,
          customAttributes: ["data-game-gallery-counter": ""]
        ) {
          "1 / \(gallery.count)"
        }
      }

      div(class: Theme.Game.galleryCarousel) {
        div(class: Theme.Game.galleryStage) {
          img(
            alt: game.title,
            class: Theme.Game.galleryImage,
            decoding: "async",
            loading: "lazy",
            src: imageAsset(gallery[0]),
            customAttributes: ["data-game-gallery-image": ""]
          )

          if gallery.count > 1 {
            button(
              class: "\(Theme.Game.galleryNavButton) \(Theme.Game.galleryPreviousButton)",
              type: "button",
              customAttributes: [
                "aria-label": copy.gameGalleryPreviousAction,
                "data-game-gallery-prev": "",
              ]
            ) {
              span(class: Theme.Game.galleryButtonGlyph, customAttributes: ["aria-hidden": "true"]) { "<" }
            }

            button(
              class: "\(Theme.Game.galleryNavButton) \(Theme.Game.galleryNextButton)",
              type: "button",
              customAttributes: [
                "aria-label": copy.gameGalleryNextAction,
                "data-game-gallery-next": "",
              ]
            ) {
              span(class: Theme.Game.galleryButtonGlyph, customAttributes: ["aria-hidden": "true"]) { ">" }
            }
          }
        }

        if gallery.count > 1 {
          div(class: Theme.Game.galleryThumbs) {
            gallery.enumerated().map { index, image in
              button(
                class: Theme.Game.galleryThumb,
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
                  class: Theme.Game.galleryThumbImage,
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

func gameGalleryThumbAttributes(
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

func gamesScript() -> Node {
  script(defer: true, src: Saga.hashed("/static/scripts/about-games.js"))
}

func nonEmptyString(_ value: String?) -> String? {
  guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty else {
    return nil
  }

  return value
}
