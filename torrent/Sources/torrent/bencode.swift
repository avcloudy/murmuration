import Foundation

public enum bencode: Hashable {
    case string(String)
    case int(Int)
    // MARK: Later implementation of raw byte stream
//    case bytes(Data)
    indirect case list([bencode])
    indirect case dict([bencode: bencode])
}
