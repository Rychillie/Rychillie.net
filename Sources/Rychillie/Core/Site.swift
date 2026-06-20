import Foundation

enum Site {
  static let name = "Rychillie"
  static let baseURLString = "https://rychillie.pages.dev"
  static let baseURL = URL(string: baseURLString)!
  static let defaultLocale = "en"
  static let portugueseLocale = "pt-BR"
  static let supportedLocales = [defaultLocale, portugueseLocale]
  static let homePath = "/"
  static let notesPath = "/notes/"
  static let aboutPath = "/about/"
  static let gamesPath = "/games/"
  static let imageAssetPath = "/static/images/"

  enum Link {
    static let saga = "https://getsaga.dev/"
    static let sagaDocs = "https://getsaga.dev/docs/"
    static let youtube = "https://www.youtube.com/@rychillie"
    static let community = "https://discord.gg/haQ67Tm9za"
    static let follow = saga
    static let emailUpdates = sagaDocs
  }

  static func currentLocale(_ locale: String?) -> String {
    locale ?? defaultLocale
  }

  static func pageTitle(_ title: String) -> String {
    title == name ? name : "\(title) | \(name)"
  }

  static func absoluteURL(for path: String) -> String {
    if path.hasPrefix("https://") || path.hasPrefix("http://") {
      return path
    }

    let normalizedPath = path.hasPrefix("/") ? path : "/\(path)"
    return "\(baseURLString)\(normalizedPath)"
  }

