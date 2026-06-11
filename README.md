# Rychillie.net

Personal static website built with [Saga](https://getsaga.dev), a Swift static site generator.

The site is generated from localized Markdown content in `content/`, rendered by Swift templates, styled with Tailwind CSS utilities, and deployed to Cloudflare Pages.

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

The generated files in `deploy/` are ignored by git. Tailwind also writes `content/static/styles.css`, which is generated and ignored.

## Styling

Tailwind CSS is compiled during the Saga build through [`SwiftTailwind`](https://github.com/loopwerk/SwiftTailwind).

- `content/static/tailwind.css` is the Tailwind input file.
- `content/static/styles.css` is the generated minified CSS output.
- `Sources/Rychillie/Styles/Theme.swift` centralizes the Tailwind utility strings used by the Swift templates.
- `Sources/Rychillie/Layout/Layout.swift` links the generated CSS with `Saga.hashed("/static/styles.css")`, so deployed pages reference a cache-friendly hashed stylesheet.
- `Sources/Rychillie/main.swift` removes `static/tailwind.css` from the generated `deploy/` output after Saga writes the site.

When changing visual styling, prefer updating `Theme` or `content/static/tailwind.css`. Do not edit `content/static/styles.css` directly.

## Site Generation

The main Saga pipeline lives in `Sources/Rychillie/main.swift`.

- It compiles Tailwind before Saga runs.
- It uses `content/` as input and `deploy/` as output.
- It configures Saga i18n with `en` as the default locale and `pt-BR` under `/pt-BR/`.
- It recompiles Tailwind when CSS changes during development.
- It ignores generated `styles.css` changes in the Saga file watcher.
- It registers note Markdown files from `content/en/notes/` and `content/pt-BR/notes/` with `NoteMetadata`, including required `tags` and optional `summary`.
- It renders template-driven home, notes, and about pages once per locale.

Templates are built with Saga Swim renderer helpers and use [Moon](https://github.com/loopwerk/Moon) for code highlighting.

## Project Layout

- `Package.swift`: Swift package definition and Saga dependencies.
- `Sources/Rychillie/main.swift`: Saga pipeline, Tailwind compilation, content registration, and output cleanup.
- `Sources/Rychillie/Layout/`: Shared HTML shell and reusable layout components.
- `Sources/Rychillie/Pages/`: Home, notes, note detail, and about renderers.
- `Sources/Rychillie/Styles/Theme.swift`: Tailwind utility class constants used by the templates.
- `Sources/Scripts/`: Repository scripts used by Conductor.
- `content/en/notes/`: Default English notes. These build at `/notes/...`.
- `content/pt-BR/notes/`: Brazilian Portuguese notes. These build at `/pt-BR/notes/...`.
- `content/static/`: Locale-independent static assets.
- `content/static/tailwind.css`: Tailwind source CSS.
- `content/static/styles.css`: Generated Tailwind CSS output. This file is not committed.
- `deploy/`: Generated static site output. This directory is not committed.
- `.github/workflows/deploy-cloudflare-pages.yml`: GitHub Actions workflow for Cloudflare Pages deploys.

## Deployment

GitHub Actions deploys the site to Cloudflare Pages whenever code is pushed to `main`.

The workflow:

1. Runs on `macos-latest`.
2. Checks out the repository.
3. Installs the Saga CLI, ImageMagick, and SwiftLint with Homebrew.
4. Runs `swiftlint lint --quiet`.
5. Runs `saga build`.
6. Verifies `deploy/index.html`.
7. Deploys `deploy/` to Cloudflare Pages with `cloudflare/wrangler-action@v3`.

## Conductor

This repository includes shared Conductor scripts in `conductor.json`.

- Setup verifies that Swift, the Saga CLI, ImageMagick, and SwiftLint are available.
- Run starts `saga dev` on `CONDUCTOR_PORT`, falling back to port `3000` outside Conductor.

Conductor scripts are configured to run concurrently because each workspace receives its own port range.
