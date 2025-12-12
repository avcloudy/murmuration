import Testing

@testable import torrent

class TorrentReadTests {
    let torrent = Torrent(path: "/Users/cloudy/Downloads/ubuntu-25.10-desktop-amd64.iso.torrent")

    @Test
    func announceName() {
        let torrentDict = torrent!.getValues()
        #expect(torrentDict["announce"] as? String == "https://torrent.ubuntu.com/announce")
    }

    @Test
    func announceList() {
        let torrentDict = torrent!.getValues()
        #expect(
            torrentDict["announceList"] as? [String] == [
                "https://torrent.ubuntu.com/announce", "https://ipv6.torrent.ubuntu.com/announce",
            ])
    }

    @Test
    func comment() {
        let torrentDict = torrent!.getValues()
        #expect(torrentDict["comment"] as? String == "Ubuntu CD releases.ubuntu.com")
    }

    @Test
    func creationDate() {
        let torrentDict = torrent!.getValues()
        #expect(torrentDict["creationDate"] as? Int == 1_759_993_240)
    }

    @Test
    func createdBy() {
        let torrentDict = torrent!.getValues()
        #expect(torrentDict["createdBy"] as? String == "mktorrent 1.1")
    }

    @Test
    func length() {
        let torrentDict = torrent!.getValues()
        #expect(torrentDict["length"] as? Int == 5_702_520_832)
    }

    @Test
    func name() {
        let torrentDict = torrent!.getValues()
        #expect(torrentDict["name"] as? String == "ubuntu-25.10-desktop-amd64.iso")
    }

    @Test
    func pieceLength() {
        let torrentDict = torrent!.getValues()
        #expect(torrentDict["pieceLength"] as? Int == 262144)
    }

    @Test
    func isPrivate() {
        let torrentDict = torrent!.getValues()
        #expect(torrentDict["private"] as? Bool == false)
    }
}
