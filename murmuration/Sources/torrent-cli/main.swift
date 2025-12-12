import Foundation
import torrent

// Testing torrent creation with Ubuntu torrent
// Need to adjust to multi-file torrents next
//if let torrent = Torrent(path: "/Users/cloudy/Downloads/ubuntu-25.10-desktop-amd64.iso.torrent") {
//    print("✅ Torrent created")
//    print(torrent.getValues())
//} else {
//    print("❌ Failed to create torrent")
//}

if let torrent = Torrent(path: "~/Downloads/testtorrents/lots-of-numbers.torrent") {
    print("✅ lots-of-numbers.torrent Torrent created")
    print(torrent.getValues())
} else {
    print("❌ Failed to create torrent")
}
