import HTML
import Saga

struct LocaleAlternate {
  let locale: String
  let url: String
}

struct ImagePreload {
  let href: String
  let srcset: String
  let sizes: String
  let type: String
}

func baseHtml(
  title pageTitle: String,
  description: String,
  canonicalPath: String,
  locale: String,
  translations: [String: String] = [:],
  ogType: String = "website",
  markdownAlternatePath: String? = nil,
  preloadImages: [ImagePreload] = [],
  @NodeBuilder children: () -> NodeConvertible
) -> Node {
  let documentTitle = Site.pageTitle(pageTitle)
  let canonicalURL = Site.absoluteURL(for: canonicalPath)
  let alternates = translations
    .map { LocaleAlternate(locale: $0.key, url: Site.absoluteURL(for: $0.value)) }
    .sorted { $0.locale < $1.locale }
  let defaultAlternateURL = alternates.first { $0.locale == Site.defaultLocale }?.url

  return html(lang: locale) {
    head {
      meta(charset: "utf-8")
      meta(content: "width=device-width, initial-scale=1", name: "viewport")
      meta(content: description, name: "description")
      meta(content: "index, follow", name: "robots")
      title { documentTitle }
      link(href: "/favicon.ico", rel: "icon", sizes: "any")
      link(href: canonicalURL, rel: "canonical")
      alternates.map { alternate in
        link(href: alternate.url, hreflang: alternate.locale, rel: "alternate")
      }
      if let defaultAlternateURL {
        link(href: defaultAlternateURL, hreflang: "x-default", rel: "alternate")
      }
      if let markdownAlternatePath {
        link(href: Site.absoluteURL(for: markdownAlternatePath), rel: "alternate", type: "text/markdown")
      }
      meta(content: documentTitle, customAttributes: ["property": "og:title"])
      meta(content: description, customAttributes: ["property": "og:description"])
      meta(content: canonicalURL, customAttributes: ["property": "og:url"])
      meta(content: Site.name, customAttributes: ["property": "og:site_name"])
      meta(content: Site.openGraphLocale(for: locale), customAttributes: ["property": "og:locale"])
      meta(content: ogType, customAttributes: ["property": "og:type"])
      meta(content: "summary", name: "twitter:card")
      meta(content: documentTitle, name: "twitter:title")
      meta(content: description, name: "twitter:description")
      preloadImages.map { image in
        link(
          as: "image",
          href: image.href,
          imagesizes: image.sizes,
          imagesrcset: image.srcset,
          rel: "preload",
          type: image.type
        )
      }
      link(href: Saga.hashed("/static/styles.css"), rel: "stylesheet")
    }
    body(class: Theme.Shell.body) {
      main(class: Theme.Shell.main) {
        children()
      }
    }
  }
}

func pageFrame(
  activeSection: SiteSection,
  locale: String,
  translations: [String: String],
  @NodeBuilder content: () -> NodeConvertible
) -> Node {
  div(class: Theme.Shell.stage) {
    siteNav(activeSection: activeSection, locale: locale)
    div(class: Theme.Shell.container) {
      content()
      siteFooter(locale: locale, translations: translations)
    }
    div(class: Theme.Shell.bottomFade) {}
  }
}

func siteNav(activeSection: SiteSection, locale: String) -> Node {
  let copy = Site.copy(for: locale)

  return nav(class: Theme.Shell.topNav) {
    navLink(title: copy.homeNav, href: Site.localizedHomePath(for: locale), section: .home, activeSection: activeSection)
    navLink(title: copy.notesNav, href: Site.localizedNotesPath(for: locale), section: .notes, activeSection: activeSection)
    navLink(title: copy.aboutNav, href: Site.localizedAboutPath(for: locale), section: .about, activeSection: activeSection)
  }
}

private func navLink(title: String, href: String, section: SiteSection, activeSection: SiteSection) -> Node {
  a(class: section == activeSection ? Theme.Shell.navActive : Theme.Shell.navLink, href: href) {
    title
  }
}

private func siteFooter(locale: String, translations: [String: String]) -> Node {
  let copy = Site.copy(for: locale)

  return footer(class: Theme.Shell.footerActions) {
    inlineActionLink(title: copy.followLink, href: Site.Link.follow)
    inlineActionLink(title: copy.emailUpdatesLink, href: Site.Link.emailUpdates)

    if let translationURL = languageSwitchURL(currentLocale: locale, translations: translations) {
      inlineActionLink(title: copy.languageSwitchLink, href: translationURL)
    }
  }
}

private func languageSwitchURL(currentLocale: String, translations: [String: String]) -> String? {
  let targetLocale = currentLocale == Site.portugueseLocale ? Site.defaultLocale : Site.portugueseLocale
  return translations[targetLocale]
}
