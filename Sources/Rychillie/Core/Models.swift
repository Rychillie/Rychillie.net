import Saga

enum NoteType: String, Codable {
  case article
  case review
  case talk
  case video
  case participated
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

enum GameStatus: String, Codable {
  case playing
  case completed
  case backlog
  case wishlist

  func label(locale: String) -> String {
    Site.copy(for: locale).label(for: self)
  }
}

enum GameCollection: String, Codable {
  case owned
  case psnPlus = "psn_plus"
  case steam
  case wishlist

  func label(locale: String) -> String {
    Site.copy(for: locale).label(for: self)
  }
}

enum GameFormat: String, Codable {
  case digital
  case physical
  case unknown

  func label(locale: String) -> String {
    Site.copy(for: locale).label(for: self)
  }
}

struct GameMetadata: Metadata {
  let status: GameStatus
  let system: String
  var collection: GameCollection?
  var format: GameFormat?
  var playableOn: String?
  var edition: String?
  var started: String?
  var finished: String?
  var playtime: String?
  var beaten: Bool?
  var cover: String?
  var gallery: [String]?
  var reviewSlug: String?
  var featuredOrder: Int?
  var updated: String?

  enum CodingKeys: String, CodingKey {
    case status
    case system
    case collection
    case format
    case playableOn = "playable_on"
    case edition
    case started
    case finished
    case playtime
    case beaten
    case cover
    case gallery
    case reviewSlug = "review_slug"
    case featuredOrder = "featured_order"
    case updated
  }
}
