import HTML
import Saga

func homeAsset(_ name: String) -> String {
  "\(Site.homeAssetPath)\(name)"
}

func assetImage(_ name: String, alt: String, class className: String) -> Node {
  img(alt: alt, class: className, src: homeAsset(name))
}

func themedIcon(
  light: String,
  dark: String,
  alt: String = "",
  class className: String
) -> Node {
  span(class: className) {
    img(alt: alt, class: "size-full \(Theme.Shell.hiddenDark)", src: homeAsset(light))
    img(alt: alt, class: "size-full \(Theme.Shell.visibleDark)", src: homeAsset(dark))
  }
}

func homeCard(
  title: String,
  subtitle: String,
  avatar: String,
  badgeLight: String,
  badgeDark: String? = nil,
  badgeClass: String,
  href: String? = nil
) -> Node {
  if let href {
    return a(class: Theme.Home.card, href: href) {
      homeCardContents(
        title: title,
        subtitle: subtitle,
        avatar: avatar,
        badgeLight: badgeLight,
        badgeDark: badgeDark,
        badgeClass: badgeClass
      )
    }
  }

  return div(class: Theme.Home.cardStatic) {
    homeCardContents(
      title: title,
      subtitle: subtitle,
      avatar: avatar,
      badgeLight: badgeLight,
      badgeDark: badgeDark,
      badgeClass: badgeClass
    )
  }
}

@NodeBuilder
func homeCardContents(
  title: String,
  subtitle: String,
  avatar: String,
  badgeLight: String,
  badgeDark: String?,
  badgeClass: String
) -> NodeConvertible {
  div(class: Theme.Home.profileGroup) {
    div(class: Theme.Home.profile) {
      assetImage(avatar, alt: "\(title) profile photo", class: Theme.Home.profileImage)
      span(class: Theme.Home.profileBadge) {
        if let badgeDark {
          themedIcon(light: badgeLight, dark: badgeDark, class: badgeClass)
        } else {
          assetImage(badgeLight, alt: "", class: badgeClass)
        }
      }
    }
    div(class: Theme.Home.cardDetails) {
      p(class: Theme.Home.cardTitle) { title }
      p(class: Theme.Home.cardMeta) { subtitle }
    }
  }
  themedIcon(light: "arrow-card-light.svg", dark: "arrow-card-dark.svg", class: Theme.Home.arrow)
}

func homeText(_ text: String) -> Node {
  p(class: Theme.Home.text) { text }
}

func homeContentItem(title: String, kind: String, date: String) -> Node {
  div(class: Theme.Home.listCard) {
    div(class: Theme.Home.listDetails) {
      p(class: Theme.Home.cardTitle) { title }
      div(class: Theme.Home.metaRow) {
        p(class: Theme.Home.cardMeta) { kind }
        span(class: Theme.Home.metaDot) {}
        p(class: Theme.Home.cardMeta) { date }
      }
    }
    themedIcon(light: "arrow-card-light.svg", dark: "arrow-card-dark.svg", class: Theme.Home.arrow)
  }
}

func brandChip(
  name: String,
  lightIcon: String? = nil,
  darkIcon: String? = nil,
  image: String? = nil,
  iconClass: String = Theme.Home.brandIcon
) -> Node {
  div(class: Theme.Home.brandChip) {
    if let image {
      assetImage(image, alt: "", class: Theme.Home.brandLogo)
    } else if let lightIcon, let darkIcon {
      themedIcon(light: lightIcon, dark: darkIcon, class: iconClass)
    }
    p(class: Theme.Home.cardTitle) { name }
  }
}

func homeSocialAction(_ text: String) -> Node {
  span(class: Theme.Home.socialAction) {
    themedIcon(light: "arrow-inline-light.svg", dark: "arrow-inline-dark.svg", class: Theme.Home.inlineArrow)
    span { text }
  }
}

func noteCard(_ note: Item<NoteMetadata>) -> Node {
  a(class: Theme.Notes.card, href: note.url) {
    div(class: Theme.Notes.cardDetails) {
      p(class: Theme.Notes.cardTitle) { note.title }
      if let summary = note.metadata.summary {
        p(class: Theme.Notes.cardSummary) { summary }
      }
      div(class: Theme.Notes.metaRow) {
        p(class: Theme.Notes.cardMeta) { "Note" }
        span(class: Theme.Notes.metaDot) {}
        p(class: Theme.Notes.cardMeta) { Site.displayDate(note.date) }
      }
    }
    themedIcon(light: "arrow-card-light.svg", dark: "arrow-card-dark.svg", class: Theme.Notes.arrow)
  }
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
