import HTML
import Saga

func renderNotes(context: PageRenderingContext) -> Node {
  let notes = context.allItems
    .compactMap { $0 as? Item<NoteMetadata> }
    .sorted { $0.date > $1.date }

  return baseHtml(title: "Notes") {
    pageFrame(activeSection: .notes) {
      section(class: Theme.Notes.header) {
        h1(class: Theme.Notes.pageTitle) { "Notes" }
        p(class: Theme.Notes.pageText) {
          "Writing, talks, experiments, and technical notes."
        }
      }

      if notes.isEmpty {
        p(class: Theme.Notes.empty) { "No notes published yet." }
      } else {
        div(class: Theme.Notes.list) {
          notes.map { note in
            noteCard(note)
          }
        }
      }
    }
  }
}
