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
  let aboutCareerTitle: String
  let aboutCareerItems: [String]
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
    aboutLead: "I am a Brazilian developer passionate about creating interfaces, products, and digital experiences that are useful, well-designed, and enjoyable to use.",
    aboutParagraphs: [
      "My journey across Web, Mobile, and iOS development has always been guided by the same idea: good software is not only software that works. It respects people's time, reduces friction, and makes a task simpler, clearer, or more enjoyable.",
      "Over the past few years, I have also dedicated part of my time to strengthening the developer community in Brazil. I share what I learn about UI, Frontend, Mobile/iOS, product, and artificial intelligence through videos, essays, talks, events, and conversations with other people building on the internet.",
      "Technology and design are, to me, tools for impact. I want to create better applications over time and, more than being remembered for the work itself, I want to be remembered for how what I built helped people learn, create, or live better.",
    ],
    aboutCareerTitle: "Career",
    aboutCareerItems: [
      "10+ years of professional software development experience.",
      "Specialized in Frontend, interfaces, user experience, and mobile/iOS development.",
      "Experience building and leading projects across startups, communities, and product environments.",
      "Active in the Brazilian technology community, sharing knowledge and practical experience.",
    ],
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
    aboutLead: "Sou um desenvolvedor brasileiro apaixonado por criar interfaces, produtos e experiências digitais que sejam úteis, bem desenhadas e agradáveis de usar.",
    aboutParagraphs: [
      "Minha trajetória em Web, Mobile e iOS sempre foi guiada pela mesma ideia: software bom não é só o que funciona. É o que respeita o tempo das pessoas, reduz atrito e torna uma tarefa mais simples, clara ou prazerosa.",
      "Nos últimos anos, também tenho dedicado parte do meu tempo a fortalecer a comunidade de desenvolvimento no Brasil. Compartilho o que aprendo sobre UI, Frontend, Mobile/iOS, produto e inteligência artificial por meio de vídeos, textos, talks, eventos e conversas com outras pessoas que também estão construindo na internet.",
      "Tecnologia e design são, para mim, ferramentas de impacto. Quero criar aplicações cada vez melhores e, mais do que ser lembrado pelo trabalho em si, ser lembrado pela forma como aquilo que construí ajudou pessoas a aprender, criar ou viver melhor.",
    ],
    aboutCareerTitle: "Carreira",
    aboutCareerItems: [
      "10+ anos de experiência profissional em desenvolvimento de software.",
      "Especialidade em Frontend, interfaces, experiência do usuário e desenvolvimento mobile/iOS.",
      "Experiência construindo e liderando projetos em startups, comunidades e ambientes de produto.",
      "Atuação constante na comunidade brasileira de tecnologia, compartilhando conhecimento e experiências.",
    ],
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
