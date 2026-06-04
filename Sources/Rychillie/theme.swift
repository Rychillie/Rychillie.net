enum Theme {
  static let body = "mx-auto max-w-[800px] bg-white px-5 font-[-apple-system,BlinkMacSystemFont,Segoe_UI,Roboto,Oxygen,Ubuntu,sans-serif] leading-[1.6] text-neutral-800 scheme-light dark:bg-neutral-950 dark:text-neutral-200 dark:scheme-dark"
  static let nav = "mb-10 flex items-center justify-between border-b border-neutral-200 py-5 dark:border-neutral-800"
  static let siteTitle = "text-[1.2rem] font-bold text-neutral-800 no-underline hover:text-neutral-950 dark:text-neutral-100 dark:hover:text-white"
  static let navLink = "ml-5 text-neutral-500 no-underline hover:text-neutral-800 dark:text-neutral-400 dark:hover:text-neutral-100"
  static let main = "min-h-[60vh]"
  static let article = "mb-10"
  static let pageTitle = "mb-5 text-[2rem] font-bold text-neutral-800 dark:text-neutral-100"
  static let link = "text-neutral-700 underline decoration-neutral-400 underline-offset-2 hover:text-neutral-950 hover:decoration-neutral-950 dark:text-neutral-200 dark:decoration-neutral-500 dark:hover:text-white dark:hover:decoration-neutral-100"
  static let footerText = "mb-4"
  static let tags = "mb-5 flex list-none gap-2 pl-6"
  static let tagLink = "rounded-xl bg-neutral-100 px-2.5 py-0.5 text-[0.85rem] text-neutral-600 no-underline hover:bg-neutral-200 hover:text-neutral-800 dark:bg-neutral-800 dark:text-neutral-300 dark:hover:bg-neutral-700 dark:hover:text-neutral-100"
  static let articleCard = "border-b border-neutral-200 py-5 dark:border-neutral-800"
  static let articleCardTitle = "m-0 mb-2 text-[1.4rem] font-bold text-neutral-800 dark:text-neutral-100"
  static let articleCardSummary = "m-0 text-neutral-500 dark:text-neutral-400"
  static let footer = "mt-[60px] border-t border-neutral-200 py-5 text-[0.85rem] text-neutral-400 dark:border-neutral-800 dark:text-neutral-500"
  static let markdown = [
    "[&_h1]:mb-5 [&_h1]:text-[2rem] [&_h1]:font-bold [&_h1]:text-neutral-800 dark:[&_h1]:text-neutral-100",
    "[&_h2]:mt-[30px] [&_h2]:mb-2.5 [&_h2]:text-[1.4rem] [&_h2]:font-bold [&_h2]:text-neutral-800 dark:[&_h2]:text-neutral-100",
    "[&_p]:mb-4",
    "[&_a]:text-neutral-700 [&_a]:underline [&_a]:decoration-neutral-400 [&_a]:underline-offset-2 [&_a:hover]:text-neutral-950 [&_a:hover]:decoration-neutral-950 dark:[&_a]:text-neutral-200 dark:[&_a]:decoration-neutral-500 dark:[&_a:hover]:text-neutral-50 dark:[&_a:hover]:decoration-neutral-100",
    "[&_ol]:mb-4 [&_ol]:list-decimal [&_ol]:pl-6",
    "[&_ul]:mb-4 [&_ul]:list-disc [&_ul]:pl-6",
    "[&_li]:mb-1",
    "[&_code]:rounded-[3px] [&_code]:bg-neutral-100 [&_code]:px-1.5 [&_code]:py-0.5 [&_code]:text-[0.9em] [&_code]:text-neutral-800 dark:[&_code]:bg-neutral-900 dark:[&_code]:text-neutral-100",
    "[&_pre]:mb-4 [&_pre]:overflow-x-auto [&_pre]:rounded-md [&_pre]:bg-neutral-100 [&_pre]:p-4 dark:[&_pre]:bg-neutral-900",
    "[&_pre_code]:bg-transparent [&_pre_code]:p-0 dark:[&_pre_code]:bg-transparent",
  ].joined(separator: " ")
}
