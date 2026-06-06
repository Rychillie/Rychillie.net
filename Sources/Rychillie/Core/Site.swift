import Foundation

enum Site {
  static let name = "Rychillie"
  static let defaultLocale = "en"
  static let portugueseLocale = "pt-BR"
  static let supportedLocales = [defaultLocale, portugueseLocale]
  static let homePath = "/"
  static let notesPath = "/notes/"
  static let aboutPath = "/about/"
  static let homeAssetPath = "/static/home/"
  static let googleFontsHref = "https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;600;700&family=Lora:wght@700&display=swap"

  enum Link {
    static let saga = "https://getsaga.dev/"
    static let sagaDocs = "https://getsaga.dev/docs/"
    static let youtube = "https://www.youtube.com/@rychillie"
    static let community = saga
    static let follow = saga
    static let emailUpdates = sagaDocs
  }

  static func currentLocale(_ locale: String?) -> String {
    locale ?? defaultLocale
  }

  static func copy(for locale: String) -> SiteCopy {
    locale == portugueseLocale ? .portuguese : .english
  }

  static func localizedHomePath(for locale: String) -> String {
    locale == defaultLocale ? homePath : "/\(locale)/"
  }

  static func localizedNotesPath(for locale: String) -> String {
    locale == defaultLocale ? notesPath : "/\(locale)/notes/"
  }

  static func localizedAboutPath(for locale: String) -> String {
    locale == defaultLocale ? aboutPath : "/\(locale)/about/"
  }

  static func displayDate(_ date: Date, locale: String) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: locale == portugueseLocale ? "pt_BR" : "en_US")
    formatter.dateFormat = locale == portugueseLocale ? "d 'de' MMMM 'de' yyyy" : "MMMM d, yyyy"
    return formatter.string(from: date)
  }
}

struct SiteCopy {
  let homeNav: String
  let notesNav: String
  let aboutNav: String
  let introTitle: String
  let intro: String
  let homePrimaryText: String
  let homeSocialText: String
  let homeLatestNotesText: String
  let homeBrandText: String
  let youtubeSubscribers: String
  let communityMembers: String
  let followLink: String
  let emailUpdatesLink: String
  let languageSwitchLink: String
  let notesTitle: String
  let notesDescription: String
  let noNotes: String
  let aboutTitle: String
  let articleLabel: String
  let talkLabel: String
  let videoLabel: String
  let otherLabel: String

  func label(for noteType: NoteType) -> String {
    switch noteType {
    case .article: articleLabel
    case .talk: talkLabel
    case .video: videoLabel
    case .other: otherLabel
    }
  }

  static let english = SiteCopy(
    homeNav: "home",
    notesNav: "notes",
    aboutNav: "about",
    introTitle: "Hey, I'm Rychillie 👋",
    intro: "A Brazilian Software Engineer creating content and sharing knowledge over the internet. My experience involves pushing the limits of what we can build with code. Design and technology lover, collaborating with Open Source projects.",
    homePrimaryText: "Pariatur dolore excepteur officia exercitation minim laborum est fugiat. Anim fugiat eiusmod mollit magna eu ipsum fugiat pariatur dolor deserunt magna. Nostrud non eiusmod veniam enim elit minim sint consequat mollit Lorem minim. Consectetur dolore nisi ex ex velit aute cillum eiusmod commodo eiusmod.",
    homeSocialText: "Pariatur dolore excepteur officia exercitation minim laborum est fugiat. Anim fugiat eiusmod mollit magna eu ipsum fugiat pariatur dolor deserunt magna. Nostrud non eiusmod veniam enim elit minim sint consequat mollit Lorem minim.",
    homeLatestNotesText: "Pariatur dolore excepteur officia exercitation minim laborum est fugiat.",
    homeBrandText: "Pariatur dolore excepteur officia exercitation minim laborum est fugiat. Anim fugiat eiusmod mollit magna eu ipsum fugiat pariatur dolor deserunt magna.",
    youtubeSubscribers: "1,550 subscribers",
    communityMembers: "12,100 members",
    followLink: "follow me",
    emailUpdatesLink: "get email updates",
    languageSwitchLink: "Change to Portuguese",
    notesTitle: "Notes",
    notesDescription: "Writing, talks, experiments, and technical notes.",
    noNotes: "No notes published yet.",
    aboutTitle: "About",
    articleLabel: "Article",
    talkLabel: "Talk",
    videoLabel: "Video",
    otherLabel: "Other"
  )

  static let portuguese = SiteCopy(
    homeNav: "início",
    notesNav: "notas",
    aboutNav: "sobre",
    introTitle: "Oi, eu sou Rychillie 👋",
    intro: "Um Engenheiro de Software brasileiro criando conteúdo e compartilhando conhecimento pela internet. Minha experiência envolve explorar os limites do que conseguimos construir com código. Amo design e tecnologia, e colaboro com projetos Open Source.",
    homePrimaryText: "Pariatur dolore excepteur officia exercitation minim laborum est fugiat. Anim fugiat eiusmod mollit magna eu ipsum fugiat pariatur dolor deserunt magna. Nostrud non eiusmod veniam enim elit minim sint consequat mollit Lorem minim. Consectetur dolore nisi ex ex velit aute cillum eiusmod commodo eiusmod.",
    homeSocialText: "Pariatur dolore excepteur officia exercitation minim laborum est fugiat. Anim fugiat eiusmod mollit magna eu ipsum fugiat pariatur dolor deserunt magna. Nostrud non eiusmod veniam enim elit minim sint consequat mollit Lorem minim.",
    homeLatestNotesText: "Pariatur dolore excepteur officia exercitation minim laborum est fugiat.",
    homeBrandText: "Pariatur dolore excepteur officia exercitation minim laborum est fugiat. Anim fugiat eiusmod mollit magna eu ipsum fugiat pariatur dolor deserunt magna.",
    youtubeSubscribers: "1.550 inscritos",
    communityMembers: "12.100 membros",
    followLink: "me acompanhe",
    emailUpdatesLink: "receber atualizações por email",
    languageSwitchLink: "Trocar para Inglês",
    notesTitle: "Notas",
    notesDescription: "Textos, talks, experimentos e notas técnicas.",
    noNotes: "Nenhuma nota publicada ainda.",
    aboutTitle: "Sobre",
    articleLabel: "Artigo",
    talkLabel: "Talk",
    videoLabel: "Vídeo",
    otherLabel: "Outro"
  )
}

enum SiteSection {
  case home
  case notes
  case about
}
