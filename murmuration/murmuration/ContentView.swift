//
//  ContentView.swift
//  murmuration
//
//  Created by Tyler Hall on 27/12/2025.
//

import AppKit
import SwiftUI

private let controlBarHeight: CGFloat = 10
private let defaultOpacity: CGFloat = 0.3

/// A view that applies a configuration closure to the hosting NSWindow.
struct WindowAccessor: NSViewRepresentable {
  let callback: (NSWindow) -> Void

  func makeNSView(context: Context) -> NSView {
    let view = NSView()
    DispatchQueue.main.async {  // ensure the window exists
      if let window = view.window {
        callback(window)
      }
    }
    return view
  }

  func updateNSView(_ nsView: NSView, context: Context) {}
}

struct ControlRow: View {
  var body: some View {
    HStack(spacing: 16) {
      Button("All") {}.controlSize(.mini)
      Button("Active") {}.controlSize(.mini)
      Button("Downloading") {}.controlSize(.mini)
      Button("Seeding") {}.controlSize(.mini)
      Button("Paused") {}.controlSize(.mini)
      Button("Error") {}.controlSize(.mini)
      Spacer()
    }
    .padding(.horizontal, 16)
    .frame(height: controlBarHeight)
    .background(.ultraThinMaterial.opacity(defaultOpacity))
  }
}

struct ContentView: View {

  @State private var searchText: String = ""
  @State private var selectedTorrent: Int?
  @State private var isControlBarVisible: Bool = true

  var body: some View {
    NavigationStack {
      ZStack(alignment: .top) {
        // Scrollable content
        HostingScrollView {
          VStack(spacing: 0) {
            TorrentList(selectedTorrent: $selectedTorrent)
              //                            .padding(.top, isControlBarVisible ? controlBarHeight : 0)
              .offset(y: isControlBarVisible ? controlBarHeight + 5 : 0)  // slide down/up
              .animation(.easeInOut, value: isControlBarVisible)
          }
        }
        .ignoresSafeArea(edges: .top)
        if isControlBarVisible {
          ControlRow()
            .frame(height: controlBarHeight)
            .background(.ultraThinMaterial.opacity(defaultOpacity))
            .frame(maxWidth: .infinity)
            .transition(.move(edge: .top).combined(with: .opacity))
            .zIndex(1)  // render above scroll content
        }
      }
      //            .navigationTitle("") // set empty title
    }
    .background(
      WindowAccessor { window in
        window.titlebarAppearsTransparent = true
        window.styleMask.insert(.fullSizeContentView)
        window.title = ""
      }
    )
    .toolbarBackground(.ultraThinMaterial.opacity(defaultOpacity), for: .windowToolbar)
    .toolbarBackgroundVisibility(.visible, for: .windowToolbar)
    .searchable(text: $searchText)
    .toolbar {
      ToolbarItemGroup(placement: .automatic) {
        Button("New", systemImage: "document.badge.plus") {}
        Button("Open", systemImage: "folder") {}
        Button("Delete", systemImage: "circle.slash") {}
        Spacer()
      }
      ToolbarItem(placement: .secondaryAction) {
        ControlGroup {
          Button("pause", systemImage: "pause") {}
          Button("play", systemImage: "play") {}
          Spacer()
        }.controlGroupStyle(.automatic)
      }
      ToolbarItemGroup(placement: .primaryAction) {
        Button("share", systemImage: "pause.circle.fill") {}
        Button("quick look", systemImage: "eye") {}
        Button("inspector", systemImage: "i.circle") {}
        Button(
          "Toggle Control Bar", systemImage: "chevron.up.chevron.down",
          action: {
            withAnimation(.easeInOut) { isControlBarVisible.toggle() }
          })
        Spacer()
      }
    }
  }
}
