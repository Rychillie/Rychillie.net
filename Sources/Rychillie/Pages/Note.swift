import HTML
import Saga

func renderNote(context: ItemRenderingContext<NoteMetadata>) -> Node {
  let locale = Site.currentLocale(context.locale)
  let copy = Site.copy(for: locale)
  let canonicalPath = context.translations[locale] ?? context.item.url
  let canonicalURL = Site.absoluteURL(for: canonicalPath)
  let markdownPath = LLMS.markdownPath(for: context.item)
  let description = context.item.metadata.summary ?? context.item.title

  return baseHtml(
    title: context.item.title,
    description: description,
    canonicalPath: canonicalPath,
    locale: locale,
    translations: context.translations,
    ogType: "article",
    markdownAlternatePath: markdownPath
  ) {
    pageFrame(activeSection: .notes, locale: locale, translations: context.translations) {
      article(class: Theme.Notes.article) {
        header(class: Theme.Notes.articleHeader) {
          h1(class: Theme.Notes.pageTitle) { context.item.title }
          div(class: Theme.Notes.articleMeta) {
            div(class: Theme.Notes.metaGroup) {
              p(class: Theme.Card.meta) { context.item.metadata.displayType.label(locale: locale) }
              span(class: Theme.Card.metaDot) {}
              p(class: Theme.Card.meta) { Site.displayDate(context.item.date, locale: locale) }
            }
            noteCopyActions(copy: copy, canonicalURL: canonicalURL, markdownPath: markdownPath)
          }
        }
        div(class: Theme.Markdown.content) {
          Node.raw(context.item.body)
        }
      }
      noteCopyScript()
    }
  }
}

@NodeBuilder
func noteCopyActions(copy: SiteCopy, canonicalURL: String, markdownPath: String) -> NodeConvertible {
  div(class: Theme.Notes.actions) {
    span(class: Theme.Notes.desktopMetaDot) {}
    button(
      class: Theme.Notes.actionButton,
      type: "button",
      customAttributes: [
        "data-copy-note-link": "",
        "data-copy-value": canonicalURL,
        "data-default-label": copy.copyLinkAction,
        "data-copied-label": copy.copiedAction,
      ]
    ) {
      copy.copyLinkAction
    }

    span(class: Theme.Card.metaDot) {}
    button(
      class: Theme.Notes.actionButton,
      type: "button",
      customAttributes: [
        "data-copy-note-markdown": "",
        "data-markdown-url": markdownPath,
        "data-default-label": copy.copyMarkdownAction,
        "data-copied-label": copy.copiedAction,
      ]
    ) {
      copy.copyMarkdownAction
    }
  }
}

func noteCopyScript() -> Node {
  script {
    Node.raw("""
    (function () {
      var timers = new WeakMap();

      function markCopied(button) {
        var copiedLabel = button.dataset.copiedLabel;
        var defaultLabel = button.dataset.defaultLabel;
        if (!copiedLabel || !defaultLabel) {
          return;
        }

        button.textContent = copiedLabel;
        if (timers.has(button)) {
          window.clearTimeout(timers.get(button));
        }

        timers.set(button, window.setTimeout(function () {
          button.textContent = defaultLabel;
        }, 1600));
      }

      async function copyText(text) {
        if (!navigator.clipboard || !window.isSecureContext) {
          throw new Error("Clipboard unavailable");
        }

        await navigator.clipboard.writeText(text);
      }

      document.querySelectorAll("[data-copy-note-link]").forEach(function (button) {
        button.addEventListener("click", async function () {
          var value = button.dataset.copyValue;
          if (!value) {
            return;
          }

          try {
            await copyText(value);
            markCopied(button);
          } catch (_) {
            window.prompt(button.dataset.defaultLabel || "Copy link", value);
          }
        });
      });

      document.querySelectorAll("[data-copy-note-markdown]").forEach(function (button) {
        button.addEventListener("click", async function () {
          var markdownURL = button.dataset.markdownUrl;
          if (!markdownURL) {
            return;
          }

          try {
            var response = await fetch(markdownURL, {
              headers: {
                "Accept": "text/markdown,text/plain;q=0.9,*/*;q=0.8"
              }
            });
            if (!response.ok) {
              throw new Error("Markdown unavailable");
            }

            var contentType = response.headers.get("content-type") || "";
            var markdown = await response.text();
            var start = markdown.trimStart().slice(0, 32).toLowerCase();
            if (contentType.indexOf("text/html") !== -1 || start.indexOf("<!doctype") === 0 || start.indexOf("<html") === 0) {
              throw new Error("Markdown response was HTML");
            }

            await copyText(markdown);
            markCopied(button);
          } catch (_) {
            window.location.href = markdownURL;
          }
        });
      });
    })();
    """)
  }
}
