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

func removeStaticIconsFromDeploy(_ saga: Saga) throws {
  let iconsPath = [saga.outputPath.string, "static", "icons"].joined(separator: "/")
  if FileManager.default.fileExists(atPath: iconsPath) {
    try FileManager.default.removeItem(atPath: iconsPath)
  }
}

func generateImages(_ saga: Saga) throws {
  let process = Process()
  process.executableURL = URL(fileURLWithPath: "/bin/zsh")
  process.arguments = ["Sources/Scripts/generate-images.sh", saga.outputPath.string]

  try process.run()
  process.waitUntilExit()

  guard process.terminationStatus == 0 else {
    throw NSError(
      domain: "Rychillie.ImageGeneration",
      code: Int(process.terminationStatus),
      userInfo: [NSLocalizedDescriptionKey: "Image generation failed with status \(process.terminationStatus)"]
    )
  }
}

func unpublishedNotes(from items: [AnyItem]) -> [Item<NoteMetadata>] {
  items
    .compactMap { $0 as? Item<NoteMetadata> }
    .filter { !$0.metadata.isPublished }
}

func removeGeneratedUnpublishedNotes(_ saga: Saga) throws {
  for note in unpublishedNotes(from: saga.allItems) {
    let htmlPath = note.relativeDestination.string
    let markdownPath = LLMS.markdownPath(for: note)
    for relativePath in [htmlPath, markdownPath] {
      let outputPath = relativePath.hasPrefix("/") ? String(relativePath.dropFirst()) : relativePath
      let outputURL = URL(fileURLWithPath: saga.outputPath.string).appendingPathComponent(outputPath)
      if FileManager.default.fileExists(atPath: outputURL.path) {
        try FileManager.default.removeItem(at: outputURL)
      }
    }
  }
}

func renderSitemap(context: PageRenderingContext) -> String {
  let unpublishedPaths = Set(unpublishedNotes(from: context.allItems).map(\.relativeDestination.string))

  return Saga.sitemap(baseURL: Site.baseURL) { path in
    let outputPath = path.string
    return outputPath.hasSuffix(".html") &&
      !outputPath.hasPrefix("articles/") &&
      !unpublishedPaths.contains(outputPath)
  }(context)
}

try await compileTailwind()

try await Saga(input: "content", output: "deploy")
  .i18n(locales: Site.supportedLocales, defaultLocale: Site.defaultLocale)
  .beforeRead { saga in
    guard saga.buildReason.changedFile()?.extension == "css" else { return }
    try await compileTailwind()
  }
  .afterWrite { saga in
    try removeTailwindSourceFromDeploy(saga)
    try removeStaticIconsFromDeploy(saga)
    try LLMS.writeMarkdownNotes(saga)
    try removeGeneratedUnpublishedNotes(saga)
    try generateImages(saga)
  }
  .postProcess { content, relativePath in
    guard relativePath.extension == "html" else { return content }

    let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    guard !trimmed.hasPrefix("<!doctype") else { return content }

    return "<!doctype html>\n\(content)"
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
  .register(
    folder: "games",
    metadata: GameMetadata.self,
    readers: [.parsleyMarkdownReader],
    writers: []
  )
  .createPage("index.html", forEachLocale: swim(renderHome))
  .createPage("notes/index.html", forEachLocale: swim(renderNotes))
  .createPage("about/index.html", forEachLocale: swim(renderAbout))
  .createPage("about/games/index.html", forEachLocale: swim(renderGames))
  .createPage("articles/index.html", using: Saga.redirectHTML(to: Site.notesPath))
  .createPage("llms.txt", using: LLMS.renderIndex)
  .createPage("llms-full.txt", using: LLMS.renderFull)
  .createPage("sitemap.xml", using: renderSitemap)
  .run()
