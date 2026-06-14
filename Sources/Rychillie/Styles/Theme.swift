enum Theme {
  enum Shell {
    static let body = "min-h-screen bg-white font-sans text-neutral-800 antialiased scheme-light dark:bg-neutral-950 dark:text-neutral-200 dark:scheme-dark"
    static let main = "min-h-screen"
    static let stage = "relative min-h-screen overflow-hidden bg-white dark:bg-neutral-950"
    static let topNav = "absolute top-0 left-1/2 z-10 flex h-36 w-full -translate-x-1/2 items-baseline justify-end gap-3 bg-gradient-to-b from-white to-white/0 px-6 py-[60px] text-base font-semibold leading-6 text-neutral-800 dark:from-neutral-950 dark:to-neutral-950/0 dark:text-neutral-200 md:max-w-[640px] md:gap-5 md:px-0"
    static let navActive = "text-[#9d2e29] no-underline dark:text-[#e05e58]"
    static let navLink = "text-neutral-800 no-underline hover:text-[#9d2e29] dark:text-neutral-200 dark:hover:text-[#e05e58]"
    static let footerActions = "flex flex-wrap items-center gap-3 pt-2 md:gap-4"
    static let container = "relative mx-auto flex w-full flex-col items-start gap-6 px-6 py-36 md:max-w-[640px] md:px-0"
    static let bottomFade = "pointer-events-none absolute bottom-0 left-1/2 h-36 w-full -translate-x-1/2 bg-gradient-to-b from-white/0 to-white dark:from-neutral-950/0 dark:to-neutral-950 md:max-w-[640px]"
  }

  enum Card {
    static let linked = [
      "group flex min-h-[88px] w-full items-center justify-between gap-3 rounded border border-neutral-200",
      "bg-neutral-50 py-3 pl-3 pr-4 no-underline transition-colors hover:border-neutral-300 hover:bg-white",
      "dark:rounded-lg dark:border-neutral-800 dark:bg-neutral-950 dark:hover:border-neutral-700 dark:hover:bg-neutral-900/50",
    ].joined(separator: " ")
    static let staticCard = "flex min-h-[88px] w-full items-center justify-between gap-3 rounded border border-neutral-200 bg-neutral-50 py-3 pl-3 pr-4 dark:rounded-lg dark:border-neutral-800 dark:bg-neutral-950"
    static let brand = "flex h-12 items-center justify-between gap-3 rounded border border-neutral-200 bg-neutral-50 py-3 pl-3 pr-4 dark:rounded-lg dark:border-neutral-800 dark:bg-neutral-950"
    static let content = "flex min-w-0 flex-1 flex-col justify-center gap-1"
    static let contentWithLeading = "flex min-w-0 items-center gap-3"
    static let details = "flex min-w-0 flex-col justify-center gap-1"
    static let title = "m-0 break-words text-base font-bold leading-6 text-neutral-950 dark:text-neutral-50"
    static let description = "m-0 break-words text-sm font-normal leading-5 text-neutral-800 dark:text-neutral-200"
    static let meta = "m-0 text-sm font-normal leading-5 text-neutral-800 dark:text-neutral-200"
    static let metaRow = "flex flex-wrap items-center gap-1"
    static let metaDot = "size-0.5 rounded-full bg-neutral-800 dark:bg-neutral-200"
    static let arrow = "block size-6 shrink-0 text-neutral-950 dark:text-neutral-50"
    static let avatar = "relative size-16 shrink-0"
    static let avatarImage = "size-16 rounded-full object-cover"
    static let badge = "absolute bottom-0 right-0 flex size-5 items-center justify-center rounded-full border border-neutral-200 bg-white dark:border-neutral-800 dark:bg-neutral-950"
    static let brandIcon = "block size-6 shrink-0 text-neutral-950 dark:text-neutral-50"
    static let brandAppleIcon = "block h-6 w-[19.594px] shrink-0 text-neutral-950 dark:text-neutral-50"
    static let brandOpenAIIcon = "block h-6 w-[23.631px] shrink-0 text-neutral-950 dark:text-neutral-50"
    static let brandLogo = "size-6 shrink-0 overflow-hidden rounded-[3px] object-cover"
    static let inlineAction = "flex items-center gap-2 text-base font-normal leading-6 text-neutral-800 no-underline hover:text-[#9d2e29] dark:text-neutral-200 dark:hover:text-[#e05e58]"
    static let inlineArrow = "block size-4 shrink-0"
  }

  enum Home {
    static let intro = "flex w-full scroll-mt-36 flex-col items-start gap-4 break-words leading-none tracking-normal"
    static let introTitle = "m-0 w-full font-serif text-2xl font-bold leading-8 text-[#9d2e29] dark:text-[#e05e58]"
    static let wave = "inline-block h-7 w-auto align-[-0.18em]"
    static let text = "m-0 w-full break-words text-base font-normal leading-6 text-neutral-800 dark:text-neutral-200"
    static let bento = "grid w-full grid-cols-2 gap-2 md:gap-4"
    static let bentoColumn = "flex min-w-0 flex-col gap-2 md:gap-4"
    static let bentoLink = [
      "group relative block w-full overflow-hidden rounded no-underline outline-none ring-[#9d2e29]/0",
      "focus-visible:ring-2 focus-visible:ring-[#9d2e29]/70 focus-visible:ring-offset-2 focus-visible:ring-offset-white",
      "md:rounded-2xl dark:md:rounded-lg dark:focus-visible:ring-[#e05e58]/80 dark:focus-visible:ring-offset-neutral-950",
    ].joined(separator: " ")
    static let bentoOverlay = [
      "pointer-events-none absolute inset-0 bg-gradient-to-t from-neutral-950/80 via-neutral-950/30 to-neutral-950/0",
      "opacity-0 transition-opacity duration-300 ease-out group-hover:opacity-100 group-focus-visible:opacity-100",
    ].joined(separator: " ")
    static let bentoContent = [
      "pointer-events-none absolute inset-x-0 bottom-0 flex translate-y-2 items-end justify-between gap-3 p-3 text-white",
      "opacity-0 transition duration-300 ease-out group-hover:translate-y-0 group-hover:opacity-100",
      "group-focus-visible:translate-y-0 group-focus-visible:opacity-100 md:p-4",
    ].joined(separator: " ")
    static let bentoTitle = "min-w-0 flex-1 text-sm font-bold leading-5 text-white drop-shadow-[0_1px_8px_rgba(0,0,0,0.45)] md:text-base md:leading-6"
    static let bentoArrow = "block size-5 shrink-0 text-white drop-shadow-[0_1px_8px_rgba(0,0,0,0.45)] md:size-6"
    static let imageTall = "block w-full aspect-[312/448] rounded object-cover md:rounded-2xl dark:md:rounded-lg"
    static let imageShort = "block w-full aspect-[312/216] rounded object-cover md:rounded-2xl dark:md:rounded-lg"
    static let socialCards = "grid w-full grid-cols-1 gap-2 md:grid-cols-2 md:gap-4"
    static let list = "flex w-full flex-col gap-2 md:gap-2.5"
    static let brandGrid = "flex w-full flex-wrap items-center gap-2"
  }

  enum About {
    static let header = "flex w-full flex-col items-start gap-4 break-words leading-none tracking-normal"
    static let pageTitle = "m-0 w-full font-serif text-2xl font-bold leading-8 text-[#9d2e29] dark:text-[#e05e58]"
    static let lead = "m-0 w-full break-words text-base font-semibold leading-6 text-neutral-950 dark:text-neutral-50"
    static let body = "flex w-full flex-col gap-4"
    static let text = "m-0 w-full break-words text-base font-normal leading-6 text-neutral-800 dark:text-neutral-200"
    static let career = "flex w-full flex-col items-start gap-3 pt-2"
    static let careerTitle = "m-0 w-full text-base font-bold leading-6 text-neutral-950 dark:text-neutral-50"
    static let careerList = "m-0 flex w-full list-none flex-col gap-2 p-0"
    static let careerItem = "flex w-full items-start gap-2 break-words text-base font-normal leading-6 text-neutral-800 dark:text-neutral-200"
    static let careerBullet = "mt-[0.6875rem] size-1.5 shrink-0 rounded-full bg-[#9d2e29] dark:bg-[#e05e58]"
    static let careerItemText = "min-w-0 flex-1"
  }

  enum Notes {
    static let header = "flex w-full flex-col items-start gap-4 break-words leading-none tracking-normal"
    static let pageTitle = "m-0 w-full font-serif text-2xl font-bold leading-8 text-[#9d2e29] dark:text-[#e05e58]"
    static let pageText = "m-0 w-full break-words text-base font-normal leading-6 text-neutral-800 dark:text-neutral-200"
    static let empty = "m-0 w-full rounded border border-neutral-200 bg-neutral-50 p-4 text-base leading-6 text-neutral-800 dark:rounded-lg dark:border-neutral-800 dark:bg-neutral-950 dark:text-neutral-200"
    static let list = "flex w-full flex-col gap-2 md:gap-2.5"
    static let article = "w-full"
    static let articleHeader = "mb-6 flex w-full flex-col items-start gap-3"
    static let backLink = "text-sm font-semibold leading-5 text-[#9d2e29] no-underline hover:underline dark:text-[#e05e58]"
    static let articleMeta = "flex w-full flex-wrap items-center gap-x-1 gap-y-2"
    static let metaGroup = "flex min-w-0 items-center gap-1"
    static let actions = "flex w-full items-center gap-1 md:w-auto"
    static let desktopMetaDot = "hidden size-0.5 rounded-full bg-neutral-800 dark:bg-neutral-200 md:block"
    static let actionButton = "m-0 appearance-none border-0 bg-transparent p-0 text-sm font-normal leading-5 text-[#9d2e29] underline decoration-neutral-400 underline-offset-2 transition-colors hover:decoration-[#9d2e29] dark:text-[#e05e58] dark:decoration-neutral-600 dark:hover:decoration-[#e05e58]"
    static let tags = "m-0 flex list-none flex-wrap gap-2 p-0"
    static let tag = "rounded border border-neutral-200 bg-neutral-50 px-2.5 py-0.5 text-sm leading-5 text-neutral-800 dark:border-neutral-800 dark:bg-neutral-950 dark:text-neutral-200"
  }

  enum Markdown {
    static let content = [
      "markdown-content w-full break-words text-base leading-6 text-neutral-800 dark:text-neutral-200",
      "[&_h1]:mb-5 [&_h1]:font-serif [&_h1]:text-2xl [&_h1]:font-bold [&_h1]:leading-8 [&_h1]:text-[#9d2e29] dark:[&_h1]:text-[#e05e58]",
      "[&_h2]:mt-8 [&_h2]:mb-3 [&_h2]:text-xl [&_h2]:font-bold [&_h2]:leading-7 [&_h2]:text-neutral-950 dark:[&_h2]:text-neutral-50",
      "[&_p]:mb-4",
      "[&_a]:text-[#9d2e29] [&_a]:underline [&_a]:decoration-neutral-400 [&_a]:underline-offset-2 hover:[&_a]:decoration-[#9d2e29] dark:[&_a]:text-[#e05e58] dark:[&_a]:decoration-neutral-600 dark:hover:[&_a]:decoration-[#e05e58]",
      "[&_ol]:mb-4 [&_ol]:list-decimal [&_ol]:pl-6",
      "[&_ul]:mb-4 [&_ul]:list-disc [&_ul]:pl-6",
      "[&_li]:mb-1",
      "[&_code]:rounded-[3px] [&_code]:bg-neutral-100 [&_code]:px-1.5 [&_code]:py-0.5 [&_code]:text-[0.9em] [&_code]:text-neutral-800 dark:[&_code]:bg-neutral-900 dark:[&_code]:text-neutral-100",
      "[&_pre]:mb-4 [&_pre]:overflow-x-auto [&_pre]:rounded-md [&_pre]:bg-neutral-100 [&_pre]:p-4 dark:[&_pre]:bg-neutral-900",
      "[&_pre_code]:bg-transparent [&_pre_code]:p-0 dark:[&_pre_code]:bg-transparent",
    ].joined(separator: " ")
  }
}
