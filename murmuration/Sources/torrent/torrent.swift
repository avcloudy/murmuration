import Foundation

public class Torrent {
    public let announce: String
    public let announceList: [String]?
    public let comment: String?
    public let creationDate: Int?
    public let createdBy: String?
    public let length: Int
    public let name: String
    public let pieceLength: Int
    public let pieces: Data
    public let isPrivate: Bool?

    public init?(path: String) {
        // read torrent file
        let url = URL(fileURLWithPath: path)
        let fileData = (try? Data(contentsOf: url)) ?? Data()

        // Decode bencode binary
        guard let decoded = try? decode(data: fileData),
            let dict = try? walker(bencodedObject: decoded) as? [String: Any]
        else {
            return nil
        }

        // Check if dictionary values exist, cast them as the appropriate types, and assign
        if let announceData = dict["announce"] as? Data,
            let announceString = String(data: announceData, encoding: .utf8)
        {
            self.announce = announceString
        } else {
            self.announce = ""
        }

        if let announceListArray = dict["announce-list"] as? [[Data]] {
            self.announceList = announceListArray.compactMap { innerArray in
                innerArray.compactMap { String(data: $0, encoding: .utf8) }.first
            }
        } else {
            self.announceList = nil
        }

        if let commentData = dict["comment"] as? Data {
            self.comment = String(data: commentData, encoding: .utf8)
        } else {
            self.comment = nil
        }

        if let createdByData = dict["Created By"] as? Data {
            self.createdBy = String(data: createdByData, encoding: .utf8)
        } else {
            self.createdBy = nil
        }

        self.creationDate = dict["creation date"] as? Int

        guard let infoDict = dict["info"] as? [String: Any] else { return nil }

        self.length = infoDict["length"] as? Int ?? 0

        if let nameData = infoDict["name"] as? Data {
            self.name = String(data: nameData, encoding: .utf8) ?? ""
        } else {
            self.name = ""
        }

        self.pieceLength = infoDict["piece length"] as? Int ?? 0

        if let piecesData = infoDict["pieces"] as? Data {
            self.pieces = piecesData
        } else {
            self.pieces = Data()
        }
        self.isPrivate = infoDict["private"] as? Bool
    }

    /// Get dictionary of values of torrent file
    /// - Returns: Dictionary.
    /// For debugging and later to be used in encode to create bencoded torrent binary streams
    public func getValues() -> [String: Any] {
        return [
            "announce": announce,
            "announceList": announceList ?? [],
            "comment": comment ?? "",
            "creationDate": creationDate ?? 0,
            "createdBy": createdBy ?? "",
            "length": length,
            "name": name,
            "pieceLength": pieceLength,
            "private": isPrivate ?? false,
        ]
    }
}
