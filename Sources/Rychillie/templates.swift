import Foundation
import HTML
import Moon
import Saga
import SagaSwimRenderer

func baseHtml(
  title pageTitle: String,
  bodyClass: String = Theme.body,
  mainClass: String = Theme.main,
  showChrome: Bool = true,
  @NodeBuilder children: () -> NodeConvertible
) -> Node {
  html(lang: "en-US") {
    head {
      meta(charset: "utf-8")
      meta(content: "width=device-width, initial-scale=1", name: "viewport")
      title { pageTitle }
      link(
        href: "https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;600;700&family=Lora:wght@700&display=swap",
        rel: "stylesheet"
      )
      link(href: Saga.hashed("/static/styles.css"), rel: "stylesheet")
    }
    body(class: bodyClass) {
      if showChrome {
        header {
          nav(class: Theme.nav) {
            a(class: Theme.siteTitle, href: "/") { "My Site" }
            div {
              a(class: Theme.navLink, href: "/articles/") { "Articles" }
            }
          }
        }
      }
      main(class: mainClass) {
        children()
      }
      if showChrome {
        footer(class: Theme.footer) {
          p(class: Theme.footerText) {
            "Built with "
            a(class: Theme.link, href: "https://github.com/loopwerk/Saga") { "Saga" }
          }
        }
      }
    }
  }
}

func renderArticle(context: ItemRenderingContext<ArticleMetadata>) -> Node {
  baseHtml(title: context.item.title) {
    article(class: Theme.article) {
      h1(class: Theme.pageTitle) { context.item.title }
      ul(class: Theme.tags) {
        context.item.metadata.tags.map { tag in
          li {
            a(class: Theme.tagLink, href: "/articles/tag/\(tag.slugified)/") { tag }
          }
        }
      }
      div(class: Theme.markdown) {
        Node.raw(Moon.shared.highlightCodeBlocks(in: context.item.body))
      }
    }
  }
}

func renderArticles(context: ItemsRenderingContext<ArticleMetadata>) -> Node {
  baseHtml(title: "Articles") {
    h1(class: Theme.pageTitle) { "Articles" }
    context.items.map { article in
      div(class: Theme.articleCard) {
        h2(class: Theme.articleCardTitle) {
          a(class: Theme.link, href: article.url) { article.title }
        }
        if let summary = article.metadata.summary {
          p(class: Theme.articleCardSummary) { summary }
        }
      }
    }
  }
}

func renderTag<T>(context: PartitionedRenderingContext<T, ArticleMetadata>) -> Node {
  baseHtml(title: "Articles tagged \(context.key)") {
    h1(class: Theme.pageTitle) { "Articles tagged \(context.key)" }
    context.items.map { article in
      div(class: Theme.articleCard) {
        h2(class: Theme.articleCardTitle) {
          a(class: Theme.link, href: article.url) { article.title }
        }
      }
    }
  }
}

func renderHome(context: ItemRenderingContext<PageMetadata>) -> Node {
  baseHtml(
    title: context.item.title,
    bodyClass: Theme.homeBody,
    mainClass: Theme.homeMain,
    showChrome: false
  ) {
    div(class: Theme.homeStage) {
      homeNav()
      div(class: Theme.homeContainer) {
        section(class: Theme.homeIntro, id: "about") {
          h1(class: Theme.homeIntroTitle) { "Hey, I'm Rychillie 👋" }
          homeText("A Brazilian Software Engineer creating content and sharing knowledge over the internet. My experience involves pushing the limits of what we can build with code. Design and technology lover, collaborating with Open Source projects.")
        }

        div(class: Theme.homeBento) {
          div(class: Theme.homeBentoColumn) {
            assetImage("bento-portrait-1.png", alt: "Rychillie portrait", class: Theme.homeImageTall)
            assetImage("bento-wide-1.png", alt: "BrazilJS event", class: Theme.homeImageShort)
          }
          div(class: Theme.homeBentoColumn) {
            assetImage("bento-wide-2.png", alt: "Rychillie speaking", class: Theme.homeImageShort)
            assetImage("bento-portrait-2.png", alt: "Rychillie on stage", class: Theme.homeImageTall)
          }
        }

        homeText("Pariatur dolore excepteur officia exercitation minim laborum est fugiat. Anim fugiat eiusmod mollit magna eu ipsum fugiat pariatur dolor deserunt magna. Nostrud non eiusmod veniam enim elit minim sint consequat mollit Lorem minim. Consectetur dolore nisi ex ex velit aute cillum eiusmod commodo eiusmod.")

        div(class: Theme.homeSocialCards) {
          homeCard(
            title: "@rychillie",
            subtitle: "1,550 subscribers",
            avatar: "youtube-avatar.png",
            badgeLight: "youtube-light.svg",
            badgeDark: "youtube-dark.svg",
            badgeClass: "h-[8.438px] w-3",
            href: "https://www.youtube.com/@rychillie"
          )
          homeCard(
            title: "@rychillie",
            subtitle: "12,100 members",
            avatar: "discord-avatar.png",
            badgeLight: "discord.svg",
            badgeClass: "h-[9.328px] w-3"
          )
        }

        homeText("Pariatur dolore excepteur officia exercitation minim laborum est fugiat. Anim fugiat eiusmod mollit magna eu ipsum fugiat pariatur dolor deserunt magna. Nostrud non eiusmod veniam enim elit minim sint consequat mollit Lorem minim.")

        div(class: Theme.homeList) {
          homeContentItem(title: "OpenClaw My Personal Secretary", kind: "Talk", date: "April 29, 2026")
          homeContentItem(title: "Getting Started on Swift by creating a CRUD with Vapor", kind: "Article", date: "October 18, 2024")
          homeContentItem(title: "useFetch a custom React Hook", kind: "Article", date: "March 21, 2024")
        }

        homeText("Pariatur dolore excepteur officia exercitation minim laborum est fugiat.")

        div(class: Theme.homeBrandGrid) {
          brandChip(name: "Apple", lightIcon: "apple-light.svg", darkIcon: "apple-dark.svg", iconClass: Theme.homeBrandAppleIcon)
          brandChip(name: "Chargeblast", image: "chargeblast.png")
          brandChip(name: "Anthropic", lightIcon: "anthropic-light.svg", darkIcon: "anthropic-dark.svg")
          brandChip(name: "OpenAI", lightIcon: "openai-light.svg", darkIcon: "openai-dark.svg", iconClass: Theme.homeBrandOpenAIIcon)
        }

        homeText("Pariatur dolore excepteur officia exercitation minim laborum est fugiat. Anim fugiat eiusmod mollit magna eu ipsum fugiat pariatur dolor deserunt magna.")

        div(class: Theme.homeSocialLinks) {
          homeSocialAction("fallow me")
          homeSocialAction("get email updates")
        }
      }
      div(class: Theme.homeBottomFade) {}
    }
  }
}

