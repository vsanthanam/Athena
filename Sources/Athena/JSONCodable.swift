// Athena
// JSONCodable.swift
//
// MIT License
//
// Copyright (c) 2022 Varun Santhanam
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the  Software), to deal
//
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

/// A type that can encode itself to an external `JSON` representation.
///
/// Athena contains conformance to this protocol for the following built-in Swift types:
/// - `Bool`
/// - `Int`
/// - `Double`
/// - `String`
/// - `URL`
/// - `UUID`
/// - `Array where Element: JSONEncodable`
/// - `Set where Element: JSONEncodable`
/// - `Dictionary where Key == String, Value: JSONEncodable`
/// - `Optional where Wrapped: JSONEncodable`
@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public protocol JSONEncodable {

    /// Produce a representation of the instance in ``JSON``
    ///
    /// This method should be used to produce a ``JSON`` representation of the type, suitable for recreating an equivelent instance using the produced value.
    ///
    /// For more information on how this method might be implemented, see <doc:EncodingDecoding>.
    /// - Returns: The ``JSON`` representing this instance
    func toJSON() -> JSON
}

/// A type that can decode itself from an external `JSON` representation.
///
/// Athena contains conformance to this protocol for the following built-in Swift types:
/// - `Bool`
/// - `Int`
/// - `Double`
/// - `String`
/// - `URL`
/// - `UUID`
/// - `Array where Element: JSONDecodable`
/// - `Set where Element: JSONDecodable`
/// - `Dictionary where Key == String, Value: JSONDecodable`
/// - `Optional where Wrapped: JSONDecodable`
@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public protocol JSONDecodable {

    /// Initialize an instance using a ``JSON`` value
    ///
    /// This initializer should be used to produce an instance based on the provided ``JSON``.
    /// If the provided ``JSON`` is shaped incorrectly or missing data necessary to initialize an instance, it should throw an error.
    ///
    /// For more information on how this initializer might be implemented, see <doc:EncodingDecoding>.
    /// - Parameter json: The ``JSON`` value to decode into `Self`
    /// - Throws: An error if an instance cannot be decoded from the provided ``JSON``
    init(json: JSON) throws
}

