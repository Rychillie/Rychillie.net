import Foundation
import Saga
import SagaParsleyMarkdownReader
import SagaSwimRenderer
import SwiftTailwind

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
    folder: "notes",
    metadata: NoteMetadata.self,
    readers: [.parsleyMarkdownReader],
    itemProcessor: syntaxHighlight,
    writers: [
      .itemWriter(swim(renderNote)),
    ]
  )
  .createPage("index.html", using: swim(renderHome))
  .createPage("notes/index.html", using: swim(renderNotes))
  .createPage("about/index.html", using: swim(renderAbout))
  .createPage("articles/index.html", using: Saga.redirectHTML(to: Site.notesPath))
  .createPage("articles/hello-world/index.html", using: Saga.redirectHTML(to: "\(Site.notesPath)hello-world/"))
  .run()
