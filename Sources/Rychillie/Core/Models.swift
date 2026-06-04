import Saga

struct NoteMetadata: Metadata {
  let tags: [String]
  var summary: String?
}