/// A type that can convert itself into and out of an external `JSON` representation.
///
/// `JSONCodable` is a type alias for the `JSONEncodable` and `JSONDecodable` protocols.
///
/// When you use `JSONCodable` as a type or a generic constraint, it matches
/// any type that conforms to both protocols.
@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public typealias JSONCodable = JSONEncodable & JSONDecodable

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Bool: JSONCodable {

    // MARK: - JSONEncodable

    public func toJSON() -> JSON {
        switch self {
        case true:
            return .literal(.true)
        case false:
            return .literal(.false)
        }
    }

    // MARK: - JSONDecodable

    public init(json: JSON) throws {
        switch json {
        case .array, .object:
            throw JSON.Error("Bool value cannot be decoded from \(json)", .decoding)
        case let .number(number):
            do {
                self = try number.decode()
                break
            } catch {
                throw JSON.Error("Bool value cannot be decoded from \(json)", .decoding)
            }
        case let .literal(literal):
            do {
                self = try literal.decode()
                break
            } catch {
                throw JSON.Error("Bool value cannot be decoded from \(json)", .decoding)
            }
        case let .string(string):
            switch string {
            case "false":
                self = false
                return
            case "true":
                self = true
                return
            default:
                throw JSON.Error("Bool value cannot be decoded from \(json)", .decoding)
            }
        }
    }

}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Int: JSONCodable {

    // MARK: - JSONEncodable

    public func toJSON() -> JSON {
        .number(.int(self))
    }

    // MARK: - JSONDecodable

    public init(json: JSON) throws {
        switch json {
        case .array, .object, .literal:
            throw JSON.Error("Int value cannot be decoded from \(json)", .decoding)
        case let .string(string):
            guard let int = Int(exactly: string) else {
                throw JSON.Error("Int value cannot be decoded from \(json)", .decoding)
            }
            self = int
            return
        case let .number(number):
            do {
                self = try number.decode()
                return
            } catch {
                throw JSON.Error("Int value cannot be decoded from \(json)", .decoding)
            }
        }
    }

}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Double: JSONCodable {

    // MARK: - JSONEncodable

    public func toJSON() -> JSON {
        .number(.double(self))
    }

    // MARK: - JSONDecodable

    public init(json: JSON) throws {
        switch json {
        case .array, .object, .literal:
            throw JSON.Error("Double value cannot be decoded from \(json)", .decoding)
        case let .string(string):
            guard let double = Double(string) else {
                throw JSON.Error("Double value cannot be decoded from \(json)", .decoding)
            }
            self = double
        case let .number(number):
            do {
                self = try number.decode()
                break
            } catch {
                throw JSON.Error("Double value cannot be decoded from \(json)", .decoding)
            }
        }
    }

}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension String: JSONCodable {

    // MARK: - JSONEncodable

    public func toJSON() -> JSON {
        .string(self)
    }

    // MARK: - JSONDecodable

    public init(json: JSON) throws {
        switch json {
        case .array, .object, .literal:
            throw JSON.Error("String value cannot be decoded from \(json)", .decoding)
        case let .number(number):
            do {
                self = try number.decode()
                break
            } catch {
                throw JSON.Error("Couldn't decode string from json \(json)", .decoding)
            }
        case let .string(string):
            self = string
        }
    }

}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension URL: JSONCodable {

    // MARK: - JSONEncodable

    public func toJSON() -> JSON {
        .string(absoluteString)
    }

    // MARK: - JSONDecodable

    public init(json: JSON) throws {
        switch json {
        case let .string(string):
            guard let url = URL(string: string) else {
                throw JSON.Error("Couldn't  decode URL from json \(json)", .decoding)
            }
            self = url
        case .array, .object, .number, .literal:
            throw JSON.Error("Couldn't decode URL from json \(json)", .decoding)
        }
    }
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension UUID: JSONCodable {

    // MARK: - JSONEncodable

    public func toJSON() -> JSON {
        uuidString.toJSON()
    }

    // MARK: - JSONDecodable

    public init(json: JSON) throws {
        let uuidString = try json.decode(String.self)
        guard let uuid = UUID(uuidString: uuidString) else {
            throw JSON.Error("Couldn't decode UUID from json \(json)", .decoding)
        }
        self = uuid
    }
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Array: JSONEncodable where Element: JSONEncodable {

    // MARK: - JSONEncodable

    public func toJSON() -> JSON {
        .array(map { element in element.toJSON() })
    }
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Array: JSONDecodable where Element: JSONDecodable {

    // MARK: - JSONDecodable

    public init(json: JSON) throws {
        guard case let .array(array) = json else {
            throw JSON.Error("Array<\(String(describing: Element.self))> value cannot be decoded from \(json)", .decoding)
        }
        self = try array.map { json in try Element(json: json) }
    }
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Set: JSONEncodable where Element: JSONEncodable {

    // MARK: - JSONEncodable

    public func toJSON() -> JSON {
        Array(self).toJSON()
    }

}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Set: JSONDecodable where Element: JSONDecodable {

    // MARK: - JSONDecodable

    public init(json: JSON) throws {
        let array = try json.decode([Element].self)
        self.init(array)
    }
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Dictionary: JSONEncodable where Key == String, Value: JSONEncodable {

    // MARK: - JSONEncodable

    public func toJSON() -> JSON {
        .object(enumerated()
            .reduce(into: [:]) { dict, pair in
                let (key, value) = pair.element
                return dict[key] = value.toJSON()
            }
        )
    }
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Dictionary: JSONDecodable where Key == String, Value: JSONDecodable {

    // MARK: - JSONDecodable

    public init(json: JSON) throws {
        guard case let .object(dictionary) = json else {
            throw JSON.Error("Dictionary<String, \(String(describing: Value.self))> value cannot be decoded from \(json)", .decoding)
        }
        self = try dictionary.reduce([:]) { dict, pair in
            var next = dict
            let (key, value) = pair
            next[key] = try Value(json: value)
            return next
        }
    }

}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public extension JSONEncodable where Self: RawRepresentable, RawValue: JSONEncodable {

    // MARK: - JSONEncodable

    func toJSON() -> JSON {
        rawValue.toJSON()
    }

}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public extension JSONDecodable where Self: RawRepresentable, RawValue: JSONDecodable {

    // MARK: - JSONDecodable

    init(json: JSON) throws {
        let raw = try RawValue(json: json)
        guard let value = Self(rawValue: raw) else {
            throw JSON.Error("\(String(describing: Self.self)) value cannot be decoded from \(json)", .decoding)
        }
        self = value
    }

}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Optional: JSONEncodable where Wrapped: JSONEncodable {

    // MARK: - JSONEncodable

    public func toJSON() -> JSON {
        switch self {
        case .none:
            return nil
        case let .some(wrapped):
            return wrapped.toJSON()
        }
    }
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Optional: JSONDecodable where Wrapped: JSONDecodable {

    // MARK: - JSONDecodable

    public init(json: JSON) throws {
        do {
            let wrapped = try Wrapped(json: json)
            self = .some(wrapped)
        } catch {
            if json == nil {
                self = .none
            } else {
                throw error
            }
        }
    }

}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public extension JSONEncodable where Self: Codable {

    // MARK: - JSONEncodable

    func toJSON() -> JSON {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            return try JSON(data: data)
        } catch {
            assertionFailure("Couldn't properly infer `JSONEncodable` conformance from `Codable` conformance!")
            return nil
        }
    }

}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public extension JSONDecodable where Self: Decodable {

    // MARK: - JSONDecodable

    init(json: JSON) throws {
        let data: Data = try json.serialize()
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }

}
