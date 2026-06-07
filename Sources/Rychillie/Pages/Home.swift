import HTML
import Saga

func renderHome(context: PageRenderingContext) -> Node {
  let locale = Site.currentLocale(context.locale)
  let copy = Site.copy(for: locale)
  let latestNotes = Array(context.allItems
    .compactMap { $0 as? Item<NoteMetadata> }
    .sorted { $0.date > $1.date }
    .prefix(3))
  let canonicalPath = context.translations[locale] ?? Site.localizedHomePath(for: locale)

  return baseHtml(
    title: Site.name,
    description: copy.intro,
    canonicalPath: canonicalPath,
    locale: locale,
    translations: context.translations,
    preloadImages: [
      HomeResponsiveImage.bentoPortrait2.preload,
    ]
  ) {
    pageFrame(activeSection: .home, locale: locale, translations: context.translations) {
      section(class: Theme.Home.intro, id: "about") {
        h1(class: Theme.Home.introTitle) { copy.introTitle }
        homeText(copy.intro)
      }

      div(class: Theme.Home.bento) {
        div(class: Theme.Home.bentoColumn) {
          responsiveHomeImage(.bentoPortrait1, alt: "Rychillie portrait", class: Theme.Home.imageTall, loading: "eager")
          responsiveHomeImage(.bentoWide1, alt: "BrazilJS event", class: Theme.Home.imageShort, loading: "eager")
        }
        div(class: Theme.Home.bentoColumn) {
          responsiveHomeImage(.bentoWide2, alt: "Rychillie speaking", class: Theme.Home.imageShort, loading: "eager")
          responsiveHomeImage(.bentoPortrait2, alt: "Rychillie on stage", class: Theme.Home.imageTall, loading: "eager", fetchPriority: "high")
        }
      }

      homeText(copy.homePrimaryText)

      div(class: Theme.Home.socialCards) {
        siteCard(
          title: "@rychillie",
          subtitle: copy.youtubeSubscribers,
          href: Site.Link.youtube,
          leading: .avatar(
            image: .youtubeAvatar,
            badge: CardBadge(light: "youtube-light.svg", dark: "youtube-dark.svg", className: "h-[8.438px] w-3")
          )
        )
        siteCard(
          title: "@rychillie",
          subtitle: copy.communityMembers,
          href: Site.Link.community,
          leading: .avatar(
            image: .discordAvatar,
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
        siteCard(title: "Chargeblast", leading: .responsiveImage(image: .chargeblast, className: Theme.Card.brandLogo), showsArrow: false)
        siteCard(title: "Anthropic", leading: .icon(light: "anthropic-light.svg", dark: "anthropic-dark.svg", className: Theme.Card.brandIcon), showsArrow: false)
        siteCard(title: "OpenAI", leading: .icon(light: "openai-light.svg", dark: "openai-dark.svg", className: Theme.Card.brandOpenAIIcon), showsArrow: false)
      }

      homeText(copy.homeBrandText)

    }
  }
}
