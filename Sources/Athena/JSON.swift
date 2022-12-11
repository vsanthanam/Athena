// Athena
// JSON.swift
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

/// A Swift representation of JSON
@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public enum JSON: Equatable, Hashable, Sendable, CustomStringConvertible, CustomDebugStringConvertible, ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral, ExpressibleByBooleanLiteral, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, ExpressibleByStringLiteral, ExpressibleByNilLiteral {

    // MARK: - Initializers

    /// Initialize a ``JSON`` from a ``JSONEncodable`` conforming Swift type
    /// - Parameter value: The conforming type
    public init<T>(_ value: T) where T: JSONEncodable {
        self = value.toJSON()
    }

    /// Initialize a ``JSON`` from a ``JSONEncodable`` conforming Swift type, asynchronously
    /// - Parameter value: The conforming type
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public init<T>(_ value: T) async where T: JSONEncodable {
        self = await Task { value.toJSON() }.value
    }

    /// Initialize a ``JSON`` from a ``JSONEncodable`` conforming Swift type
    /// - Parameter value: The conforming type
    public init<T>(_ value: T?) where T: JSONDecodable {
        guard let value else {
            self = nil
            return
        }
        self = .init(value)
    }

    /// Initialize a ``JSON`` from an optional ``JSONEncodable`` conforming Swift type, asynchronously
    /// - Parameter value: The conforming type
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public init<T>(_ value: T?) async where T: JSONDecodable {
        guard let value else {
            self = nil
            return
        }
        self = await .init(value)
    }

    /// Initialize a ``JSON`` from a UTF8 encoded string
    /// - Parameter data: The data containing the string
    /// - Throws: A `JSON.Error`, if the data was malformed.
    public init(data: Data) throws {
        self = try Parser.parse(data)
    }

    /// Initialize a ``JSON`` from a UTF8 encoded string, asynchronously
    /// - Parameter data: The data containing the string
    /// - Throws: A `JSON.Error`, if the data was malformed.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public init(data: Data) async throws {
        self = try await Parser.parse(data)
    }

    /// Initialize a ``JSON`` using a Swift string
    /// - Parameter jsonString: The string
    /// - Throws: A `JSON.Error` if the string was malformed.
    public init(jsonString: String) throws {
        self = try Parser.parse(jsonString)
    }

    /// Initialize a ``JSON`` from a UTF8 encoded string, asynchronously
    /// - Parameter data: The data containing the string
    /// - Throws: A `JSON.Error`, if the data was malformed.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public init(jsonString: String) async throws {
        self = try await Parser.parse(jsonString)
    }

    // MARK: - Cases

    /// A JSON boolean
    case bool(Bool)

    /// A JSON integer
    case int(Int)

    /// A JSON float
    case double(Double)

    /// A JSON string
    case string(String)

    /// A null JSON value
    case null

    /// A JSON array
    case array([JSON])

    /// A JSON object
    case object([String: JSON])

    // MARK: - API

    /// Get the value as a `Bool`
    /// - Throws: a `JSON.Error`, if this JSON represents a type other than a bool
    public var boolValue: Bool {
        get throws {
            guard case let .bool(bool) = self else {
                throw Error("The value is not a bool", .casting)
            }
            return bool
        }
    }

    /// Get the value as a `Int`
    /// - Throws: a `JSON.Error`, if this JSON represents a type other than an integer
    public var intValue: Int {
        get throws {
            guard case let .int(int) = self else {
                throw Error("The value is not an int", .casting)
            }
            return int
        }
    }

    /// Get the value as a `Double`
    /// - Throws: a `JSON.Error`, if this JSON represents a type other than a double
    public var doubleValue: Double {
        get throws {
            guard case let .double(double) = self else {
                throw Error("The value is not a double", .casting)
            }
            return double
        }
    }

    /// Get the value as a `String`
    /// - Throws: a `JSON.Error`, if this JSON represents a type other than a string
    public var stringValue: String {
        get throws {
            guard case let .string(string) = self else {
                throw Error("The value is not a string", .casting)
            }
            return string
        }
    }

    /// Get the value as an array
    /// - Throws: a `JSON.Error`, if this JSON represents a type other than an array
    public var arrayValue: [JSON] {
        get throws {
            guard case let .array(array) = self else {
                throw Error("The value is not an array", .casting)
            }
            return array
        }
    }

    /// Get the value as a dictionary
    /// - Throws: a `JSON.Error`, if this JSON represents a type other than an object
    public var dictionaryValue: [String: JSON] {
        get throws {
            guard case let .object(dictionary) = self else {
                throw Error("The value is not a dictionary", .casting)
            }
            return dictionary
        }
    }

    /// Retrive the value at the provide subscript
    /// - Parameter subscript: The subscript
    /// - Returns: The value at the path
    /// - Throws: A `JSON.Error` if no such value exists
    public func value<T>(for subscript: T) throws -> JSON where T: JSONSubscript {
        switch self {
        case let .array(array):
            return try `subscript`.value(in: array)
        case let .object(dictionary):
            return try `subscript`.value(in: dictionary)
        case .null, .int, .double, .string, .bool:
            throw JSON.Error("JSON element \(self) is not subscriptable using subscript \(`subscript`)", .subscript)
        }
    }

    /// Retrieve the value at the provided path
    /// - Parameter path: The path
    /// - Returns: The value at the path
    /// - Throws: A `JSON.Error` if no such value exists
    public func value(at path: any JSONSubscript ...) throws -> JSON {
        try value(at: path)
    }

    /// Retrieve the value at the provided path
    /// - Parameter path: The path
    /// - Returns: The value at the path
    /// - Throws: A `JSON.Error` if no such value exists
    public func value(at path: [any JSONSubscript]) throws -> JSON {
        guard let `subscript` = path.first else {
            return self
        }
        return try value(for: `subscript`).value(at: Array(path.dropFirst()))
    }

    /// Decode the value into a ``JSONDecodable`` Swift type
    /// - Parameter type: The type you wish to decode into
    /// - Returns: The decoded `JSON`
    /// - Throws: A `JSON.Error` if no such path exists, or if the value at the provided path cannot be decoded successfully
    public func decode<T>(type: T.Type = T.self) throws -> T where T: JSONDecodable {
        try .init(json: self)
    }

    /// Decode the value into a ``JSONDecodable`` Swift type, asynchronously
    /// - Parameter type: The type you wish to decode into
    /// - Returns: The decoded `JSON`
    /// - Throws: A `JSON.Error` if no such path exists, or if the value at the provided path cannot be decoded successfully
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public func decode<T>(type: T.Type = T.self) async throws -> T where T: JSONDecodable {
        try await Task { try .init(json: self) }.value
    }

    /// Decode the value into a ``JSONDecodable`` Swift type at a provided path
    /// - Parameters:
    ///   - type: The type you wish to decode into
    ///   - path: The path you wish to traverse before decoding
    /// - Returns: The decoded `JSON` at the provided path
    /// - Throws: A `JSON.Error` if no such path exists, or if the value at the provided path cannot be decoded successfully
    public func decode<T>(
        type: T.Type = T.self,
        at path: any JSONSubscript...
    ) throws -> T where T: JSONDecodable {
        try decode(at: path)
    }

    /// Decode the value into a ``JSONDecodable`` Swift type at a provided path, asynchronously
    /// - Parameters:
    ///   - type: The type you wish to decode into
    ///   - path: The path you wish to traverse before decoding
    /// - Returns: The decoded `JSON` at the provided path
    /// - Throws: A `JSON.Error` if no such path exists, or if the value at the provided path cannot be decoded successfully
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public func decode<T>(
        type: T.Type = T.self,
        at path: any JSONSubscript...
    ) async throws -> T where T: JSONDecodable {
        try await decode(at: path)
    }

    /// Decode the value into a ``JSONDecodable`` Swift type at a provided path
    /// - Parameters:
    ///   - type: The type you wish to decode into
    ///   - path: The path you wish to traverse before decoding
    /// - Returns: The decoded `JSON` at the provided path
    /// - Throws: A `JSON.Error` if no such path exists, or if the value at the provided path cannot be decoded successfully
    public func decode<T>(
        type: T.Type = T.self,
        at path: [any JSONSubscript]
    ) throws -> T where T: JSONDecodable {
        let json = try value(at: path)
        return try T(json: json)
    }

    /// Decode the value into a ``JSONDecodable`` Swift type at a provided path, asynchronously
    /// - Parameters:
    ///   - type: The type you wish to decode into
    ///   - path: The path you wish to traverse before decoding
    /// - Returns: The decoded `JSON` at the provided path
    /// - Throws: A `JSON.Error` if no such path exists, or if the value at the provided path cannot be decoded successfully
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public func decode<T>(
        type: T.Type = T.self,
        at path: [any JSONSubscript]
    ) async throws -> T where T: JSONDecodable {
        let task = Task {
            let json = try value(at: path)
            return try T(json: json)
        }
        return try await task.value
    }

    /// Serialize the value into a UTF8 encoded string
    /// - Parameter options: Options to when creating the string
    /// - Returns: The `Data` representing the string.
    /// - Throws: A `JSON.Error` if the value cannot be serialized
    public func serialize(options: SerializationOptions = .default) throws -> Data {
        func buildNSObject(_ json: JSON = self, using options: JSON.SerializationOptions) -> Any {
            switch json {
            case let .array(array):
                return array.map { json in buildNSObject(json, using: options) }
            case let .object(dictionary):
                var cocoa = [String: Any](minimumCapacity: dictionary.count)
                for (key, json) in dictionary {
                    if json != nil || (json == nil && !options.contains(.nullSkipsKey)) {
                        cocoa[key] = buildNSObject(json, using: options)
                    }
                }
                return cocoa
            case let .string(string):
                return string
            case let .double(double):
                return NSNumber(value: double)
            case let .int(int):
                return NSNumber(value: int)
            case let .bool(bool):
                return NSNumber(value: bool)
            case .null:
                return NSNull()
            }
        }

        let serializable = buildNSObject(using: options)
        return try JSONSerialization.data(withJSONObject: serializable, options: options.writingOptions)
    }

    /// Serialize the value into a UTF8 encoded string, asynchronously
    /// - Parameter options: Options to when creating the string
    /// - Returns: The `Data` representing the string.
    /// - Throws: A `JSON.Error` if the value cannot be serialized
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public func serialize(options: SerializationOptions = .default) async throws -> Data {
        try await Task { try serialize(options: options) }.value
    }

    /// Serialize the value into a Swift string
    /// - Parameter options: Options to when creating the string
    /// - Returns: The `Data` representing the string.
    /// - Throws: A `JSON.Error` if the value cannot be serialized
    public func stringify(options: SerializationOptions = .default) throws -> String {
        let data = try serialize(options: options)
        guard let string = String(data: data, encoding: .utf8) else {
            throw Error("Couldn't serialized data into a UTF8 encoded string")
        }
        return string
    }

    /// Serialize the value into a Swift string, asynchronously
    /// - Parameter options: Options to when creating the string
    /// - Returns: The `Data` representing the string.
    /// - Throws: A `JSON.Error` if the value cannot be serialized
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public func stringify(options: SerializationOptions = .default) async throws -> String {
        let data = try await serialize(options: options)
        guard let string = String(data: data, encoding: .utf8) else {
            throw Error("Couldn't serialized data into a UTF8 encoded string")
        }
        return string
    }

    // MARK: - Subscripting

    public subscript<T>(_ subscript: T) -> JSON where T: JSONSubscript {
        (try? value(for: `subscript`)) ?? nil
    }

    public subscript<T, Subscript>(_ subscript: Subscript) -> T? where T: JSONDecodable, Subscript: JSONSubscript {
        try? decode(at: `subscript`)
    }

    public subscript(_ path: any JSONSubscript ...) -> JSON {
        (try? value(at: path)) ?? nil
    }

    public subscript<T>(_ path: any JSONSubscript ...) -> T? where T: JSONDecodable {
        try? decode(at: path)
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        switch self {
        case let .bool(bool):
            return bool.description
        case let .int(int):
            return int.description
        case let .double(double):
            return double.description
        case let .string(string):
            return string.description
        case let .array(array):
            return array.description
        case let .object(dictionary):
            return dictionary.description
        case .null:
            return "null"
        }
    }

    // MARK: - CustomDebugStringConvertible

    public var debugDescription: String {
        toPrettyString()
    }

    // MARK: - ExpressibleByArrayLiteral

    public typealias ArrayLiteralElement = JSON

    public init(arrayLiteral elements: JSON...) {
        self = .array(elements)
    }

    // MARK: - ExpressibleByDictionaryLiteral

    public typealias Key = String

    public typealias Value = JSON

    public init(dictionaryLiteral elements: (Key, Value)...) {
        self = .object(elements.reduce([:]) { dict, pair in
            var next = dict
            let (key, value) = pair
            next[key] = value
            return next
        })
    }

    // MARK: - ExpressibleByBooleanLiteral

    public typealias BooleanLiteralType = Bool

    public init(booleanLiteral value: Bool) {
        self = .bool(value)
    }

    // MARK: - ExpressibleByIntegerLiteral

    public typealias IntegerLiteralType = Int

    public init(integerLiteral value: Int) {
        self = .int(value)
    }

    // MARK: - ExpressibleByFloatLiteral

    public typealias FloatLiteralType = Double

    public init(floatLiteral value: Double) {
        self = .double(value)
    }

    // MARK: - ExpressibleByStringLiteral

    public typealias StringLiteralType = String

    public init(stringLiteral value: String) {
        self = .string(value)
    }

    // MARK: - ExpressibleByNilLiteral

    public init(nilLiteral: Void) {
        self = .null
    }

    // MARK: - Private

    private func toEscapedString() -> String {
        switch self {
        case let .array(array):
            return "["
                + array
                .map { json in json.toEscapedString() }
                .joined(separator: ",")
                + "]"
        case let .object(dictionary):
            return "{"
                + dictionary
                .enumerated()
                .map(\.element)
                .map { pair in
                    let (key, value) = pair
                    return [
                        key,
                        value.toEscapedString()
                    ]
                    .joined(separator: ":")
                }
                .joined(separator: ",")
                + "}"
        case let .bool(bool):
            return bool ? "true" : "false"
        case let .int(int):
            return int.description
        case let .double(double):
            return double.description
        case let .string(string):
            return "\"" + string + "\""
        case .null:
            return "null"
        }
    }

    private func toPrettyString(tabs: Int = 0) -> String {
        let tabString = Array(0 ..< tabs)
            .reduce("") { prev, _ in
                prev + "\t"
            }
        switch self {
        case let .array(array):
            return "["
                + array
                .map { json in json.toPrettyString(tabs: tabs) }
                .joined(separator: ", ")
                + "]"
        case let .object(dictionary):
            return "{\n"
                + dictionary
                .enumerated()
                .map(\.element)
                .map { pair in
                    let (key, value) = pair
                    let kvp = [
                        key.tabbedString(tabs: tabs + 1),
                        value.toPrettyString(tabs: tabs + 1)
                    ]
                    .joined(separator: ": ")
                    return tabString + kvp
                }
                .joined(separator: ",\n")
                + "\n"
                + tabString.dropFirst()
                + "}"
        case let .bool(bool):
            return bool ? "true" : "false"
        case let .int(int):
            return int.description
        case let .double(double):
            return double.description
        case let .string(string):
            return "\"" + string + "\""
        case .null:
            return "null"
        }
    }
}