func renderPage(context: ItemRenderingContext<PageMetadata>) -> Node {
  if context.item.metadata.template?.lowercased() == "home" {
    return renderHome(context: context)
  }

  return baseHtml(title: context.item.title) {
    div {
      h1(class: Theme.pageTitle) { context.item.title }
      div(class: Theme.markdown) {
        Node.raw(Moon.shared.highlightCodeBlocks(in: context.item.body))
      }
    }
  }
}

private func homeNav() -> Node {
  nav(class: Theme.homeTopNav) {
    a(class: Theme.homeNavActive, href: "/") { "home" }
    a(class: Theme.homeNavLink, href: "/articles/") { "notes" }
    a(class: Theme.homeNavLink, href: "/#about") { "about" }
  }
}

private func homeAsset(_ name: String) -> String {
  "/static/home/\(name)"
}

private func assetImage(_ name: String, alt: String, class className: String) -> Node {
  img(alt: alt, class: className, src: homeAsset(name))
}

private func themedIcon(
  light: String,
  dark: String,
  alt: String = "",
  class className: String
) -> Node {
  span(class: className) {
    img(alt: alt, class: "size-full \(Theme.hiddenDark)", src: homeAsset(light))
    img(alt: alt, class: "size-full \(Theme.visibleDark)", src: homeAsset(dark))
  }
}

private func homeCard(
  title: String,
  subtitle: String,
  avatar: String,
  badgeLight: String,
  badgeDark: String? = nil,
  badgeClass: String,
  href: String? = nil
) -> Node {
  if let href {
    return a(class: Theme.homeCard, href: href) {
      homeCardContents(
        title: title,
        subtitle: subtitle,
        avatar: avatar,
        badgeLight: badgeLight,
        badgeDark: badgeDark,
        badgeClass: badgeClass
      )
    }
  }

  return div(class: Theme.homeCardStatic) {
    homeCardContents(
      title: title,
      subtitle: subtitle,
      avatar: avatar,
      badgeLight: badgeLight,
      badgeDark: badgeDark,
      badgeClass: badgeClass
    )
  }
}

@NodeBuilder
private func homeCardContents(
  title: String,
  subtitle: String,
  avatar: String,
  badgeLight: String,
  badgeDark: String?,
  badgeClass: String
) -> NodeConvertible {
  div(class: Theme.homeProfileGroup) {
    div(class: Theme.homeProfile) {
      assetImage(avatar, alt: "\(title) profile photo", class: Theme.homeProfileImage)
      span(class: Theme.homeProfileBadge) {
        if let badgeDark {
          themedIcon(light: badgeLight, dark: badgeDark, class: badgeClass)
        } else {
          assetImage(badgeLight, alt: "", class: badgeClass)
        }
      }
    }
    div(class: Theme.homeCardDetails) {
      p(class: Theme.homeCardTitle) { title }
      p(class: Theme.homeCardMeta) { subtitle }
    }
  }
  themedIcon(light: "arrow-card-light.svg", dark: "arrow-card-dark.svg", class: Theme.homeArrow)
}

private func homeText(_ text: String) -> Node {
  p(class: Theme.homeText) { text }
}

private func homeContentItem(title: String, kind: String, date: String) -> Node {
  div(class: Theme.homeListCard) {
    div(class: Theme.homeListDetails) {
      p(class: Theme.homeCardTitle) { title }
      div(class: Theme.homeMetaRow) {
        p(class: Theme.homeCardMeta) { kind }
        span(class: Theme.homeMetaDot) {}
        p(class: Theme.homeCardMeta) { date }
      }
    }
    themedIcon(light: "arrow-card-light.svg", dark: "arrow-card-dark.svg", class: Theme.homeArrow)
  }
}

private func brandChip(
  name: String,
  lightIcon: String? = nil,
  darkIcon: String? = nil,
  image: String? = nil,
  iconClass: String = Theme.homeBrandIcon
) -> Node {
  div(class: Theme.homeBrandChip) {
    if let image {
      assetImage(image, alt: "", class: Theme.homeBrandLogo)
    } else if let lightIcon, let darkIcon {
      themedIcon(light: lightIcon, dark: darkIcon, class: iconClass)
    }
    p(class: Theme.homeCardTitle) { name }
  }
}

private func homeSocialAction(_ text: String) -> Node {
  span(class: Theme.homeSocialAction) {
    themedIcon(light: "arrow-inline-light.svg", dark: "arrow-inline-dark.svg", class: Theme.homeInlineArrow)
    span { text }
  }
}
