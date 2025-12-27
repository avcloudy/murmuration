import AppKit
import SwiftUI

private let controlBarHeight: CGFloat = 10
private let defaultOpacity: CGFloat = 0.3
private let darkOpacity: CGFloat = 0.85

private enum filterState {
  case all, active, downloading, seeding, paused, error
}

// a way to access an NSWindow's internal properties
struct WindowAccessor: NSViewRepresentable {
  let callback: (NSWindow) -> Void

  func makeNSView(context: Context) -> NSView {
    let view = NSView()
    DispatchQueue.main.async {
      if let window = view.window {
        callback(window)
      }
    }
    return view
  }

  func updateNSView(_ nsView: NSView, context: Context) {}
}

struct ControlRow: View {
  @State private var filter: filterState = .all

  var body: some View {
    HStack(spacing: 4) {  // originally 16
      Spacer()
      Toggle(
        "All",
        isOn: Binding(
          get: { filter == .all },
          set: { if $0 { filter = .all } }
        )
      )
      .toggleStyle(.button)
      .controlSize(.mini)
      Divider()
      Toggle(
        "Active",
        isOn: Binding(
          get: { filter == .active },
          set: { if $0 { filter = .active } }
        )
      )
      .toggleStyle(.button)
      .controlSize(.mini)
      Divider()
      Toggle(
        "Downloading",
        isOn: Binding(
          get: { filter == .downloading },
          set: { if $0 { filter = .downloading } }
        )
      )
      .toggleStyle(.button)
      .controlSize(.mini)
      Divider()
      Toggle(
        "Seeding",
        isOn: Binding(
          get: { filter == .seeding },
          set: { if $0 { filter = .seeding } }
        )
      )
      .toggleStyle(.button)
      .controlSize(.mini)
      Divider()
      Toggle(
        "Paused",
        isOn: Binding(
          get: { filter == .paused },
          set: { if $0 { filter = .paused } }
        )
      )
      .toggleStyle(.button)
      .controlSize(.mini)
      Divider()
      Toggle(
        "Error",
        isOn: Binding(
          get: { filter == .error },
          set: { if $0 { filter = .error } }
        )
      )
      .toggleStyle(.button)
      .controlSize(.mini)
      Spacer()
      Image(systemName: "arrowshape.down.fill")
      Text("40.0 kbps").font(.caption)
      Image(systemName: "arrowshape.up.fill")
      Text("64.0 kbps").font(.caption)
      Spacer()
    }
    //    .padding(.horizontal, 16)
    .frame(height: controlBarHeight)
    .background(.ultraThinMaterial.opacity(darkOpacity))
    //    .background(.ultraThinMaterial.opacity(defaultOpacity))
  }
}

struct ContentView: View {

  @State private var searchText: String = ""
  @State private var selectedTorrent: Int?
  @State private var isControlBarVisible: Bool = false
  @State private var isActive: Bool = false

  var body: some View {
    ZStack(alignment: .top) {
      HostingScrollView {
        VStack(spacing: 0) {
          TorrentList(selectedTorrent: $selectedTorrent)
            .offset(y: isControlBarVisible ? controlBarHeight + 5 : 0)
            .animation(.easeInOut, value: isControlBarVisible)
        }
      }
      .ignoresSafeArea(edges: .top)
      if isControlBarVisible {
        ControlRow()
          .frame(height: controlBarHeight)
          // unnecessary duplication
          //                    .background(.ultraThinMaterial.opacity(defaultOpacity))
          .frame(maxWidth: .infinity)
          .transition(.move(edge: .top).combined(with: .opacity))
          .zIndex(1)
          .accessibilityIdentifier("ControlBarIdentifier")
      }
    }
    .background(
      WindowAccessor { window in
        window.titlebarAppearsTransparent = true
        window.styleMask.insert(.fullSizeContentView)
        window.title = ""
      }
    )
    // attached to topmost Stack
    .toolbarBackground(.ultraThinMaterial.opacity(defaultOpacity), for: .windowToolbar)
    .toolbarBackgroundVisibility(.visible, for: .windowToolbar)
    .searchable(text: $searchText)
    .toolbar(removing: .title)
    .toolbar {
      ToolbarItemGroup(placement: .automatic) {
        Button("New Torrent", systemImage: "document.badge.plus") {}
        Button("Open Torrent File", systemImage: "folder") {}
        Button("Delete Torrent", systemImage: "circle.slash") {}
        Spacer()
        Toggle("Active", isOn: $isActive).toggleStyle(.switch).controlSize(.regular)
        // old pause/resume buttons, replaced by toggle
        //                ControlGroup {
        //                    Button("Pause All", systemImage: "pause") {}
        //                    Button("Resume All", systemImage: "play") {}
        //                }.controlGroupStyle(.automatic)
        Spacer()
      }
      ToolbarItemGroup(placement: .primaryAction) {
        Button("Share", systemImage: "pause.circle.fill") {}
        Button("Quick Look", systemImage: "eye") {}
        Button("Inspector", systemImage: "i.circle") {}
        Toggle(
          "Toggle Control Bar",
          systemImage: "chevron.up.chevron.down",
          isOn: $isControlBarVisible
        )
        .toggleStyle(.button)
        .accessibilityIdentifier("ControlBarToggle")
        Spacer()
      }
    }

  }
}
