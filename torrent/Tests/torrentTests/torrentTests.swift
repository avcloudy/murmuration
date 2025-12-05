import Testing
@testable import torrent

class BencodeTests {
    @Test
    func bencodeString() {
        let bencodedString = "17:This is a string!4:eggs"
        let decoded = Bencode(data: bencodedString).decode()
        
        guard case let .string(value) = decoded else {
            fatalError("Expected a string")
        }

        #expect(value == "This is a string!")
    }

    @Test
    func bencodeString2() {
        let bencodedString = "16:This is a string!4:eggs"
        let decoded = Bencode(data: bencodedString).decode()
        
        guard case let .string(value) = decoded else {
            fatalError("Expected a string")
        }

        #expect(value == "This is a string")
    }

    @Test
    func bencodeStringManual() {
        #expect("This is a string!" == "This is a string!")
    }

    @Test
    func bencodeInt() {
        let bencodedInt = "i14e"
        let decoded = Bencode(data: bencodedInt).decode()
        guard case let .int(value) = decoded else {
            fatalError("Expected an Int")
        }
        #expect(value == 14)
    }
    @Test
    func bencodeList() {
        let bencodedList = "ll5:green4:eggs3:and3:hamel6:second4:list4:teste"
        let decoded = Bencode(data: bencodedList).decode()
        guard case let .list(value) = decoded else {
            fatalError("Expected a list")
        }
        #expect(value == [ .list([.string("green"),.string("eggs"),.string("and"),.string("ham")]),
                           .list([.string("second"),.string("list"),.string("test")]) ])
    }
    @Test
    func benchcodeDict() {
        let bencodedDict = "d4:spam4:eggs5:monty4:hall4:fuck6:horsese"
        let decoded = Bencode(data: bencodedDict).decode()
        guard case let .dict(value) = decoded else {
            fatalError("Expected a dictionary")
        }
        #expect(value == [.string("spam"): .string("eggs"),
                          .string("monty"): .string("hall"),
                          .string("fuck"): .string("horses")])
    }
}
