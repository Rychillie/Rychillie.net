import Foundation
import Saga
import SagaParsleyMarkdownReader
import SagaSwimRenderer
import SwiftTailwind

struct ArticleMetadata: Metadata {
  let tags: [String]
  var summary: String?
}

let tailwind = SwiftTailwind(version: "4.3.0")

func compileTailwind() async throws {
  try await tailwind.run(
    input: "content/static/input.css",
    output: "content/static/output.css",
    options: .minify
  )
}

try await compileTailwind()

try await Saga(input: "content", output: "deploy")
  .beforeRead { saga in
    guard saga.buildReason.changedFile()?.extension == "css" else { return }
    try await compileTailwind()
  }
  .ignoreChanges("output.css")
  .register(
    folder: "articles",
    metadata: ArticleMetadata.self,
    readers: [.parsleyMarkdownReader],
    writers: [
      .itemWriter(swim(renderArticle)),
      .listWriter(swim(renderArticles)),
      .tagWriter(swim(renderTag), tags: \.metadata.tags),
    ]
  )
  .register(
    metadata: EmptyMetadata.self,
    readers: [.parsleyMarkdownReader],
    writers: [.itemWriter(swim(renderPage))]
  )
  .run()
