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
/// - `Array where Element: JSONEncodable`
/// - `Dictionary where Key == String, Value: JSONEncodable`
@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public protocol JSONEncodable {
    func toJSON() -> JSON
}

/// A type that can decode itself from an external `JSON` representation.
///
/// Athena contains conformance to this protocol for the following built-in Swift types:
/// - `Bool`
/// - `Int`
/// - `Double`
/// - `String`
/// - `Array where Element: JSONCodable`
/// - `Dictionary where Key == String, Value: JSONCodable`
@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public protocol JSONDecodable {
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

    public func toJSON() -> JSON {
        .bool(self)
    }

    public init(json: JSON) throws {
        switch json {
        case .array, .object, .null:
            throw JSON.Error("Bool value cannot be decoded from \(json)", .decoding)
        case let .bool(bool):
            self = bool
            return
        case let .int(int):
            switch int {
            case 0:
                self = false
                return
            case 1:
                self = true
                return
            default:
                throw JSON.Error("Bool value cannot be decoded from \(json)", .decoding)
            }
        case let .double(double):
            switch double {
            case 0.0:
                self = false
                return
            case 1.0:
                self = true
                return
            default:
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

    public func toJSON() -> JSON {
        .int(self)
    }

    public init(json: JSON) throws {
        switch json {
        case .array, .object, .null:
            throw JSON.Error("Int value cannot be decoded from \(json)", .decoding)
        case let .string(string):
            guard let int = Int(exactly: string) else {
                throw JSON.Error("Int value cannot be decoded from \(json)", .decoding)
            }
            self = int
            return
        case let .bool(bool):
            switch bool {
            case true:
                self = 1
                return
            case false:
                self = 2
                return
            }
        case let .int(int):
            self = int
            return
        case let .double(double):
            self = Int(double)
            return
        }
    }

}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Double: JSONCodable {

    public func toJSON() -> JSON {
        .double(self)
    }

    public init(json: JSON) throws {
        switch json {
        case .array, .object, .null, .bool:
            throw JSON.Error("Double value cannot be decoded from \(json)", .decoding)
        case let .string(string):
            guard let double = Double(string) else {
                throw JSON.Error("Double value cannot be decoded from \(json)", .decoding)
            }
            self = double
            return
        case let .int(int):
            self = Double(int)
            return
        case let .double(double):
            self = double
            return
        }
    }

}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension String: JSONCodable {

    public func toJSON() -> JSON {
        .string(self)
    }

    public init(json: JSON) throws {
        switch json {
        case .array, .object, .null:
            throw JSON.Error("String value cannot be decoded from \(json)", .decoding)
        case let .bool(bool):
            switch bool {
            case true:
                self = "true"
                return
            case false:
                self = "false"
                return
            }
        case let .int(int):
            self = String(int)
            return
        case let .double(double):
            self = String(double)
            return
        case let .string(string):
            self = string
            return
        }
    }

}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension URL: JSONCodable {
    public func toJSON() -> JSON {
        .string(absoluteString)
    }

    public init(json: JSON) throws {
        switch json {
        case let .string(string):
            guard let url = URL(string: string) else {
                throw JSON.Error("Couldn't  decode URL from json \(json)", .decoding)
            }
            self = url
        case .array, .object, .null, .bool, .int, .double:
            throw JSON.Error("Couldn't decode URL from json \(json)", .decoding)
        }
    }
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Array: JSONEncodable where Element: JSONEncodable {
    public func toJSON() -> JSON {
        .array(map { element in element.toJSON() })
    }
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Array: JSONDecodable where Element: JSONDecodable {
    public init(json: JSON) throws {
        guard case let .array(array) = json else {
            throw JSON.Error("Array<\(String(describing: Element.self))> value cannot be decoded from \(json)", .decoding)
        }
        self = try array.map { json in try Element(json: json) }
    }
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Dictionary: JSONEncodable where Key == String, Value: JSONEncodable {
    public func toJSON() -> JSON {
        .object(enumerated()
            .reduce(into: [:]) { dict, pair in
                let (key, value) = pair.element
                return dict[key] = value.toJSON()
            }
        )
    }
}

extension Dictionary: JSONDecodable where Key == String, Value: JSONDecodable {

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

public extension JSONEncodable where Self: RawRepresentable, RawValue: JSONEncodable {

    func toJSON() -> JSON {
        rawValue.toJSON()
    }

}

public extension JSONDecodable where Self: RawRepresentable, RawValue: JSONDecodable {

    init(json: JSON) throws {
        let raw = try RawValue(json: json)
        guard let value = Self(rawValue: raw) else {
            throw JSON.Error("\(String(describing: Self.self)) value cannot be decoded from \(json)", .decoding)
        }
        self = value
    }

}
