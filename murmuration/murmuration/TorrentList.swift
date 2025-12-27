import SwiftUI

// TODO: Need to do some thinking about this
// for instance, need to preserve alternating colours
struct TorrentList: View {

  @Binding var selectedTorrent: Int?

  var body: some View {
    LazyVStack(spacing: 0) {
      ForEach(0..<500, id: \.self) { index in
        Torrent(index: index)
          .background(
            selectedTorrent == index
              ? Color.accentColor.opacity(0.25)
              : index % 2 == 0
                ? Color.gray.opacity(0.05)
                : Color.gray.opacity(0.15)
          )
          .contentShape(Rectangle())
          .onTapGesture {
            selectedTorrent = index
          }
      }
    }
  }
}
