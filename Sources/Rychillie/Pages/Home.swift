import HTML
import Saga

func renderHome(context: PageRenderingContext) -> Node {
  baseHtml(title: Site.name) {
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
        homeCard(
          title: "@rychillie",
          subtitle: "1,550 subscribers",
          avatar: "youtube-avatar.png",
          badgeLight: "youtube-light.svg",
          badgeDark: "youtube-dark.svg",
          badgeClass: "h-[8.438px] w-3",
          href: "https://www.youtube.com/@rychillie"
        )
        homeCard(
          title: "@rychillie",
          subtitle: "12,100 members",
          avatar: "discord-avatar.png",
          badgeLight: "discord.svg",
          badgeClass: "h-[9.328px] w-3"
        )
      }

      homeText("Pariatur dolore excepteur officia exercitation minim laborum est fugiat. Anim fugiat eiusmod mollit magna eu ipsum fugiat pariatur dolor deserunt magna. Nostrud non eiusmod veniam enim elit minim sint consequat mollit Lorem minim.")

      div(class: Theme.Home.list) {
        homeContentItem(title: "OpenClaw My Personal Secretary", kind: "Talk", date: "April 29, 2026")
        homeContentItem(title: "Getting Started on Swift by creating a CRUD with Vapor", kind: "Article", date: "October 18, 2024")
        homeContentItem(title: "useFetch a custom React Hook", kind: "Article", date: "March 21, 2024")
      }

      homeText("Pariatur dolore excepteur officia exercitation minim laborum est fugiat.")

      div(class: Theme.Home.brandGrid) {
        brandChip(name: "Apple", lightIcon: "apple-light.svg", darkIcon: "apple-dark.svg", iconClass: Theme.Home.brandAppleIcon)
        brandChip(name: "Chargeblast", image: "chargeblast.png")
        brandChip(name: "Anthropic", lightIcon: "anthropic-light.svg", darkIcon: "anthropic-dark.svg")
        brandChip(name: "OpenAI", lightIcon: "openai-light.svg", darkIcon: "openai-dark.svg", iconClass: Theme.Home.brandOpenAIIcon)
      }

      homeText("Pariatur dolore excepteur officia exercitation minim laborum est fugiat. Anim fugiat eiusmod mollit magna eu ipsum fugiat pariatur dolor deserunt magna.")

      div(class: Theme.Home.socialLinks) {
        homeSocialAction("fallow me")
        homeSocialAction("get email updates")
      }
    }
  }
}
