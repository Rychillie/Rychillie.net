import HTML
import Saga

func renderAbout(context: PageRenderingContext) -> Node {
  let locale = Site.currentLocale(context.locale)
  let copy = Site.copy(for: locale)
  let canonicalPath = context.translations[locale] ?? Site.localizedAboutPath(for: locale)
  let games = sortedGames(from: context)
  let reviewSlugs = publishedReviewSlugs(from: context)

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
        aboutGamesSection(games: games, copy: copy, locale: locale, publishedReviewSlugs: reviewSlugs)
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
        gamesScript()
      }
    }
  }
}

private func aboutGamesSection(
  games: [Item<GameMetadata>],
  copy: SiteCopy,
  locale: String,
  publishedReviewSlugs: Set<String>
) -> Node {
  let shelfGames = Array(games.prefix(12))

  return section(class: Theme.About.games, id: "games") {
    div(class: Theme.About.gamesHeader) {
      div(class: Theme.About.gamesTitleRow) {
        h2(class: Theme.About.gamesTitle) { copy.aboutGamesTitle }
        a(class: Theme.About.gamesViewAllLink, href: Site.localizedGamesPath(for: locale)) {
          copy.gamesViewAllAction
        }
      }
      p(class: Theme.About.gamesDescription) { copy.aboutGamesDescription }
    }

    div(class: Theme.About.gamesShelf) {
      shelfGames.map { game in
        aboutGameButton(game: game, copy: copy, locale: locale)
      }
    }

    shelfGames.map { game in
      gameDialog(game: game, copy: copy, locale: locale, publishedReviewSlugs: publishedReviewSlugs)
    }
  }
}

private func aboutGameButton(game: Item<GameMetadata>, copy: SiteCopy, locale: String) -> Node {
  let modalID = gameModalID(for: game)

  return button(
    class: Theme.About.gameShelfButton,
    type: "button",
    customAttributes: [
      "aria-label": "\(copy.gameOpenDetailsAction): \(game.title)",
      "data-game-modal": modalID,
    ]
  ) {
    gameCover(game, class: Theme.Game.cover)
  }
}
