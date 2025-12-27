//
//  TorrentList.swift
//  murmuration
//
//  Created by Tyler Hall on 27/12/2025.
//

import SwiftUI

struct TorrentList: View {

  @Binding var selectedTorrent: Int?

  var body: some View {
    LazyVStack(spacing: 0) {
      ForEach(0..<500, id: \.self) { index in
        Torrent(index: index)
          .background(
            selectedTorrent == index
              ? Color.accentColor.opacity(0.15)
              : Color.clear
          )
          .contentShape(Rectangle())
          .onTapGesture {
            selectedTorrent = index
          }
      }
    }
  }
}
