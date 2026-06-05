import HTML
import Saga

func renderHome(context: PageRenderingContext) -> Node {
  let latestNotes = Array(context.allItems
    .compactMap { $0 as? Item<NoteMetadata> }
    .sorted { $0.date > $1.date }
    .prefix(3))

  return baseHtml(title: Site.name) {
    pageFrame(activeSection: .home) {
      section(class: Theme.Home.intro, id: "about") {
        h1(class: Theme.Home.introTitle) { "Hey, I'm Rychillie 👋" }
        homeText(Site.intro)
      }

      div(class: Theme.Home.bento) {
        div(class: Theme.Home.bentoColumn) {
          assetImage("bento-portrait-1.png", alt: "Rychillie portrait", class: Theme.Home.imageTall)
          assetImage("bento-wide-1.png", alt: "BrazilJS event", class: Theme.Home.imageShort)
        }
        div(class: Theme.Home.bentoColumn) {
          assetImage("bento-wide-2.png", alt: "Rychillie speaking", class: Theme.Home.imageShort)
          assetImage("bento-portrait-2.png", alt: "Rychillie on stage", class: Theme.Home.imageTall)
        }
      }

      homeText("Pariatur dolore excepteur officia exercitation minim laborum est fugiat. Anim fugiat eiusmod mollit magna eu ipsum fugiat pariatur dolor deserunt magna. Nostrud non eiusmod veniam enim elit minim sint consequat mollit Lorem minim. Consectetur dolore nisi ex ex velit aute cillum eiusmod commodo eiusmod.")

      div(class: Theme.Home.socialCards) {
        siteCard(
          title: "@rychillie",
          subtitle: "1,550 subscribers",
          href: Site.Link.youtube,
          leading: .avatar(
            image: "youtube-avatar.png",
            badge: CardBadge(light: "youtube-light.svg", dark: "youtube-dark.svg", className: "h-[8.438px] w-3")
          )
        )
        siteCard(
          title: "@rychillie",
          subtitle: "12,100 members",
          href: Site.Link.community,
          leading: .avatar(
            image: "discord-avatar.png",
            badge: CardBadge(light: "discord.svg", dark: nil, className: "h-[9.328px] w-3")
          )
        )
      }

      homeText("Pariatur dolore excepteur officia exercitation minim laborum est fugiat. Anim fugiat eiusmod mollit magna eu ipsum fugiat pariatur dolor deserunt magna. Nostrud non eiusmod veniam enim elit minim sint consequat mollit Lorem minim.")

      if !latestNotes.isEmpty {
        div(class: Theme.Home.list) {
          latestNotes.map { note in
            noteCard(note)
          }
        }
      }

      homeText("Pariatur dolore excepteur officia exercitation minim laborum est fugiat.")

      div(class: Theme.Home.brandGrid) {
        siteCard(title: "Apple", leading: .icon(light: "apple-light.svg", dark: "apple-dark.svg", className: Theme.Card.brandAppleIcon), showsArrow: false)
        siteCard(title: "Chargeblast", leading: .image(name: "chargeblast.png", className: Theme.Card.brandLogo), showsArrow: false)
        siteCard(title: "Anthropic", leading: .icon(light: "anthropic-light.svg", dark: "anthropic-dark.svg", className: Theme.Card.brandIcon), showsArrow: false)
        siteCard(title: "OpenAI", leading: .icon(light: "openai-light.svg", dark: "openai-dark.svg", className: Theme.Card.brandOpenAIIcon), showsArrow: false)
      }

      homeText("Pariatur dolore excepteur officia exercitation minim laborum est fugiat. Anim fugiat eiusmod mollit magna eu ipsum fugiat pariatur dolor deserunt magna.")

      div(class: Theme.Home.socialLinks) {
        inlineActionLink(title: "fallow me", href: Site.Link.follow)
        inlineActionLink(title: "get email updates", href: Site.Link.emailUpdates)
      }
    }
  }
}
