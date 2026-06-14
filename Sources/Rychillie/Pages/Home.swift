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
      ResponsiveImage.bentoPortrait2.preload,
    ]
  ) {
    pageFrame(activeSection: .home, locale: locale, translations: context.translations) {
      section(class: Theme.Home.intro, id: "about") {
        h1(class: Theme.Home.introTitle) {
          copy.introTitle
          " "
          waveAnimation(alt: copy.introWaveAlt)
        }
        homeText(copy.intro)
      }

      div(class: Theme.Home.bento) {
        homeBentoColumns(locale: locale).map { column in
          div(class: Theme.Home.bentoColumn) {
            column.map { item in
              homeBentoLink(item)
            }
          }
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
            badge: CardBadge(icon: .youtube, className: "block h-[8.438px] w-3 text-white dark:text-neutral-950")
          ),
          opensInNewTab: true
        )
        siteCard(
          title: "@rychillie",
          subtitle: copy.communityMembers,
          href: Site.Link.community,
          leading: .avatar(
            image: .discordAvatar,
            badge: CardBadge(icon: .discord, className: "block h-[9.328px] w-3")
          ),
          opensInNewTab: true
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
        siteCard(title: "Apple", leading: .icon(.apple, className: Theme.Card.brandAppleIcon), showsArrow: false)
        siteCard(title: "Chargeblast", leading: .responsiveImage(image: .chargeblast, className: Theme.Card.brandLogo), showsArrow: false)
        siteCard(title: "Anthropic", leading: .icon(.anthropic, className: Theme.Card.brandIcon), showsArrow: false)
        siteCard(title: "OpenAI", leading: .icon(.openAI, className: Theme.Card.brandOpenAIIcon), showsArrow: false)
      }

      homeText(copy.homeBrandText)

    }
  }
}

private enum HomeBentoVariant {
  case tall
  case short

  var imageClass: String {
    switch self {
    case .tall: Theme.Home.imageTall
    case .short: Theme.Home.imageShort
    }
  }
}

private struct HomeBentoItem {
  let title: String
  let href: String
  let image: ResponsiveImage
  let alt: String
  let variant: HomeBentoVariant
  let loading: String
  let fetchPriority: String?

  init(
    title: String,
    href: String,
    image: ResponsiveImage,
    alt: String,
    variant: HomeBentoVariant,
    loading: String = "lazy",
    fetchPriority: String? = nil
  ) {
    self.title = title
    self.href = href
    self.image = image
    self.alt = alt
    self.variant = variant
    self.loading = loading
    self.fetchPriority = fetchPriority
  }
}

private func homeBentoColumns(locale: String) -> [[HomeBentoItem]] {
  return [
    [
      HomeBentoItem(
        title: "Build in Public Meetup 🥑💬",
        href: homeNotePath(slug: "build-in-public-meetup-2026", locale: locale),
        image: .bentoPortrait1,
        alt: "Build in Public Meetup",
        variant: .tall,
        loading: "eager"
      ),
      HomeBentoItem(
        title: "BrazilJS Conf 2024",
        href: homeNotePath(slug: "braziljs-conf-2024", locale: locale),
        image: .bentoWide1,
        alt: "BrazilJS Conf 2024",
        variant: .short,
        loading: "eager"
      ),
    ],
    [
      HomeBentoItem(
        title: "ClawCon Belo Horizonte presented by Hostinger",
        href: homeNotePath(slug: "clawcon-belo-horizonte-2026", locale: locale),
        image: .bentoWide2,
        alt: "ClawCon Belo Horizonte presentation",
        variant: .short,
        loading: "eager"
      ),
      HomeBentoItem(
        title: "ClawCon Belo Horizonte presented by Hostinger",
        href: homeNotePath(slug: "clawcon-belo-horizonte-2026", locale: locale),
        image: .bentoPortrait2,
        alt: "Rychillie at ClawCon Belo Horizonte",
        variant: .tall,
        loading: "eager",
        fetchPriority: "high"
      ),
    ],
  ]
}

private func homeNotePath(slug: String, locale: String) -> String {
  "\(Site.localizedNotesPath(for: locale))\(slug)/"
}

private func homeBentoLink(_ item: HomeBentoItem) -> Node {
  a(class: Theme.Home.bentoLink, href: item.href) {
    responsiveImage(
      item.image,
      alt: item.alt,
      class: item.variant.imageClass,
      loading: item.loading,
      fetchPriority: item.fetchPriority
    )
    div(class: Theme.Home.bentoOverlay) {}
    div(class: Theme.Home.bentoContent) {
      span(class: Theme.Home.bentoTitle) { item.title }
      siteIcon(.arrowUpRight, class: Theme.Home.bentoArrow)
    }
  }
}
