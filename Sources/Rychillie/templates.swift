import Foundation
import HTML
import Moon
import Saga
import SagaSwimRenderer

func baseHtml(title pageTitle: String, @NodeBuilder children: () -> NodeConvertible) -> Node {
  html(lang: "en-US") {
    head {
      meta(charset: "utf-8")
      meta(content: "width=device-width, initial-scale=1", name: "viewport")
      title { pageTitle }
      link(href: Saga.hashed("/static/styles.css"), rel: "stylesheet")
    }
    body(class: Theme.body) {
      header {
        nav(class: Theme.nav) {
          a(class: Theme.siteTitle, href: "/") { "My Site" }
          div {
            a(class: Theme.navLink, href: "/articles/") { "Articles" }
          }
        }
      }
      main(class: Theme.main) {
        children()
      }
      footer(class: Theme.footer) {
        p(class: Theme.footerText) {
          "Built with "
          a(class: Theme.link, href: "https://github.com/loopwerk/Saga") { "Saga" }
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

func renderPage(context: ItemRenderingContext<EmptyMetadata>) -> Node {
  baseHtml(title: context.item.title) {
    div {
      h1(class: Theme.pageTitle) { context.item.title }
      div(class: Theme.markdown) {
        Node.raw(Moon.shared.highlightCodeBlocks(in: context.item.body))
      }
    }
  }
}
