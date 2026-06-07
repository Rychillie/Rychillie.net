import HTML
import Saga

func renderAbout(context: PageRenderingContext) -> Node {
  let locale = Site.currentLocale(context.locale)
  let copy = Site.copy(for: locale)
  let canonicalPath = context.translations[locale] ?? Site.localizedAboutPath(for: locale)

  return baseHtml(
    title: copy.aboutTitle,
    description: copy.intro,
    canonicalPath: canonicalPath,
    locale: locale,
    translations: context.translations
  ) {
    pageFrame(activeSection: .about, locale: locale, translations: context.translations) {
      section(class: Theme.Notes.header) {
        h1(class: Theme.Notes.pageTitle) { copy.aboutTitle }
        p(class: Theme.Notes.pageText) { copy.intro }
      }
    }
  }
}
