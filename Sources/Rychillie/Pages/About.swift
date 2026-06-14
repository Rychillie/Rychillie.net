import HTML
import Saga

func renderAbout(context: PageRenderingContext) -> Node {
  let locale = Site.currentLocale(context.locale)
  let copy = Site.copy(for: locale)
  let canonicalPath = context.translations[locale] ?? Site.localizedAboutPath(for: locale)

  return baseHtml(
    title: copy.aboutTitle,
    description: copy.aboutLead,
    canonicalPath: canonicalPath,
    locale: locale,
    translations: context.translations
  ) {
    pageFrame(activeSection: .about, locale: locale, translations: context.translations) {
      section(class: Theme.About.header) {
        h1(class: Theme.About.pageTitle) { copy.aboutTitle }
        p(class: Theme.About.lead) { copy.aboutLead }
      }

      div(class: Theme.About.body) {
        copy.aboutParagraphs.map { paragraph in
          p(class: Theme.About.text) { paragraph }
        }
      }

      section(class: Theme.About.career) {
        h2(class: Theme.About.careerTitle) { copy.aboutCareerTitle }
        ul(class: Theme.About.careerList) {
          copy.aboutCareerItems.map { item in
            li(class: Theme.About.careerItem) {
              span(class: Theme.About.careerBullet) {}
              span(class: Theme.About.careerItemText) { item }
            }
          }
        }
      }
    }
  }
}
