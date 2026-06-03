# Agent Instructions

This repository contains a personal static website built with Swift and Saga.

## Project Context

- Use Saga as the static site generator.
- The Swift executable target lives in `Sources/Rychillie`.
- Conductor helper scripts live in `Sources/Scripts` and should not be moved into `Sources/Rychillie`.
- Content lives in `content/`.
- Generated output goes to `deploy/` and should not be edited or committed.

## Development Rules

- Keep repository documentation and agent-facing instructions in English.
- Prefer editing source templates, content files, and styles over generated files.
- Use `origin/main` as the comparison base for diffs and pull requests in Conductor workspaces.
- Do not rename the current branch unless the user explicitly asks.
- Keep changes focused on the requested website behavior, content, or configuration.

## Validation

- Run `saga build` after meaningful changes to Swift templates, Saga configuration, styles, or content.
- Use `saga dev --port "$CONDUCTOR_PORT"` for local preview inside Conductor when needed.
- If the Saga CLI is missing, install it with:

```sh
brew install loopwerk/tap/saga
```
