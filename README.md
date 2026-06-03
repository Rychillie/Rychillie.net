# Rychillie.net

Personal static website built with [Saga](https://getsaga.dev), a Swift static site generator.

## Requirements

- Swift 6.0 or newer
- macOS 14 or newer
- Saga CLI

Install the Saga CLI with Homebrew:

```sh
brew install loopwerk/tap/saga
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

Saga reads content from `content/` and writes the generated site to `deploy/`.

## Project Layout

- `Package.swift`: Swift package definition and Saga dependencies.
- `Sources/Rychillie/`: Swift entry point and HTML templates for the site.
- `Sources/Scripts/`: Repository scripts used by Conductor.
- `content/`: Markdown pages, articles, and static assets.
- `deploy/`: Generated static site output. This directory is not committed.

## Conductor

This repository includes shared Conductor scripts in `conductor.json`.

- Setup verifies that Swift and the Saga CLI are available.
- Run starts `saga dev` on `CONDUCTOR_PORT`, falling back to port `3000` outside Conductor.

Conductor scripts are configured to run concurrently because each workspace receives its own port range.
