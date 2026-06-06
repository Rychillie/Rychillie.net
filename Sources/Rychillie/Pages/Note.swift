import HTML
import Saga

func renderNote(context: ItemRenderingContext<NoteMetadata>) -> Node {
  let locale = Site.currentLocale(context.locale)
  let copy = Site.copy(for: locale)

  return baseHtml(title: context.item.title, locale: locale) {
    pageFrame(activeSection: .notes, locale: locale, translations: context.translations) {
      article(class: Theme.Notes.article) {
        header(class: Theme.Notes.articleHeader) {
          a(class: Theme.Notes.backLink, href: Site.localizedNotesPath(for: locale)) { copy.notesNav }
          h1(class: Theme.Notes.pageTitle) { context.item.title }
          div(class: Theme.Card.metaRow) {
            p(class: Theme.Card.meta) { context.item.metadata.displayType.label(locale: locale) }
            span(class: Theme.Card.metaDot) {}
            p(class: Theme.Card.meta) { Site.displayDate(context.item.date, locale: locale) }
          }
          tagList(context.item.metadata.tags)
        }
        div(class: Theme.Markdown.content) {
          Node.raw(context.item.body)
        }
      }
    }
  }
}
