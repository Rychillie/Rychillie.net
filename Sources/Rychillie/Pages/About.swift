import HTML
import Saga

func renderAbout(context: PageRenderingContext) -> Node {
  baseHtml(title: "About") {
    pageFrame(activeSection: .about) {
      section(class: Theme.Notes.header) {
        h1(class: Theme.Notes.pageTitle) { "About" }
        p(class: Theme.Notes.pageText) { Site.intro }
      }
    }
  }
}
