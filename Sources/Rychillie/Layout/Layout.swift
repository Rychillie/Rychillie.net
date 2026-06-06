import HTML
import Saga

func baseHtml(
  title pageTitle: String,
  locale: String,
  @NodeBuilder children: () -> NodeConvertible
) -> Node {
  html(lang: locale) {
    head {
      meta(charset: "utf-8")
      meta(content: "width=device-width, initial-scale=1", name: "viewport")
      title { pageTitle }
      link(href: Site.googleFontsHref, rel: "stylesheet")
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
