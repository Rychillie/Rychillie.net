import Saga

enum NoteType: String, Codable {
  case article
  case talk
  case video
  case other

  var label: String {
    switch self {
    case .article: "Article"
    case .talk: "Talk"
    case .video: "Video"
    case .other: "Other"
    }
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
