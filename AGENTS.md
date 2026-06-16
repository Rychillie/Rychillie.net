# Agent Instructions

This repository contains a personal static website built with Swift and Saga.
Keep agent-facing instructions and repository documentation in English.

## Project Context

- Use Saga as the static site generator. The site is produced by the `Rychillie` Swift executable target.
- The Swift executable target lives in `Sources/Rychillie`.
- Conductor helper scripts live in `Sources/Scripts` and should not be moved into `Sources/Rychillie`.
- Content lives in `content/`.
- Generated output goes to `deploy/` and should not be edited or committed.
- Generated Tailwind output goes to `content/static/styles.css` and should not be edited or committed.
- Generated responsive image variants go to `deploy/static/images/` and should not be edited or committed.
- `content/static/tailwind.css` is the Tailwind source file. It currently imports Tailwind CSS.
- `Sources/Rychillie/Styles/Theme.swift` centralizes Tailwind utility class strings for layout, typography, dark mode, cards, notes, tags, and Markdown rendering.
- `Sources/Rychillie/Core/` contains site constants, localized copy, content metadata, Markdown/LLMS generation, and processors.
- `Sources/Rychillie/Layout/` contains the shared HTML shell, reusable layout components, and inline Swift-rendered SVG icons.
- `Sources/Rychillie/Pages/` contains the home, notes index, note detail, and about renderers.
- `Sources/Rychillie/main.swift` is responsible for compiling Tailwind through `SwiftTailwind`, running Saga from `content/` to `deploy/`, registering Markdown readers/writers, rendering localized pages, generating LLMS/Markdown outputs, generating responsive images, and removing source-only static files from generated output.

## Development Rules

- Prefer editing source templates, content files, and styles over generated files.
- Prefer adding or changing reusable visual classes in `Theme` instead of scattering long class strings through templates, unless a class is truly one-off.
- If styling changes require new Tailwind utilities, update Swift templates, `Theme`, or `content/static/tailwind.css`; do not edit `content/static/styles.css`.
- Pages and notes are Markdown files under `content/`, localized under `content/en/notes/` and `content/pt-BR/notes/`.
- Note metadata uses required `tags`, optional `summary`, and optional `type`. Supported note types are `article`, `talk`, `video`, `participated`, and `other`; missing `type` defaults to `article`.
- The home page bento grid links to localized event notes and should keep English and Portuguese paths in sync.
- Use `Sources/Rychillie/Core/Site.swift` for shared site constants, localized copy, locale paths, and external links.
- Use `Sources/Rychillie/Layout/Layout.swift` for the base shell, metadata, canonical/alternate links, Markdown alternates, hashed CSS link, navigation, and footer.
- Use `Sources/Rychillie/Layout/Components.swift` for shared cards, responsive image helpers, note cards, and inline action links.
- Use `Sources/Rychillie/Layout/Icons.swift` for inline SVG icons instead of adding static icon files.
- Use `Sources/Rychillie/Core/LLMS.swift` for `/llms.txt`, `/llms-full.txt`, and clean per-note `.md` output. Do not hand-edit generated Markdown in `deploy/`.
- Use `Sources/Rychillie/Core/Processors.swift` for Moon syntax highlighting processors.
- `content/static/images/` contains source images. `Sources/Scripts/generate-images.sh` creates optimized PNG/WebP/GIF variants during `saga build`.
- `content/_headers` controls Cloudflare Pages cache headers and content types for generated CSS, images, Markdown, text, and XML files.
- Use `origin/main` as the comparison base for diffs and pull requests in Conductor workspaces.
- Do not rename the current branch unless the user explicitly asks.
- Keep changes focused on the requested website behavior, content, or configuration.
- Do not commit local secrets or Conductor context files. `.context/cloudflare.env` is only for local Cloudflare testing.

## Deployment

- Pull request CI runs from `.github/workflows/ci.yml`.
- GitHub Actions deploys to Cloudflare Pages on pushes to `main`.
- The workflow lives in `.github/workflows/deploy-cloudflare-pages.yml`.
- CI and deploy workflows use `macos-latest`, install the Saga CLI, ImageMagick, and SwiftLint, run `swiftlint lint --quiet`, run `saga build`, and verify `deploy/index.html`.
- The deploy workflow deploys `deploy/` with `cloudflare/wrangler-action@v3`.
- The Cloudflare Pages project name is `rychillie`.

## Conductor

- This repository currently uses the legacy shared Conductor configuration in `conductor.json`; do not migrate it to `.conductor/settings.toml` unless the user explicitly asks.
- Setup runs `zsh Sources/Scripts/conductor-setup.sh` and verifies Swift, the Saga CLI, ImageMagick, and SwiftLint.
- Run starts `saga dev` through `zsh Sources/Scripts/conductor-run.sh`.
- The run script uses `CONDUCTOR_PORT`, falling back to `3000` outside Conductor.
- `runScriptMode` is `concurrent` because each workspace receives its own port range.

## Validation

- Run `saga build` after meaningful changes to Swift templates, Saga configuration, Tailwind styling, or content.
- Run `swiftlint lint --quiet` after meaningful Swift changes.
- For documentation-only changes, `git diff --check` is sufficient unless the docs describe behavior that needs verification.
- Use `saga dev --port "$CONDUCTOR_PORT"` for local preview inside Conductor when needed.
- If required build tools are missing, install them with:

```sh
brew install loopwerk/tap/saga imagemagick swiftlint
```
