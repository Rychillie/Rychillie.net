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
- `content/static/tailwind.css` is the Tailwind source file. It currently imports Tailwind CSS.
- `Sources/Rychillie/theme.swift` centralizes Tailwind utility class strings for layout, typography, dark mode, article lists, tags, and Markdown rendering.
- `Sources/Rychillie/main.swift` is responsible for compiling Tailwind through `SwiftTailwind`, running Saga from `content/` to `deploy/`, registering Markdown readers/writers, and removing `static/tailwind.css` from the generated output.

## Development Rules

- Prefer editing source templates, content files, and styles over generated files.
- Prefer adding or changing reusable visual classes in `Theme` instead of scattering long class strings through templates, unless a class is truly one-off.
- If styling changes require new Tailwind utilities, update the Swift templates/theme or `content/static/tailwind.css`; do not edit `content/static/styles.css`.
- Pages and articles are Markdown files under `content/`. Article metadata uses `tags` and optional `summary`.
- `Sources/Rychillie/templates.swift` renders pages, article pages, article indexes, tag pages, the shared shell, hashed CSS link, and Moon syntax highlighting.
- Use `origin/main` as the comparison base for diffs and pull requests in Conductor workspaces.
- Do not rename the current branch unless the user explicitly asks.
- Keep changes focused on the requested website behavior, content, or configuration.
- Do not commit local secrets or Conductor context files. `.context/cloudflare.env` is only for local Cloudflare testing.

## Deployment

- GitHub Actions deploys to Cloudflare Pages on pushes to `main`.
- The workflow lives in `.github/workflows/deploy-cloudflare-pages.yml`.
- The workflow uses `macos-latest`, installs the Saga CLI, runs `saga build`, verifies `deploy/index.html`, and deploys `deploy/` with `cloudflare/wrangler-action@v3`.
- The Cloudflare Pages project name is `rychillie`.

## Conductor

- This repository includes shared Conductor scripts in `conductor.json`.
- Setup runs `zsh Sources/Scripts/conductor-setup.sh` and verifies Swift and the Saga CLI.
- Run starts `saga dev` through `zsh Sources/Scripts/conductor-run.sh`.
- The run script uses `CONDUCTOR_PORT`, falling back to `3000` outside Conductor.
- `runScriptMode` is `concurrent` because each workspace receives its own port range.

## Validation

- Run `saga build` after meaningful changes to Swift templates, Saga configuration, Tailwind styling, or content.
- For documentation-only changes, `git diff --check` is sufficient unless the docs describe behavior that needs verification.
- Use `saga dev --port "$CONDUCTOR_PORT"` for local preview inside Conductor when needed.
- If the Saga CLI is missing, install it with:

```sh
brew install loopwerk/tap/saga
```
