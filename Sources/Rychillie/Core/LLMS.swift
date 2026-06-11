import Foundation
import Saga

enum LLMS {
  static func renderIndex(context: PageRenderingContext) throws -> String {
    let notes = sortedNotes(from: context.allItems)
    let englishNotes = notes.filter { Site.currentLocale($0.locale) == Site.defaultLocale }
    let portugueseNotes = notes.filter { Site.currentLocale($0.locale) == Site.portugueseLocale }

    return [
      "# \(Site.name)",
      "",
      "> \(Site.copy(for: Site.defaultLocale).intro)",
      "",
      "This file points AI agents to canonical profile context and clean Markdown versions of the public notes on this website.",
      "",
      "## Profile",
      "",
      "- [Home](\(Site.absoluteURL(for: Site.homePath))): English homepage and profile summary.",
      "- [About](\(Site.absoluteURL(for: Site.aboutPath))): English about page.",
      "- [Portuguese home](\(Site.absoluteURL(for: Site.localizedHomePath(for: Site.portugueseLocale)))): Portuguese homepage and profile summary.",
      "- [All notes](\(Site.absoluteURL(for: Site.notesPath))): Human-readable note index.",
      "- [Full AI context](\(Site.absoluteURL(for: "/llms-full.txt"))): Aggregated Markdown context for this site.",
      "",
      renderNoteList(title: "Notes in English", notes: englishNotes),
      "",
      renderNoteList(title: "Notas em Português", notes: portugueseNotes),
    ].joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) + "\n"
  }

  static func renderFull(context: PageRenderingContext) throws -> String {
    let notes = sortedNotes(from: context.allItems)
    let englishNotes = notes.filter { Site.currentLocale($0.locale) == Site.defaultLocale }
    let portugueseNotes = notes.filter { Site.currentLocale($0.locale) == Site.portugueseLocale }

    return [
      "# \(Site.name)",
      "",
      "> \(Site.copy(for: Site.defaultLocale).intro)",
      "",
      "## Profile",
      "",
      "### English",
      "",
      Site.copy(for: Site.defaultLocale).intro,
      "",
      "- Home: \(Site.absoluteURL(for: Site.homePath))",
      "- Notes: \(Site.absoluteURL(for: Site.notesPath))",
      "- About: \(Site.absoluteURL(for: Site.aboutPath))",
      "",
      "### Portuguese",
      "",
      Site.copy(for: Site.portugueseLocale).intro,
      "",
      "- Home: \(Site.absoluteURL(for: Site.localizedHomePath(for: Site.portugueseLocale)))",
      "- Notes: \(Site.absoluteURL(for: Site.localizedNotesPath(for: Site.portugueseLocale)))",
      "- About: \(Site.absoluteURL(for: Site.localizedAboutPath(for: Site.portugueseLocale)))",
      "",
      try renderFullNotes(title: "Notes in English", notes: englishNotes),
      "",
      try renderFullNotes(title: "Notas em Português", notes: portugueseNotes),
    ].joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) + "\n"
  }

  static func writeMarkdownNotes(_ saga: Saga) throws {
    for note in sortedNotes(from: saga.allItems) {
      let outputURL = URL(fileURLWithPath: saga.outputPath.string)
        .appendingPathComponent(outputRelativePath(for: markdownPath(for: note)))
      try FileManager.default.createDirectory(
        at: outputURL.deletingLastPathComponent(),
        withIntermediateDirectories: true
      )
      try cleanMarkdown(for: note).write(to: outputURL, atomically: true, encoding: .utf8)
    }
  }

  static func markdownPath(for note: Item<NoteMetadata>) -> String {
    let canonicalPath = canonicalPath(for: note)
    let trimmedPath = canonicalPath.hasSuffix("/") ? String(canonicalPath.dropLast()) : canonicalPath
    return "\(trimmedPath).md"
  }

  static func cleanMarkdown(for note: Item<NoteMetadata>) throws -> String {
    let locale = Site.currentLocale(note.locale)
    let canonicalPath = canonicalPath(for: note)
    let noteMarkdownPath = markdownPath(for: note)
    let body = try sourceBodyWithoutFrontMatterOrTitle(for: note)
    let summary = note.metadata.summary ?? note.title
    let tags = note.metadata.tags.isEmpty ? "none" : note.metadata.tags.joined(separator: ", ")

    return [
      "# \(note.title)",
      "",
      "> \(summary)",
      "",
      "- Language: \(locale)",
      "- Canonical URL: \(Site.absoluteURL(for: canonicalPath))",
      "- Markdown URL: \(Site.absoluteURL(for: noteMarkdownPath))",
      "- Published: \(isoDate(note.date))",
      "- Type: \(note.metadata.displayType.label(locale: locale))",
      "- Tags: \(tags)",
      "",
      "---",
      "",
      body,
    ].joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) + "\n"
  }

  private static func sortedNotes(from items: [AnyItem]) -> [Item<NoteMetadata>] {
    items
      .compactMap { $0 as? Item<NoteMetadata> }
      .sorted { lhs, rhs in
        if lhs.date != rhs.date {
          return lhs.date > rhs.date
        }

        let lhsLocale = Site.currentLocale(lhs.locale)
        let rhsLocale = Site.currentLocale(rhs.locale)
        if lhsLocale != rhsLocale {
          return lhsLocale < rhsLocale
        }

        return lhs.title < rhs.title
      }
  }

  private static func renderNoteList(title: String, notes: [Item<NoteMetadata>]) -> String {
    let lines = notes.map { note in
      let summary = note.metadata.summary ?? note.title
      return "- [\(note.title)](\(Site.absoluteURL(for: markdownPath(for: note)))): \(summary)"
    }

    return (["## \(title)", ""] + lines).joined(separator: "\n")
  }

  private static func renderFullNotes(title: String, notes: [Item<NoteMetadata>]) throws -> String {
    let sections = try notes.map { try cleanMarkdown(for: $0) }
    return (["## \(title)", ""] + sections).joined(separator: "\n")
  }

  private static func canonicalPath(for note: Item<NoteMetadata>) -> String {
    note.url
  }

  private static func sourceBodyWithoutFrontMatterOrTitle(for note: Item<NoteMetadata>) throws -> String {
    let source = try note.absoluteSource.read(.utf8)
    let withoutFrontMatter = stripFrontMatter(from: source)
    return stripLeadingTitle(from: withoutFrontMatter).trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private static func stripFrontMatter(from source: String) -> String {
    let normalized = source.replacingOccurrences(of: "\r\n", with: "\n")
    let lines = normalized.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)

    guard lines.first == "---" else {
      return normalized
    }

    guard let closingIndex = lines.dropFirst().firstIndex(of: "---") else {
      return normalized
    }

    return lines.dropFirst(closingIndex + 1).joined(separator: "\n")
  }

  private static func stripLeadingTitle(from source: String) -> String {
    var lines = source.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)

    while lines.first?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
      lines.removeFirst()
    }

    if lines.first?.hasPrefix("# ") == true {
      lines.removeFirst()
    }

    return lines.joined(separator: "\n")
  }

  private static func outputRelativePath(for path: String) -> String {
    path.hasPrefix("/") ? String(path.dropFirst()) : path
  }

  private static func isoDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
  }
}
