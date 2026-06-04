import Foundation
import Saga
import SagaParsleyMarkdownReader
import SagaSwimRenderer
import SwiftTailwind

struct ArticleMetadata: Metadata {
  let tags: [String]
  var summary: String?
}

struct PageMetadata: Metadata {
  var template: String?
}

let tailwind = SwiftTailwind(version: "4.3.0")

func compileTailwind() async throws {
  try await tailwind.run(
    input: "content/static/tailwind.css",
    output: "content/static/styles.css",
    options: .minify
  )
}

func removeTailwindSourceFromDeploy(_ saga: Saga) throws {
  let tailwindPath = "\(saga.outputPath)/static/tailwind.css"
  if FileManager.default.fileExists(atPath: tailwindPath) {
    try FileManager.default.removeItem(atPath: tailwindPath)
  }
}

try await compileTailwind()

try await Saga(input: "content", output: "deploy")
  .beforeRead { saga in
    guard saga.buildReason.changedFile()?.extension == "css" else { return }
    try await compileTailwind()
  }
  .afterWrite { saga in
    try removeTailwindSourceFromDeploy(saga)
  }
  .ignoreChanges("styles.css")
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
    metadata: PageMetadata.self,
    readers: [.parsleyMarkdownReader],
    writers: [.itemWriter(swim(renderPage))]
  )
  .run()
