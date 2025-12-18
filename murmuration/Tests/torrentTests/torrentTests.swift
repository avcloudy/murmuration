import Foundation
import Testing

@testable import torrent

class TorrentReadTests {

    // bundling resources within Swift because it's hard to get a good relative path
    // to resources otherwise
    // TorrentResources is declared in torrent.swift
    // torrents exist in torrent/Resources/
    func getTorrent() -> String {
        guard
            let torrentURL = TorrentResources.bundle.url(
                forResource: "ubuntu-25.10-desktop-amd64.iso",
                withExtension: "torrent",
                subdirectory: "Resources")
        else {
            return ""
        }
        return torrentURL.path
    }

    @Test
    func announceName() {
        let torrent = Torrent(path: getTorrent())
        let torrentDict = torrent!.getValues()
        #expect(torrentDict["announce"] as? String == "https://torrent.ubuntu.com/announce")
    }

    @Test
    func announceList() {
        let torrent = Torrent(path: getTorrent())
        let torrentDict = torrent!.getValues()
        #expect(
            torrentDict["announceList"] as? [String] == [
                "https://torrent.ubuntu.com/announce", "https://ipv6.torrent.ubuntu.com/announce",
            ])
    }

    @Test
    func comment() {
        let torrent = Torrent(path: getTorrent())
        let torrentDict = torrent!.getValues()
        #expect(torrentDict["comment"] as? String == "Ubuntu CD releases.ubuntu.com")
    }

    @Test
    func creationDate() {
        let torrent = Torrent(path: getTorrent())
        let torrentDict = torrent!.getValues()
        #expect(torrentDict["creationDate"] as? Int == 1_759_993_240)
    }

    @Test
    func createdBy() {
        let torrent = Torrent(path: getTorrent())
        let torrentDict = torrent!.getValues()
        #expect(torrentDict["createdBy"] as? String == "mktorrent 1.1")
    }

    @Test
    func length() {
        let torrent = Torrent(path: getTorrent())
        let torrentDict = torrent!.getValues()
        #expect(torrentDict["length"] as? Int == 5_702_520_832)
    }

    @Test
    func name() {
        let torrent = Torrent(path: getTorrent())
        let torrentDict = torrent!.getValues()
        #expect(torrentDict["name"] as? String == "ubuntu-25.10-desktop-amd64.iso")
    }

    @Test
    func pieceLength() {
        let torrent = Torrent(path: getTorrent())
        let torrentDict = torrent!.getValues()
        #expect(torrentDict["pieceLength"] as? Int == 262144)
    }

    @Test
    func isPrivate() {
        let torrent = Torrent(path: getTorrent())
        let torrentDict = torrent!.getValues()
        #expect(torrentDict["private"] as? Bool == false)
    }
}

class TorrentEncodeTest {

    func getTorrent() -> String {
        guard
            let torrentURL = TorrentResources.bundle.url(
                forResource: "lots-of-numbers",
                withExtension: "torrent",
                subdirectory: "Resources")
        else {
            return ""
        }
        return torrentURL.path
    }

    func getFile() -> URL {
        guard
            let torrentURL = TorrentResources.bundle.url(
                forResource: "lots-of-numbers",
                withExtension: "torrent",
                subdirectory: "Resources")
        else {
            return URL(string: "")!
        }
        return torrentURL
    }

    @Test
    func OutputEquivalentToInput() throws {
        let torrent = Torrent(path: getTorrent())
        let rawDict = torrent?.getOptionalValues()
        let bencodeComp = try encode(data: rawDict!)
        let torrentFileData = try Data(contentsOf: getFile())
        #expect(bencodeComp == torrentFileData)
    }
}

class MultiFileTorrents {
    class LotsOfNumbersTorrent {
        // testing im actually getting the correct values out of the test torrents of course, but side benefit is that im
        // figuring out how to usefully extract the damn values
        func getTorrent() -> String {
            guard
                let torrentURL = TorrentResources.bundle.url(
                    forResource: "lots-of-numbers",
                    withExtension: "torrent",
                    subdirectory: "Resources")
            else {
                return ""
            }
            return torrentURL.path
        }

        @Test
        func creationDate() {
            let torrent = Torrent(path: getTorrent())
            let torrentDict = torrent!.getValues()
            #expect(torrentDict["creationDate"] as? Int == 1_458_348_895_130)
        }

        @Test
        func encoding() {
            let torrent = Torrent(path: getTorrent())
            let torrentDict = torrent!.getValues()
            #expect(torrentDict["encoding"] as? String == "UTF-8")
        }

        @Test
        func name() {
            let torrent = Torrent(path: getTorrent())
            let torrentDict = torrent!.getValues()
            #expect(torrentDict["name"] as? String == "lots-of-numbers")
        }

        @Test
        func filesnames() {
            let torrent = Torrent(path: getTorrent())
            let torrentDict = torrent?.getValues()["files"] as? [[String: Any]]
            let firstlist = (torrentDict?[0])
            let firstpath = firstlist?["path"] as? [String]
            #expect(firstpath == ["big numbers", "10.txt"])
        }

    }

}
