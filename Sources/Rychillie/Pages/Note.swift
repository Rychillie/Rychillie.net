import HTML
import Moon
import Saga

func renderNote(context: ItemRenderingContext<NoteMetadata>) -> Node {
  baseHtml(title: context.item.title) {
    pageFrame(activeSection: .notes) {
      article(class: Theme.Notes.article) {
        header(class: Theme.Notes.articleHeader) {
          a(class: Theme.Notes.backLink, href: Site.notesPath) { "notes" }
          h1(class: Theme.Notes.pageTitle) { context.item.title }
          div(class: Theme.Notes.metaRow) {
            p(class: Theme.Notes.cardMeta) { "Note" }
            span(class: Theme.Notes.metaDot) {}
            p(class: Theme.Notes.cardMeta) { Site.displayDate(context.item.date) }
          }
          tagList(context.item.metadata.tags)
        }
        div(class: Theme.Markdown.content) {
          Node.raw(Moon.shared.highlightCodeBlocks(in: context.item.body))
        }
      }
    }
  }
}
