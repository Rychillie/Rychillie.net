import Saga

enum NoteType: String, Codable {
  case article
  case talk
  case video
  case other

  var label: String {
    label(locale: Site.defaultLocale)
  }

  func label(locale: String) -> String {
    Site.copy(for: locale).label(for: self)
  }
}

struct NoteMetadata: Metadata {
  let tags: [String]
  var type: NoteType?
  var summary: String?

  var displayType: NoteType {
    type ?? .article
  }
}
