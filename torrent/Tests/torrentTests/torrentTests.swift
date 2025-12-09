import Testing

@testable import torrent

class BencodeDecodeTests {
  @Test func decodeString() {
    let bencodedString = "17:This is a string!4:eggs"
    let decoded = try? decode(data: bencodedString)
    guard case .string(let value) = decoded else { fatalError("Expected a string") }
    #expect(value == "This is a string!")
  }
  @Test func decodeStringEndEarly() {
    let bencodedString = "16:This is a string!4:eggs"
    let decoded = try? decode(data: bencodedString)
    guard case .string(let value) = decoded else { fatalError("Expected a string") }
    #expect(value == "This is a string")
  }
  @Test func decodeInt() {
    let bencodedInt = "i14e"
    let decoded = try? decode(data: bencodedInt)
    guard case .int(let value) = decoded else { fatalError("Expected an Int") }
    #expect(value == 14)
  }
  @Test func decodeList() {
    let bencodedList = "ll5:green4:eggs3:and3:hamel6:second4:list4:testee"
    let decoded = try? decode(data: bencodedList)
    guard case .list(let value) = decoded else { fatalError("Expected a list") }
    #expect(
      value == [
        .list([.string("green"), .string("eggs"), .string("and"), .string("ham")]),
        .list([.string("second"), .string("list"), .string("test")]),
      ])
  }
  @Test func decodeListEmpty() {
    let bencodedList = "le"
    let decoded = try? decode(data: bencodedList)
    guard case .list(let value) = decoded else { fatalError("Expected a list") }
    #expect(value == [])
  }
  @Test func decodeDeepRecursion() {
    let bencodedList = "lllll4:deep9:primitive9:recursioneeeee"
    let decoded = try? decode(data: bencodedList)
    guard case .list(let value) = decoded else { fatalError("Expected a list") }
    #expect(
      value == [
        .list([
          .list([.list([.list([.string("deep"), .string("primitive"), .string("recursion")])])])
        ])
      ])
  }
  @Test func decodeDict() {
    let bencodedDict = "d4:spam4:eggs5:monty4:hall4:fuck6:horsese"
    let decoded = try? decode(data: bencodedDict)
    guard case .dict(let value) = decoded else { fatalError("Expected a dictionary") }
    #expect(
      value == [
        .string("spam"): .string("eggs"), .string("monty"): .string("hall"),
        .string("fuck"): .string("horses"),
      ])
  }
  @Test func decodeDictEmpty() {
    let bencodedDict = "de"
    let decoded = try? decode(data: bencodedDict)
    guard case .dict(let value) = decoded else { fatalError("Expected a dictionary") }
    #expect(value == [:])
  }
}

class BencodeEncodeTests {
  @Test func encodeString() {
    let testString = "This is a string!"
    guard let encodedString = try? encode(data: testString) else {
      fatalError("How have you fucked up a string.")
    }
    #expect(encodedString == "17:This is a string!")
  }
  @Test func encodeInt() {
    let testInt = 42
    guard let encodedInt = try? encode(data: testInt) else {
      fatalError("How have you fucked up an int.")
    }
    #expect(encodedInt == "i42e")
  }
  @Test func encodeList() {
    let testList: [Any] = ["surface", "level", "list", ["nested", "list"]]
    guard let encodedList = try? encode(data: testList) else {
      fatalError("Yeah okay this one is reasonable though")
    }
    #expect(encodedList == "l7:surface5:level4:listl6:nested4:listee")
  }
  // TODO: dictionary encoder has to be sorted - keys ordered alphabetically in the bencode result
  @Test func encodeDict() {
    let testDict: [String: Any] = ["surface": "dictionary", "nested": ["dictionary": "here"]]
    guard let encodedDict = try? encode(data: testDict) else {
      fatalError("I would be more surprised if this actually worked first try")
    }
    #expect(encodedDict == "d7:surface10:dictionary6:nestedd10:dictionary4:hereee")
  }
}
// d6:nestedd10:dictionary4:heree7:surface10:dictionarye
// this is the sorted dictionary that the above function should return