  static func openGraphLocale(for locale: String) -> String {
    locale == portugueseLocale ? "pt_BR" : "en_US"
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

  static func localizedGamesPath(for locale: String) -> String {
    locale == defaultLocale ? gamesPath : "/\(locale)/games/"
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
  let introWaveAlt: String
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
  let aboutLead: String
  let aboutParagraphs: [String]
  let aboutGamesTitle: String
  let aboutGamesDescription: String
  let gamesPageTitle: String
  let gamesPageDescription: String
  let gamesViewAllAction: String
  let gamesFilterAllAction: String
  let aboutCareerTitle: String
  let aboutCareerItems: [String]
  let gameOpenDetailsAction: String
  let gameCloseAction: String
  let gameReviewAction: String
  let gameGalleryTitle: String
  let gameGalleryPreviousAction: String
  let gameGalleryNextAction: String
  let gameGallerySelectAction: String
  let gameSystemLabel: String
  let gamePlayableOnLabel: String
  let gameLibraryLabel: String
  let gameFormatLabel: String
  let gameEditionLabel: String
  let gameStartedLabel: String
  let gameFinishedLabel: String
  let gamePlaytimeLabel: String
  let gameStatusPlaying: String
  let gameStatusCompleted: String
  let gameStatusBacklog: String
  let gameStatusWishlist: String
  let gameCollectionOwned: String
  let gameCollectionPsnPlus: String
  let gameCollectionSteam: String
  let gameCollectionWishlist: String
  let gameFormatDigital: String
  let gameFormatPhysical: String
  let gameFormatUnknown: String
  let copyLinkAction: String
  let copyMarkdownAction: String
  let copiedAction: String
  let articleLabel: String
  let talkLabel: String
  let videoLabel: String
  let participatedLabel: String
  let otherLabel: String

  func label(for noteType: NoteType) -> String {
    switch noteType {
    case .article: articleLabel
    case .talk: talkLabel
    case .video: videoLabel
    case .participated: participatedLabel
    case .other: otherLabel
    }
  }

  func label(for gameStatus: GameStatus) -> String {
    switch gameStatus {
    case .playing: gameStatusPlaying
    case .completed: gameStatusCompleted
    case .backlog: gameStatusBacklog
    case .wishlist: gameStatusWishlist
    }
  }

  func label(for gameCollection: GameCollection) -> String {
    switch gameCollection {
    case .owned: gameCollectionOwned
    case .psnPlus: gameCollectionPsnPlus
    case .steam: gameCollectionSteam
    case .wishlist: gameCollectionWishlist
    }
  }

  func label(for gameFormat: GameFormat) -> String {
    switch gameFormat {
    case .digital: gameFormatDigital
    case .physical: gameFormatPhysical
    case .unknown: gameFormatUnknown
    }
  }
}

extension SiteCopy {
  static let english = SiteCopy(
    homeNav: "home",
    notesNav: "notes",
    aboutNav: "about",
    introTitle: "Hey, I'm Rychillie",
    introWaveAlt: "Waving hand",
    intro: "A Brazilian Software Engineer creating content and sharing knowledge over the internet. My experience involves pushing the limits of what we can build with code. Design and technology lover, collaborating with Open Source projects.",
    homePrimaryText: "I like turning what I learn while building products into useful content: videos, essays, talks, and experiments. On my channel and in the Build in Public community, formerly Indie Hacking, I share behind-the-scenes notes, technical decisions, and ideas for people creating on the internet.",
    homeSocialText: "Not everything becomes a video. Some ideas need more context, so I use notes to publish articles, event analysis, engineering lessons, and reflections on technology, product, and community.",
    homeLatestNotesText: "Here are the latest notes I have published or am preparing.",
    homeBrandText: "Day to day, my work sits across engineering, product, design, and AI tools. I like using technology as leverage to build better things, learn faster, and share the process.",
    youtubeSubscribers: "1,550 subscribers",
    communityMembers: "12,100 members",
    followLink: "follow me",
    emailUpdatesLink: "get email updates",
    languageSwitchLink: "Change to Portuguese",
    notesTitle: "Notes",
    notesDescription: "Writing, talks, experiments, and technical notes.",
    noNotes: "No notes published yet.",
    aboutTitle: "About",
    aboutLead: "I am a Brazilian developer passionate about solving problems through technology, games, and design, focused on building products and digital experiences that make a difference in people's lives.",
    aboutParagraphs: [
      "My journey started by building products with TypeScript, PHP, C#, and React Native, but today my work " +
        "is much more connected to the Apple ecosystem. I have a strong specialty in Swift, Vapor, and the " +
        "technologies, products, and services that shape that ecosystem, always guided by the same idea: " +
        "good software is not only software that works. It respects people's time, reduces friction, and " +
        "makes a task simpler, clearer, or more enjoyable.",
      "Over the past few years, I have also dedicated part of my time to strengthening the developer " +
        "community in Brazil. I share what I learn about interface development with a focus on user " +
        "experience (UX), product, artificial intelligence, Swift, and Vapor through videos, articles, talks, " +
        "events, and conversations with other people building on the internet.",
      "Technology, design, and games are, to me, tools for impact and creativity. Games were one of the reasons I wanted to learn programming, and the way they combine systems, narrative, interaction, and emotion still influences how I think about products and digital experiences.",
    ],
    aboutGamesTitle: "Games",
    aboutGamesDescription: "A small shelf of what I am playing, what I have finished, and what is still waiting for the right moment.",
    gamesPageTitle: "Games",
    gamesPageDescription: "A full shelf of what I am playing, what I have finished, and what is still waiting for the right moment.",
    gamesViewAllAction: "View all",
    gamesFilterAllAction: "All",
    aboutCareerTitle: "Career",
    aboutCareerItems: [
      "10+ years of professional software development experience.",
      "Specialized in Swift, Vapor, and the Apple ecosystem.",
      "Experience with Apple products, services, and technologies.",
      "Previous product experience with TypeScript, PHP, C#, and React Native.",
      "Active in the Brazilian technology community through videos, articles, talks, and events.",
    ],
    gameOpenDetailsAction: "Open game details",
    gameCloseAction: "Close",
    gameReviewAction: "Read analysis",
    gameGalleryTitle: "Gallery",
    gameGalleryPreviousAction: "Previous image",
    gameGalleryNextAction: "Next image",
    gameGallerySelectAction: "Show image",
    gameSystemLabel: "System",
    gamePlayableOnLabel: "Playable on",
    gameLibraryLabel: "Library",
    gameFormatLabel: "Format",
    gameEditionLabel: "Edition",
    gameStartedLabel: "Started",
    gameFinishedLabel: "Finished",
    gamePlaytimeLabel: "Playtime",
    gameStatusPlaying: "Playing",
    gameStatusCompleted: "Completed",
    gameStatusBacklog: "Backlog",
    gameStatusWishlist: "Wishlist",
    gameCollectionOwned: "Owned",
    gameCollectionPsnPlus: "PSN Plus",
    gameCollectionSteam: "Steam",
    gameCollectionWishlist: "Wishlist",
    gameFormatDigital: "Digital",
    gameFormatPhysical: "Physical",
    gameFormatUnknown: "Unknown",
    copyLinkAction: "Copy Link",
    copyMarkdownAction: "Markdown",
    copiedAction: "Copied",
    articleLabel: "Article",
    talkLabel: "Talk",
    videoLabel: "Video",
    participatedLabel: "Participated",
    otherLabel: "Other"
  )

  static let portuguese = SiteCopy(
    homeNav: "início",
    notesNav: "notas",
    aboutNav: "sobre",
    introTitle: "Oi, eu sou Rychillie",
    introWaveAlt: "Mão acenando",
    intro: "Um Engenheiro de Software brasileiro criando conteúdo e compartilhando conhecimento pela internet. Minha experiência envolve explorar os limites do que conseguimos construir com código. Amo design e tecnologia, e colaboro com projetos Open Source.",
    homePrimaryText: "Eu gosto de transformar o que aprendo construindo produtos em conteúdo útil: vídeos, textos, talks e experimentos. No meu canal e na comunidade Build in Public, antiga Indie Hacking, compartilho bastidores, decisões técnicas e ideias para quem também está criando na internet.",
    homeSocialText: "Nem tudo vira vídeo. Algumas ideias pedem mais contexto, então uso as notes para registrar artigos, análises de eventos, aprendizados de engenharia e reflexões sobre tecnologia, produto e comunidade.",
    homeLatestNotesText: "Aqui estão os textos mais recentes que publiquei ou estou preparando.",
    homeBrandText: "No dia a dia, meu trabalho cruza engenharia, produto, design e ferramentas de IA. Gosto de usar tecnologia como alavanca para criar coisas melhores, aprender mais rápido e compartilhar o caminho.",
    youtubeSubscribers: "1.550 inscritos",
    communityMembers: "12.100 membros",
    followLink: "me acompanhe",
    emailUpdatesLink: "receber atualizações por email",
    languageSwitchLink: "Trocar para Inglês",
    notesTitle: "Notas",
    notesDescription: "Textos, talks, experimentos e notas técnicas.",
    noNotes: "Nenhuma nota publicada ainda.",
    aboutTitle: "Sobre",
    aboutLead: "Sou um desenvolvedor brasileiro apaixonado por resolver problemas com tecnologia, games e design, com foco em criar produtos e experiências digitais que façam diferença na vida das pessoas.",
    aboutParagraphs: [
      "Minha trajetória começou criando produtos com TypeScript, PHP, C# e React Native, mas hoje meu " +
        "trabalho está muito mais conectado ao ecossistema Apple. Tenho uma especialidade forte em Swift, " +
        "Vapor e nas tecnologias, produtos e serviços que formam esse ecossistema, sempre com a mesma ideia: " +
        "software bom não é só o que funciona. É o que respeita o tempo das pessoas, reduz atrito e torna " +
        "uma tarefa mais simples, clara ou prazerosa.",
      "Nos últimos anos, também tenho dedicado parte do meu tempo a fortalecer a comunidade de desenvolvimento " +
        "no Brasil. Compartilho o que aprendo sobre desenvolvimento de interfaces com foco em experiência " +
        "do usuário (UX), produto, inteligência artificial, Swift e Vapor por meio de vídeos, artigos, talks, " +
        "eventos e conversas com outras pessoas que também estão construindo na internet.",
      "Tecnologia, design e games são, para mim, ferramentas de impacto e criatividade. Jogos foram uma das razões que me fizeram querer aprender programação, e ainda hoje a forma como eles combinam sistemas, narrativa, interação e emoção influencia a maneira como penso produtos e experiências digitais.",
    ],
    aboutGamesTitle: "Games",
    aboutGamesDescription: "Uma pequena estante com o que estou jogando, o que já zerei e o que ainda está esperando o momento certo.",
    gamesPageTitle: "Games",
    gamesPageDescription: "Uma estante completa com o que estou jogando, o que já zerei e o que ainda está esperando o momento certo.",
    gamesViewAllAction: "Ver tudo",
    gamesFilterAllAction: "Todos",
    aboutCareerTitle: "Carreira",
    aboutCareerItems: [
      "10+ anos de experiência profissional em desenvolvimento de software.",
      "Especialidade em Swift, Vapor e ecossistema Apple.",
      "Experiência com produtos, serviços e tecnologias Apple.",
      "Repertório anterior construindo produtos com TypeScript, PHP, C# e React Native.",
      "Atuação na comunidade brasileira de tecnologia por meio de vídeos, artigos, talks e eventos.",
    ],
    gameOpenDetailsAction: "Abrir detalhes do jogo",
    gameCloseAction: "Fechar",
    gameReviewAction: "Ler análise",
    gameGalleryTitle: "Galeria",
    gameGalleryPreviousAction: "Imagem anterior",
    gameGalleryNextAction: "Próxima imagem",
    gameGallerySelectAction: "Mostrar imagem",
    gameSystemLabel: "Plataforma",
    gamePlayableOnLabel: "Jogável em",
    gameLibraryLabel: "Biblioteca",
    gameFormatLabel: "Formato",
    gameEditionLabel: "Edição",
    gameStartedLabel: "Iniciado",
    gameFinishedLabel: "Finalizado",
    gamePlaytimeLabel: "Tempo jogado",
    gameStatusPlaying: "Jogando",
    gameStatusCompleted: "Zerado",
    gameStatusBacklog: "Backlog",
    gameStatusWishlist: "Wishlist",
    gameCollectionOwned: "Comprado",
    gameCollectionPsnPlus: "PSN Plus",
    gameCollectionSteam: "Steam",
    gameCollectionWishlist: "Wishlist",
    gameFormatDigital: "Digital",
    gameFormatPhysical: "Físico",
    gameFormatUnknown: "Desconhecido",
    copyLinkAction: "Copiar link",
    copyMarkdownAction: "Markdown",
    copiedAction: "Copiado",
    articleLabel: "Artigo",
    talkLabel: "Talk",
    videoLabel: "Vídeo",
    participatedLabel: "Participei",
    otherLabel: "Outro"
  )
}

enum SiteSection {
  case home
  case notes
  case about
}
