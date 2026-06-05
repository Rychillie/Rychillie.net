import Moon
import Saga

func syntaxHighlight<M: Metadata>(item: Item<M>) {
  item.body = Moon.shared.highlightCodeBlocks(in: item.body)
}
