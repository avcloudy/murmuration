import Foundation

public enum bencode: Hashable {
    case string(Data)
    case int(Int)
    indirect case list([bencode])
    indirect case dict([bencode: bencode])

    // trying to create an automatic unwrapper
    // but i think the best way is really to initialise a struct (a Torrent)
    // and just use that.
    public func unwrap<T>() -> T? {
        switch self {
        case .string(let data):
            if T.self == Data.self { return data as? T }
            if T.self == String.self { return String(data: data, encoding: .utf8) as? T }

        case .int(let value):
            return value as? T

        case .list(let items):
            // Recursive unwrap
            if let elementType = (T.self as? AnyArray.Type)?.elementType {
                let mapped: [Any] = items.compactMap { $0.unwrapAny(as: elementType) }
                return mapped as? T
            }

        case .dict(let dict):
            // Dict keys are .string
            var nativeDict = [String: Any]()
            if let valueType = (T.self as? AnyDictionary.Type)?.valueType {

                for (key, value) in dict {
                    if case .string(let keyData) = key,
                        let keyString = String(data: keyData, encoding: .utf8),
                        let unwrappedValue = value.unwrapAny(as: valueType)
                    {
                        nativeDict[keyString] = unwrappedValue
                    }
                }
                return nativeDict as? T
            }
        }
        return nil
    }

    // use public generic function and try to use private helper
    // to sweep Any? under rug
    // it works great for strings and ints, but the dict and list recursive cases are just not possible
    // esp because while torrents are well formed, the specification is not, and an array of multiple types
    // is explicitly possible
    private func unwrapAny(as type: Any.Type) -> Any? {
        switch self {
        case .string(let data):
            return (type == String.self) ? String(data: data, encoding: .utf8) : data
        case .int(let value): return value
        case .list(let items):
            return items.compactMap {
                $0.unwrapAny(as: (type as? AnyArray.Type)?.elementType ?? Any.self)
            }
        case .dict(let dict):
            var d = [String: Any]()
            let innerType = (type as? AnyDictionary.Type)?.valueType ?? Any.self
            for (k, v) in dict {
                if case .string(let kd) = k, let ks = String(data: kd, encoding: .utf8) {
                    d[ks] = v.unwrapAny(as: innerType)
                }
            }
            return d
        }
    }
}

private protocol AnyArray { static var elementType: Any.Type { get } }
extension Array: AnyArray { static var elementType: Any.Type { Element.self } }
private protocol AnyDictionary { static var valueType: Any.Type { get } }
extension Dictionary: AnyDictionary { static var valueType: Any.Type { Value.self } }
