import Foundation

enum Site {
  static let name = "Rychillie"
  static let homePath = "/"
  static let notesPath = "/notes/"
  static let aboutPath = "/about/"
  static let homeAssetPath = "/static/home/"
  static let googleFontsHref = "https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;600;700&family=Lora:wght@700&display=swap"
  static let intro = "A Brazilian Software Engineer creating content and sharing knowledge over the internet. My experience involves pushing the limits of what we can build with code. Design and technology lover, collaborating with Open Source projects."

  enum Link {
    static let saga = "https://getsaga.dev/"
    static let sagaDocs = "https://getsaga.dev/docs/"
    static let youtube = "https://www.youtube.com/@rychillie"
    static let community = saga
    static let follow = saga
    static let emailUpdates = sagaDocs
  }

  static func displayDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US")
    formatter.dateFormat = "MMMM d, yyyy"
    return formatter.string(from: date)
  }
}

enum SiteSection {
  case home
  case notes
  case about
}
