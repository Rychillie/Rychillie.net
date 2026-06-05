import HTML
import Saga

func renderNote(context: ItemRenderingContext<NoteMetadata>) -> Node {
  baseHtml(title: context.item.title) {
    pageFrame(activeSection: .notes) {
      article(class: Theme.Notes.article) {
        header(class: Theme.Notes.articleHeader) {
          a(class: Theme.Notes.backLink, href: Site.notesPath) { "notes" }
          h1(class: Theme.Notes.pageTitle) { context.item.title }
          div(class: Theme.Card.metaRow) {
            p(class: Theme.Card.meta) { context.item.metadata.displayType.label }
            span(class: Theme.Card.metaDot) {}
            p(class: Theme.Card.meta) { Site.displayDate(context.item.date) }
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
