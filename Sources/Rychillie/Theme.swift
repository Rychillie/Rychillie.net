enum Theme {
  static let body = "mx-auto max-w-[800px] px-5 font-[-apple-system,BlinkMacSystemFont,Segoe_UI,Roboto,Oxygen,Ubuntu,sans-serif] leading-[1.6] text-[#333]"
  static let nav = "mb-10 flex items-center justify-between border-b border-[#eee] py-5"
  static let siteTitle = "text-[1.2rem] font-bold text-[#333] no-underline hover:text-[#004499]"
  static let navLink = "ml-5 text-[#666] no-underline hover:text-[#333]"
  static let main = "min-h-[60vh]"
  static let article = "mb-10"
  static let pageTitle = "mb-5 text-[2rem] font-bold"
  static let link = "text-[#0066cc] underline hover:text-[#004499]"
  static let footerText = "mb-4"
  static let tags = "mb-5 flex list-none gap-2 pl-6"
  static let tagLink = "rounded-xl bg-[#f0f0f0] px-2.5 py-0.5 text-[0.85rem] text-[#555] no-underline hover:bg-[#e0e0e0] hover:text-[#555]"
  static let articleCard = "border-b border-[#eee] py-5"
  static let articleCardTitle = "m-0 mb-2 text-[1.4rem] font-bold"
  static let articleCardSummary = "m-0 text-[#666]"
  static let footer = "mt-[60px] border-t border-[#eee] py-5 text-[0.85rem] text-[#999]"
  static let markdown = [
    "[&_h1]:mb-5 [&_h1]:text-[2rem] [&_h1]:font-bold",
    "[&_h2]:mt-[30px] [&_h2]:mb-2.5 [&_h2]:text-[1.4rem] [&_h2]:font-bold",
    "[&_p]:mb-4",
    "[&_a]:text-[#0066cc] [&_a]:underline [&_a:hover]:text-[#004499]",
    "[&_ol]:mb-4 [&_ol]:list-decimal [&_ol]:pl-6",
    "[&_ul]:mb-4 [&_ul]:list-disc [&_ul]:pl-6",
    "[&_li]:mb-1",
    "[&_code]:rounded-[3px] [&_code]:bg-[#f5f5f5] [&_code]:px-1.5 [&_code]:py-0.5 [&_code]:text-[0.9em]",
    "[&_pre]:mb-4 [&_pre]:overflow-x-auto [&_pre]:rounded-md [&_pre]:bg-[#f5f5f5] [&_pre]:p-4",
    "[&_pre_code]:bg-transparent [&_pre_code]:p-0",
  ].joined(separator: " ")
}
