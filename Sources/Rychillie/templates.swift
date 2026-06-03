import Foundation
import HTML
import Moon
import Saga
import SagaSwimRenderer

private enum Styles {
  static let body = "mx-auto max-w-[800px] px-5 font-sans leading-[1.6] text-[#333]"
  static let nav = "mb-10 flex items-center justify-between border-b border-[#eee] py-5"
  static let siteTitle = "text-[1.2rem] font-bold text-[#333] no-underline hover:text-[#004499]"
  static let navLink = "ml-5 text-[#666] no-underline hover:text-[#333]"
  static let main = "min-h-[60vh]"
  static let article = "mb-10"
  static let tags = "mb-5 flex list-none gap-2 pl-6"
  static let tagLink = "rounded-xl bg-[#f0f0f0] px-2.5 py-0.5 text-[0.85rem] text-[#555] no-underline hover:bg-[#e0e0e0] hover:text-[#555]"
  static let articleCard = "border-b border-[#eee] py-5"
  static let articleCardTitle = "m-0 mb-2 text-[1.4rem] font-bold"
  static let articleCardSummary = "m-0 text-[#666]"
  static let footer = "mt-[60px] border-t border-[#eee] py-5 text-[0.85rem] text-[#999]"
}

func baseHtml(title pageTitle: String, @NodeBuilder children: () -> NodeConvertible) -> Node {
  html(lang: "en-US") {
    head {
      meta(charset: "utf-8")
      meta(content: "width=device-width, initial-scale=1", name: "viewport")
      title { pageTitle }
      link(href: Saga.hashed("/static/output.css"), rel: "stylesheet")
    }
    body(class: Styles.body) {
      header {
        nav(class: Styles.nav) {
          a(class: Styles.siteTitle, href: "/") { "My Site" }
          div {
            a(class: Styles.navLink, href: "/articles/") { "Articles" }
          }
        }
      }
      main(class: Styles.main) {
        children()
      }
      footer(class: Styles.footer) {
        p {
          "Built with "
          a(href: "https://github.com/loopwerk/Saga") { "Saga" }
        }
      }
    }
  }
}

func renderArticle(context: ItemRenderingContext<ArticleMetadata>) -> Node {
  baseHtml(title: context.item.title) {
    article(class: Styles.article) {
      h1 { context.item.title }
      ul(class: Styles.tags) {
        context.item.metadata.tags.map { tag in
          li {
            a(class: Styles.tagLink, href: "/articles/tag/\(tag.slugified)/") { tag }
          }
        }
      }
      Node.raw(Moon.shared.highlightCodeBlocks(in: context.item.body))
    }
  }
}

func renderArticles(context: ItemsRenderingContext<ArticleMetadata>) -> Node {
  baseHtml(title: "Articles") {
    h1 { "Articles" }
    context.items.map { article in
      div(class: Styles.articleCard) {
        h2(class: Styles.articleCardTitle) {
          a(href: article.url) { article.title }
        }
        if let summary = article.metadata.summary {
          p(class: Styles.articleCardSummary) { summary }
        }
      }
    }
  }
}

func renderTag<T>(context: PartitionedRenderingContext<T, ArticleMetadata>) -> Node {
  baseHtml(title: "Articles tagged \(context.key)") {
    h1 { "Articles tagged \(context.key)" }
    context.items.map { article in
      div(class: Styles.articleCard) {
        h2(class: Styles.articleCardTitle) {
          a(href: article.url) { article.title }
        }
      }
    }
  }
}

func renderPage(context: ItemRenderingContext<EmptyMetadata>) -> Node {
  baseHtml(title: context.item.title) {
    div {
      h1 { context.item.title }
      Node.raw(Moon.shared.highlightCodeBlocks(in: context.item.body))
    }
  }
}
