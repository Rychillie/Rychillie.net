import HTML
import Saga

func renderAbout(context: PageRenderingContext) -> Node {
  let locale = Site.currentLocale(context.locale)
  let copy = Site.copy(for: locale)

  return baseHtml(title: copy.aboutTitle, locale: locale) {
    pageFrame(activeSection: .about, locale: locale, translations: context.translations) {
      section(class: Theme.Notes.header) {
        h1(class: Theme.Notes.pageTitle) { copy.aboutTitle }
        p(class: Theme.Notes.pageText) { copy.intro }
      }
    }
  }
}
