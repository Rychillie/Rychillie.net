# Rychillie.net

Personal static website built with [Saga](https://getsaga.dev), a Swift static site generator.

The site is generated from localized Markdown content in `content/`, rendered by Swift templates, styled with Tailwind CSS utilities, optimized during the Saga build, and deployed to Cloudflare Pages.

Current build features include:

- English and Brazilian Portuguese content with Saga i18n.
- Tailwind CSS compiled through [`SwiftTailwind`](https://github.com/loopwerk/SwiftTailwind).
- Moon-powered syntax highlighting for Markdown code blocks.
- SEO metadata, canonical URLs, alternate locale links, `robots.txt`, and `sitemap.xml`.
- Cloudflare Pages cache and content-type headers from `content/_headers`.
- Responsive image variants generated with ImageMagick.
- AI-friendly `/llms.txt`, `/llms-full.txt`, and clean per-note Markdown output.

## Requirements

- Swift 6.0 or newer
- macOS 14 or newer
- Saga CLI
- ImageMagick
- SwiftLint

Install the build tools with Homebrew:

```sh
brew install loopwerk/tap/saga imagemagick swiftlint
```

## Development

Start the Saga development server:

```sh
saga dev --port 3000
```

Build the static site:

```sh
saga build
```

Run SwiftLint:

```sh
swiftlint lint --quiet
```

Saga reads localized content from `content/` and writes the generated site to `deploy/`.

The generated files in `deploy/` are ignored by git. Tailwind also writes `content/static/styles.css`, which is generated and ignored. Responsive image variants are generated into `deploy/static/images/` during the build and are not committed.

## Styling

Tailwind CSS is compiled during the Saga build through [`SwiftTailwind`](https://github.com/loopwerk/SwiftTailwind).

- `content/static/tailwind.css` is the Tailwind input file.
- `content/static/styles.css` is the generated minified CSS output.
- `Sources/Rychillie/Styles/Theme.swift` centralizes the Tailwind utility strings used by the Swift templates.
- `Sources/Rychillie/Layout/Layout.swift` links the generated CSS with `Saga.hashed("/static/styles.css")`, so deployed pages reference a cache-friendly hashed stylesheet.
- `Sources/Rychillie/main.swift` removes `static/tailwind.css` from the generated `deploy/` output after Saga writes the site.

When changing visual styling, prefer updating `Theme` or `content/static/tailwind.css`. Do not edit `content/static/styles.css` directly.

## Content

Content is localized by folder:

- `content/en/notes/`: English notes. These build at `/notes/...`.
- `content/pt-BR/notes/`: Brazilian Portuguese notes. These build at `/pt-BR/notes/...`.

Note front matter uses:

- `tags`: required note tags.
- `summary`: optional short summary used by note cards, SEO metadata, and generated Markdown.
- `type`: optional note type. Supported values are `article`, `talk`, `video`, `participated`, and `other`; missing values default to `article`.

The current home page uses localized bento image links that point to event notes, including the `participated` notes for BrazilJS Conf 2024, Build in Public Meetup 2026, and ClawCon Belo Horizonte 2026.

## Site Generation

The main Saga pipeline lives in `Sources/Rychillie/main.swift`.

- It compiles Tailwind before Saga runs.
- It uses `content/` as input and `deploy/` as output.
- It configures Saga i18n with `en` as the default locale and `pt-BR` under `/pt-BR/`.
- It recompiles Tailwind when CSS changes during development.
- It ignores generated `styles.css` changes in the Saga file watcher.
- It registers note Markdown files from `content/en/notes/` and `content/pt-BR/notes/` with `NoteMetadata`.
- It renders template-driven home, notes, and about pages once per locale.
- It redirects legacy `/articles/` to `/notes/`.
- It writes `/llms.txt`, `/llms-full.txt`, and per-note `.md` files for agent-readable Markdown access.
- It writes `sitemap.xml`.
- It injects a missing HTML doctype during post-processing.
- It removes `static/tailwind.css` and static icon files from generated output.
- It generates responsive PNG/WebP image variants and the optimized wave animation into `deploy/static/images/`.

Templates are built with Saga Swim renderer helpers and use [Moon](https://github.com/loopwerk/Moon) for code highlighting.

## Assets

- `content/static/images/`: Source images committed to the repository.
- `Sources/Scripts/generate-images.sh`: ImageMagick script used by the Saga build to create responsive output variants in `deploy/static/images/`.
- `Sources/Rychillie/Layout/Icons.swift`: Inline Swift-rendered SVG icons used by the templates.
- `content/favicon.ico`: Site favicon.
- `content/_headers`: Cloudflare Pages headers for cache behavior and generated text/Markdown/XML content types.

Do not commit generated image variants from `deploy/static/images/`.

## Project Layout

- `Package.swift`: Swift package definition and Saga dependencies.
- `Sources/Rychillie/main.swift`: Saga pipeline, Tailwind compilation, content registration, and output cleanup.
- `Sources/Rychillie/Core/`: Site constants, localized copy, note metadata, Markdown/LLMS generation, and processors.
- `Sources/Rychillie/Layout/`: Shared HTML shell and reusable layout components.
- `Sources/Rychillie/Layout/Icons.swift`: Inline SVG icon rendering.
- `Sources/Rychillie/Pages/`: Home, notes, note detail, and about renderers.
- `Sources/Rychillie/Styles/Theme.swift`: Tailwind utility class constants used by the templates.
- `Sources/Scripts/`: Repository scripts used by Conductor.
- `content/en/notes/`: Default English notes. These build at `/notes/...`.
- `content/pt-BR/notes/`: Brazilian Portuguese notes. These build at `/pt-BR/notes/...`.
- `content/static/`: Locale-independent static assets.
- `content/static/images/`: Source images for home, social cards, brand cards, and animation.
- `content/static/tailwind.css`: Tailwind source CSS.
- `content/static/styles.css`: Generated Tailwind CSS output. This file is not committed.
- `content/_headers`: Cloudflare Pages headers.
- `content/robots.txt`: Robots file pointing to the generated sitemap.
- `deploy/`: Generated static site output. This directory is not committed.
- `.github/workflows/ci.yml`: Pull request and manual CI workflow.
- `.github/workflows/deploy-cloudflare-pages.yml`: GitHub Actions workflow for Cloudflare Pages deploys.

## CI and Deployment

Pull request CI runs from `.github/workflows/ci.yml`.

The CI workflow:

1. Runs on `macos-latest`.
2. Checks out the repository.
3. Installs the Saga CLI, ImageMagick, and SwiftLint with Homebrew.
4. Runs `swiftlint lint --quiet`.
5. Runs `saga build`.
6. Verifies `deploy/index.html`.

GitHub Actions deploys the site to Cloudflare Pages whenever code is pushed to `main`.

The deploy workflow:

1. Runs on `macos-latest`.
2. Checks out the repository.
3. Installs the Saga CLI, ImageMagick, and SwiftLint with Homebrew.
4. Runs `swiftlint lint --quiet`.
5. Runs `saga build`.
6. Verifies `deploy/index.html`.
7. Deploys `deploy/` to Cloudflare Pages with `cloudflare/wrangler-action@v3`.

## Conductor

This repository currently uses the legacy shared Conductor configuration in `conductor.json`.

- Setup verifies that Swift, the Saga CLI, ImageMagick, and SwiftLint are available.
- Run starts `saga dev` on `CONDUCTOR_PORT`, falling back to port `3000` outside Conductor.
- The setup and run commands delegate to scripts in `Sources/Scripts/`.

Conductor scripts are configured to run concurrently because each workspace receives its own port range.
