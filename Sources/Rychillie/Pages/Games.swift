import HTML
import Saga

func renderGames(context: PageRenderingContext) -> Node {
  let locale = Site.currentLocale(context.locale)
  let copy = Site.copy(for: locale)
  let canonicalPath = context.translations[locale] ?? Site.localizedGamesPath(for: locale)
  let games = sortedGames(from: context)
  let reviewSlugs = publishedReviewSlugs(from: context)

  return baseHtml(
    title: copy.gamesPageTitle,
    description: copy.gamesPageDescription,
    canonicalPath: canonicalPath,
    locale: locale,
    translations: context.translations
  ) {
    pageFrame(activeSection: .about, locale: locale, translations: context.translations) {
      section(class: Theme.Games.header) {
        h1(class: Theme.Games.pageTitle) { copy.gamesPageTitle }
        p(class: Theme.Games.pageText) { copy.gamesPageDescription }
      }

      if !games.isEmpty {
        gamesFilters(copy: copy, locale: locale)

        div(class: Theme.Games.grid) {
          games.map { game in
            gamesCard(game: game, copy: copy)
          }
        }

        games.map { game in
          gameDialog(game: game, copy: copy, locale: locale, publishedReviewSlugs: reviewSlugs)
        }

        gamesScript()
      }
    }
  }
}

private func gamesFilters(copy: SiteCopy, locale: String) -> Node {
  div(
    class: Theme.Games.filters,
    customAttributes: [
      "aria-label": copy.gamesPageTitle,
      "data-game-filter-group": "",
    ]
  ) {
    gamesFilterButton(label: copy.gamesFilterAllAction, value: "all", isActive: true)
    gamesFilterButton(label: GameStatus.playing.label(locale: locale), value: GameStatus.playing.rawValue)
    gamesFilterButton(label: GameStatus.completed.label(locale: locale), value: GameStatus.completed.rawValue)
    gamesFilterButton(label: GameStatus.backlog.label(locale: locale), value: GameStatus.backlog.rawValue)
    gamesFilterButton(label: GameStatus.wishlist.label(locale: locale), value: GameStatus.wishlist.rawValue)
  }
}

private func gamesFilterButton(label: String, value: String, isActive: Bool = false) -> Node {
  var attributes = [
    "aria-pressed": isActive ? "true" : "false",
    "data-game-filter": value,
  ]

  if isActive {
    attributes["data-active"] = "true"
  }

  return button(
    class: Theme.Games.filterButton,
    type: "button",
    customAttributes: attributes
  ) {
    label
  }
}

private func gamesCard(game: Item<GameMetadata>, copy: SiteCopy) -> Node {
  let modalID = gameModalID(for: game)

  return button(
    class: Theme.Games.card,
    type: "button",
    customAttributes: [
      "aria-label": "\(copy.gameOpenDetailsAction): \(game.title)",
      "data-game-item": "",
      "data-game-modal": modalID,
      "data-game-status": game.metadata.status.rawValue,
    ]
  ) {
    gameCover(game, class: Theme.Game.cover)
  }
}
