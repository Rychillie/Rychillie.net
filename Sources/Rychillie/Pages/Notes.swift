import HTML
import Saga

func renderNotes(context: PageRenderingContext) -> Node {
  let locale = Site.currentLocale(context.locale)
  let copy = Site.copy(for: locale)
  let canonicalPath = context.translations[locale] ?? Site.localizedNotesPath(for: locale)
  let notes = context.allItems
    .compactMap { $0 as? Item<NoteMetadata> }
    .filter { $0.metadata.isPublished }
    .sorted { $0.date > $1.date }

  return baseHtml(
    title: copy.notesTitle,
    description: copy.notesDescription,
    canonicalPath: canonicalPath,
    locale: locale,
    translations: context.translations
  ) {
    pageFrame(activeSection: .notes, locale: locale, translations: context.translations) {
      section(class: Theme.Notes.header) {
        h1(class: Theme.Notes.pageTitle) { copy.notesTitle }
        p(class: Theme.Notes.pageText) {
          copy.notesDescription
        }
      }

      if notes.isEmpty {
        p(class: Theme.Notes.empty) { copy.noNotes }
      } else {
        div(class: Theme.Notes.list) {
          notes.map { note in
            noteCard(note, locale: locale)
          }
        }
      }
    }
  }
}
