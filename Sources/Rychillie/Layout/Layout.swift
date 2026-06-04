import HTML
import Saga

func baseHtml(
  title pageTitle: String,
  @NodeBuilder children: () -> NodeConvertible
) -> Node {
  html(lang: "en-US") {
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

func pageFrame(activeSection: SiteSection, @NodeBuilder content: () -> NodeConvertible) -> Node {
  div(class: Theme.Shell.stage) {
    siteNav(activeSection: activeSection)
    div(class: Theme.Shell.container) {
      content()
    }
    div(class: Theme.Shell.bottomFade) {}
  }
}

func siteNav(activeSection: SiteSection) -> Node {
  nav(class: Theme.Shell.topNav) {
    navLink(title: "home", href: Site.homePath, section: .home, activeSection: activeSection)
    navLink(title: "notes", href: Site.notesPath, section: .notes, activeSection: activeSection)
    navLink(title: "about", href: Site.aboutPath, section: .about, activeSection: activeSection)
  }
}

private func navLink(title: String, href: String, section: SiteSection, activeSection: SiteSection) -> Node {
  a(class: section == activeSection ? Theme.Shell.navActive : Theme.Shell.navLink, href: href) {
    title
  }
}
