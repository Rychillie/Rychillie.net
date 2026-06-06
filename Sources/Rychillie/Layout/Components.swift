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

struct CardBadge {
  let light: String
  let dark: String?
  let className: String
}

enum CardLeading {
  case avatar(image: String, badge: CardBadge)
  case icon(light: String, dark: String, className: String)
  case image(name: String, className: String)
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
        assetImage(image, alt: "\(title) profile photo", class: Theme.Card.avatarImage)
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
