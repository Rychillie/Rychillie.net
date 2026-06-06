import HTML
import Saga

func renderHome(context: PageRenderingContext) -> Node {
  let locale = Site.currentLocale(context.locale)
  let copy = Site.copy(for: locale)
  let latestNotes = Array(context.allItems
    .compactMap { $0 as? Item<NoteMetadata> }
    .sorted { $0.date > $1.date }
    .prefix(3))

  return baseHtml(title: Site.name, locale: locale) {
    pageFrame(activeSection: .home, locale: locale, translations: context.translations) {
      section(class: Theme.Home.intro, id: "about") {
        h1(class: Theme.Home.introTitle) { copy.introTitle }
        homeText(copy.intro)
      }

      div(class: Theme.Home.bento) {
        div(class: Theme.Home.bentoColumn) {
          assetImage("bento-portrait-1.png", alt: "Rychillie portrait", class: Theme.Home.imageTall)
          assetImage("bento-wide-1.png", alt: "BrazilJS event", class: Theme.Home.imageShort)
        }
        div(class: Theme.Home.bentoColumn) {
          assetImage("bento-wide-2.png", alt: "Rychillie speaking", class: Theme.Home.imageShort)
          assetImage("bento-portrait-2.png", alt: "Rychillie on stage", class: Theme.Home.imageTall)
        }
      }

      homeText(copy.homePrimaryText)

      div(class: Theme.Home.socialCards) {
        siteCard(
          title: "@rychillie",
          subtitle: copy.youtubeSubscribers,
          href: Site.Link.youtube,
          leading: .avatar(
            image: "youtube-avatar.png",
            badge: CardBadge(light: "youtube-light.svg", dark: "youtube-dark.svg", className: "h-[8.438px] w-3")
          )
        )
        siteCard(
          title: "@rychillie",
          subtitle: copy.communityMembers,
          href: Site.Link.community,
          leading: .avatar(
            image: "discord-avatar.png",
            badge: CardBadge(light: "discord.svg", dark: nil, className: "h-[9.328px] w-3")
          )
        )
      }

      homeText(copy.homeSocialText)

      if !latestNotes.isEmpty {
        div(class: Theme.Home.list) {
          latestNotes.map { note in
            noteCard(note, locale: locale)
          }
        }
      }

      homeText(copy.homeLatestNotesText)

      div(class: Theme.Home.brandGrid) {
        siteCard(title: "Apple", leading: .icon(light: "apple-light.svg", dark: "apple-dark.svg", className: Theme.Card.brandAppleIcon), showsArrow: false)
        siteCard(title: "Chargeblast", leading: .image(name: "chargeblast.png", className: Theme.Card.brandLogo), showsArrow: false)
        siteCard(title: "Anthropic", leading: .icon(light: "anthropic-light.svg", dark: "anthropic-dark.svg", className: Theme.Card.brandIcon), showsArrow: false)
        siteCard(title: "OpenAI", leading: .icon(light: "openai-light.svg", dark: "openai-dark.svg", className: Theme.Card.brandOpenAIIcon), showsArrow: false)
      }

      homeText(copy.homeBrandText)

    }
  }
}
