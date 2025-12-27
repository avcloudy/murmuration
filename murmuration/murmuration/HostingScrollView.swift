import SwiftUI

// custom list view to allow scrolling into titlebar
struct HostingScrollView<Content: View>: NSViewRepresentable {

  let content: Content

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  func makeNSView(context: Context) -> NSScrollView {
    let scrollView = NSScrollView()
    scrollView.hasVerticalScroller = true
    scrollView.autohidesScrollers = true
    scrollView.drawsBackground = false
    scrollView.borderType = .noBorder

    let clipView = NSClipView()
    clipView.drawsBackground = false
    scrollView.contentView = clipView

    let hostingView = NSHostingView(rootView: content)
    hostingView.translatesAutoresizingMaskIntoConstraints = false

    scrollView.documentView = hostingView

    NSLayoutConstraint.activate([
      hostingView.leadingAnchor.constraint(equalTo: clipView.leadingAnchor),
      hostingView.trailingAnchor.constraint(equalTo: clipView.trailingAnchor),
      hostingView.topAnchor.constraint(equalTo: clipView.topAnchor),
      hostingView.widthAnchor.constraint(equalTo: clipView.widthAnchor),
    ])

    return scrollView
  }

  func updateNSView(_ scrollView: NSScrollView, context: Context) {
    if let hostingView = scrollView.documentView as? NSHostingView<Content> {
      hostingView.rootView = content
    }
  }
}
