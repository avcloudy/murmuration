import Foundation
import torrent

// Testing torrent creation with Ubuntu torrent
// Need to adjust to multi-file torrents next
if let torrent = Torrent(
    path: "/Users/cloudy/Downloads/testtorrents/ubuntu-25.10-desktop-amd64.iso.torrent")
{
    print("✅ Torrent created")
    //    print(torrent.getValues())
    print(type(of: torrent.announce))
    print(type(of: torrent.announceList))
    print(torrent.announceList!)
    print(type(of: torrent.comment))
    print(type(of: torrent.creationDate))
    print(type(of: torrent.createdBy))
    print(type(of: torrent.length))
    print(type(of: torrent.name))
    print(type(of: torrent.pieceLength))
    print(type(of: torrent.pieces))
    print(type(of: torrent.isPrivate))
} else {
    print("❌ Failed to create torrent")
}

//let url = URL(fileURLWithPath: "/Users/cloudy/Downloads/testtorrents/ubuntu-25.10-desktop-amd64.iso.torrent")
//let fileData = (try? Data(contentsOf: url)) ?? Data()
//
//
//
//if let decoded = try? decode(data: fileData) {
//    if let nativeDict: [String: [String]] = decoded.unwrap() {
//        print(nativeDict["announce-list"])
//    }
//}
