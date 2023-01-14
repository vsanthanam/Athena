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

/// A Swift representation of a JSON object
@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public enum JSON: Equatable, Hashable, Sendable, CustomStringConvertible, CustomDebugStringConvertible, ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral, ExpressibleByBooleanLiteral, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, ExpressibleByStringLiteral, ExpressibleByNilLiteral {

    // MARK: - Factories

    /// A ``JSON`` value containing the number zero.
    public static let zero: JSON = 0

    /// A ``JSON`` value containing `null`
    public static let null: JSON = .literal(.null)

    // MARK: - Initializers

    /// Initialize a ``JSON`` by encoding a ``JSONEncodable`` type
    ///
    /// Use this initializer to create a JSON representation of a ``JSONEncodable`` conforming type. For example:
    ///
    /// ```swift
    /// import Athena
    ///
    /// struct MyType: JSONEncodable { ... }
    ///
    /// let instance = MyType()
    /// let json = JSON(instance)
    /// ```
    ///
    /// For more information, see <doc:EncodingDecoding>
    ///
    /// - Parameter value: The conforming type
    public init<T>(_ value: T) where T: JSONEncodable {
        self = Encoder.encode(value)
    }

    /// Initialize a ``JSON`` by encoding an optional ``JSONEncodable`` type
    ///
    /// Use this initializer to create a JSON representation of an optional ``JSONEncodable`` conforming type.
    /// If the supplied optional is `nil`, the JSON value will contain `null`
    ///
    /// For example:
    ///
    /// ```swift
    /// import Athena
    ///
    /// struct MyType: JSONEncodable { ... }
    ///
    /// let condition: Bool = ...
    ///
    /// let instance: MyType? = condition ? MyType() : nil
    /// let json = JSON(instance)
    /// ```
    ///
    /// For more information, see <doc:EncodingDecoding>
    ///
    /// - Parameter value: The conforming type
    public init<T>(_ value: T?) where T: JSONEncodable {
        guard let value else {
            self = nil
            return
        }
        self = .init(value)
    }

    /// Initialize a ``JSON`` by deserializing a UTF-8 encoded data
    ///
    /// Use this initializer if you want to create a ``JSON`` value by deserializing UTF-8 encoded `Data`. For example:
    ///
    /// ```swift
    /// import Athena
    ///
    /// let data = Data( ... )
    /// let json = try Json(data: data)
    /// ```
    ///
    /// For more information, see <doc:Deserializing>
    ///
    /// - Parameter data: The data
    /// - Throws: A ``JSON/Error``, if the data was malformed.
    public init(data: Data) throws {
        self = try Deserializer.deserialize(data)
    }

    /// Initialize a ``JSON`` by deserializing a formatted JSON string
    ///
    /// Use this initializer if you want to create a ``JSON`` value by deserializing a properly formatted JSON string. For example:
    ///
    /// ```swift
    /// import Athena
    ///
    /// let string = "{\"key\": \"value\"}"
    /// let json = try JSON(jsonString: string)
    /// ```
    ///
    /// For more information, see <doc:Deserializing>
    ///
    /// - Parameter jsonString: The string parse into ``JSON``
    /// - Throws: A ``JSON/Error`` if the string was malformed.
    public init(jsonString: String) throws {
        self = try Deserializer.deserialize(jsonString)
    }

    /// Initialize a ``JSON`` from a `Bool`
    ///
    /// Use this initializer to create a ``JSON`` value from a `Bool`. For example:
    ///
    /// ```swift
    /// import Athena
    ///
    /// let bool = true
    /// let json = JSON(bool)
    /// ```
    ///
    /// - Parameter bool: The boolean value
    public init(_ bool: Bool) {
        self = .literal(.init(bool))
    }

    /// Initialize a ``JSON`` from an optional `Bool`
    ///
    /// Use this initializer to create a ``JSON`` value from an optional `Bool`.
    /// If the supplied optional is `nil`, the initializer JSON value will contain `null`
    ///
    /// For exmaple:
    ///
    /// ```swift
    /// import Athena
    ///
    /// let condition: Bool = ...
    ///
    /// let bool: Bool? = condition ? true : nil
    /// let json = JSON(bool)
    /// ```
    ///
    /// - Parameter bool: The optional boolean value
    public init(_ bool: Bool?) {
        self = bool.map(JSON.init(_:)) ?? nil
    }

    /// Initialize a ``JSON`` from an `Int`
    ///
    /// Use this initializer to create a ``JSON`` value from an `Int`. For example:
    ///
    /// ```swift
    /// import Athena
    ///
    /// let int = 12
    /// let json = JSON(int)
    /// ```
    ///
    /// - Parameter int: The integer value
    public init(_ int: Int) {
        self = .number(.init(int))
    }

    /// Initialize a ``JSON`` from an optional `Int`
    ///
    /// Use this initializer to create a ``JSON`` value from an optional `Int`.
    /// If the supplied optional is `nil`, the initialized JSON value will contain `null`
    ///
    /// For example:
    ///
    /// ```swift
    /// import Athena
    ///
    /// let condition: Bool = ...
    ///
    /// let int: Int? = condition : 12 : nil
    /// let json = JSON(int)
    /// ```
    ///
    /// - Parameter int: The optional integer value
    public init(_ int: Int?) {
        self = int.map(JSON.init(_:)) ?? nil
    }

    /// Initialize a ``JSON`` from a `Double`
    ///
    /// Use this initializer to create a ``JSON`` value from a `Double`. For example:
    ///
    /// ```swift
    /// import Athena
    ///
    /// let double = 4.2
    /// let json = JSON(double)
    /// ```
    ///
    /// - Parameter double: The double value
    public init(_ double: Double) {
        self = .number(.init(double))
    }

    /// Initialize a ``JSON`` from an optional `Double`
    ///
    /// Use this initializer to create a ``JSON`` value from an optional `Double`.
    /// If the supplied optional is `nil`, the initialized JSON value will contain `null`.
    ///
    /// For example:
    ///
    /// ```
    /// import Athena
    ///
    /// let condition: Bool = ...
    ///
    /// let double: Double? = condition ? 4.2 : nil
    /// let json = JSON(double)
    /// ```
    ///
    /// - Parameter double: The optional double value
    public init(_ double: Double?) {
        self = double.map(JSON.init(_:)) ?? nil
    }

    /// Initialize a ``JSON`` from a `String`
    ///
    /// Use this initializer to create a ``JSON`` value from a `String`. For example:
    ///
    /// ```swift
    /// import Athena
    ///
    /// let string = "Steve"
    /// let json = JSON(string)
    /// ```
    ///
    /// - Parameter string: The string value
    public init(_ string: String) {
        self = .string(string)
    }

    /// Initialize a ``JSON`` from an optional `String`
    ///
    /// Use this initializer to create a ``JSON`` value from an optional `String`.
    /// If the supplied optional is `nil`, the initialized JSON value will contain `null`
    ///
    /// For example:
    ///
    /// ```
    /// import Athena
    ///
    /// let condition: Bool = ...
    ///
    /// let string: String? = condition : "Steve" : nil
    /// let json = JSON(string)
    /// ```
    ///
    /// - Parameter string: The optional string value
    public init(_ string: String?) {
        self = string.map(JSON.init(_:)) ?? nil
    }

    /// Initialize a ``JSON`` from an array of ``JSON`` values
    ///
    /// Use this initializer to create a ``JSON`` value from an array of other ``JSON`` values. For example:
    ///
    /// ```swift
    /// import Athena
    ///
    /// let array = [JSON( ...), JSON( ... ), JSON( ... )]
    /// let json = JSON(array)
    /// ```
    ///
    /// - Parameter array: The array of values
    public init(_ array: [JSON]) {
        self = .array(array)
    }

    /// Initialize a ``JSON`` from an optional array of ``JSON`` values
    ///
    /// Use this initializer to create a``JSON`` value from an optional array of other ``JSON`` values.
    /// If the supplied optional is `nil`, the initialized JSON value will contain `null`
    ///
    /// For example:
    ///
    /// ```swift
    /// import Athena
    ///
    /// let condition: Bool = ...
    ///
    /// let array = condition ? [JSON( ...), JSON( ... ), JSON( ... )] : nil
    /// let json = JSON(array)
    /// ```
    ///
    /// - Parameter array: The optional array of values
    public init(_ array: [JSON]?) {
        self = array.map(JSON.init) ?? nil
    }

    /// Initialize a ``JSON`` from a dictionary of `String` keys and ``JSON`` values
    ///
    /// Use this initializer to create a ``JSON`` value from a dictionary of `String` keys and other ``JSON`` values. For example:
    ///
    /// ```swift
    /// import Athena
    ///
    /// let dictionary: ["key": JSON( ... )]
    /// let json = JSON(dictionary
    /// ```
    /// - Parameter dictionary: The dictionary of strings and values
    public init(_ dictionary: [String: JSON]) {
        self = .object(dictionary)
    }

    /// Initialize a ``JSON`` from an optional dictionary of `String` keys and ``JSON`` values
    ///
    /// Use this initialize to create a ``JSON`` value from an optional dictioanry of `String` keys and other ``JSON`` values.
    /// If the supplied optional is `nil`, the initialized JSON will contain `nil`.
    ///
    /// For example:
    ///
    /// ```swift
    /// import Athena
    ///
    /// let condition: Bool  = ...
    ///
    /// let dictionary: [String: JSON]? = condition ? ["key": JSON( ... )] : nil
    /// let json = JSON(dictionary)
    /// ```
    ///
    /// - Parameter dictionary: The optional dictionary of strings and values
    public init(_ dictionary: [String: JSON]?) {
        self = dictionary.map(JSON.init) ?? nil
    }

    /// Initialize a ``JSON`` value that contains an empty object
    ///
    /// Use this initializer to create a ``JSON`` value that contains an empty JSON object
    public init() {
        self = .object([:])
    }

    // MARK: - API

    /// A JSON array
    ///
    /// This enum case represents a JSON array modeled using a Swift array of ``JSON`` values
    ///
    /// ```swift
    /// let json = JSON.array([.string("Aa"), .string("Bb"), .string("Cc")])
    /// ```
    case array([JSON])

    /// A JSON object
    ///
    /// This enum case represents a JSON object modeled using a Swift dictionary of `String` keys and ``JSON`` values
    ///
    /// ```swift
    /// let json = JSON.object(["some-key": .string("some-value"), "some-other-key": .string("some-other-value")])
    /// ```
    case object([String: JSON])

    /// A JSON number
    ///
    /// This enum case represents either a JSON number modeled using either a Swift `Int` value or a Swift `Double` value
    ///
    /// ```swift
    /// let int = JSON.number(.int(42))
    /// let double = JSON.number(.double(4.2))
    /// ```
    case number(Number)

    /// A JSON string
    ///
    /// This enum case represents a JSON string modeled using a Swift `String` value
    ///
    /// ```swift
    /// let json = JSON.string("Athena")
    /// ```
    case string(String)

    /// A JSON literal value
    ///
    /// This enum case reprsents one of three legal literal values: `true`, `false`, or `nil`
    ///
    /// ```swift
    /// let `true` = JSON.literal(.true)
    /// let `false` = JSON.literal(.false)
    /// let null = JSON.literal(.null)
    /// ```
    case literal(Literal)

    /// Get the value as a `Bool`
    /// - Throws: a ``JSON/Error``, if this JSON represents a type other than a bool
    public var boolValue: Bool {
        get throws {
            try literalValue.boolValue
        }
    }

    /// Get the value as a ``JSON/Literal``
    /// - Throws: a ``JSON/Error``, if this JSON represents a type other than a literal `true`, `false`, or `null`
    public var literalValue: Literal {
        get throws {
            guard case let .literal(literal) = self else {
                throw Error("The value is not a literal", .casting)
            }
            return literal
        }
    }

    /// Get the value as a `Int`
    /// - Throws: a ``JSON/Error``, if this JSON represents a type other than a ``JSON/Number``, or if the number cannot be expresed as an `Int`
    public var intValue: Int {
        get throws {
            try numberValue.intValue
        }
    }

    /// Get the value as a `Double`
    /// - Throws: a ``JSON/Error``, if this JSON represents a type other than a ``JSON/Number``
    public var doubleValue: Double {
        get throws {
            try numberValue.doubleValue
        }
    }

    /// Get the value as a ``JSON/Number``
    /// - Throws: a ``JSON/Error``, if this JSON represents a type other than a ``JSON/Number``
    public var numberValue: Number {
        get throws {
            guard case let .number(number) = self else {
                throw Error("The value is not a number", .casting)
            }
            return number
        }
    }

    /// Get the value as a `String`
    /// - Throws: a ``JSON/Error``, if this JSON represents a type other than a string
    public var stringValue: String {
        get throws {
            guard case let .string(string) = self else {
                throw Error("The value is not a string", .casting)
            }
            return string
        }
    }

    /// Get the value as an `Array<JSON>`
    /// - Throws: a ``JSON/Error``, if this JSON represents a type other than an array
    public var arrayValue: [JSON] {
        get throws {
            guard case let .array(array) = self else {
                throw Error("The value is not an array", .casting)
            }
            return array
        }
    }

    /// Get the value as a `Dictionary<String, JSON>`
    /// - Throws: a ``JSON/Error``, if this JSON represents a type other than an object
    public var dictionaryValue: [String: JSON] {
        get throws {
            guard case let .object(dictionary) = self else {
                throw Error("The value is not a dictionary", .casting)
            }
            return dictionary
        }
    }

    /// Determines whether the JSON represents a `null` literal
    ///
    /// This `var` evaluates to `true` if this JSON object represents a `null` literal or `false` if it does not.
    public var isNull: Bool {
        guard case let .literal(literal) = self else {
            return false
        }
        return literal.isNull
    }

    /// Retrive the value at the provided subscript.
    ///
    /// Only JSON objects and JSON arrays can be subscripted.
    /// JSON objects can be be subscripted using strings, while JSON arrays can be subscripted using integers.
    ///
    /// ```swift
    /// import Athena
    ///
    /// let object: JSON = ["key": "value"]
    /// let array: JSON = ["alpha", "beta", "gamma"]
    /// let member = try json.value(for: "key")
    /// let index = try json.value(for: 1)
    /// ```
    ///
    /// See <doc:Subscripting> for more information.
    ///
    /// - Parameter subscript: The subscript
    /// - Returns: The value at subscript
    /// - Throws: A ``JSON/Error`` if the value is not subscriptable, or if the provided subscript is invalid, or if no such value exists at the provided subscript
    public func value<T>(for subscript: T) throws -> JSON where T: JSONSubscript {
        switch self {
        case let .array(array):
            return try `subscript`.value(in: array)
        case let .object(dictionary):
            return try `subscript`.value(in: dictionary)
        case .number, .string, .literal:
            throw Error("JSON element \(self) is not subscriptable using subscript \(`subscript`)", .subscript)
        }
    }

    /// Retrieve the value at the provided path
    ///
    /// Only JSON objects and JSON arrays can be subscripted.
    /// JSON objects can be be subscripted using strings, while JSON arrays can be subscripted using integers.
    ///
    /// ```swift
    /// import Athena
    ///
    /// let json = [
    ///     "greek_letters": [
    ///         "alpha",
    ///         "beta",
    ///         "gamma"
    ///     ]
    /// ]
    ///
    /// let beta = try json.value(at: "greek_letters", 1)
    /// ```
    /// For more information, see <doc:Subscripting>.
    ///
    /// - Parameter path: The path as expressed by an ordered list of variadic suscript arguments
    /// - Returns: The value at the path
    /// - Throws: A ``JSON/Error`` if the provided path is invalid, or if no such value exists at the provided path
    public func value(at path: any JSONSubscript ...) throws -> JSON {
        try value(at: path)
    }

    /// Retrieve the value at the provided path
    ///
    /// Only JSON objects and JSON arrays can be subscripted.
    /// JSON objects can be be subscripted using strings, while JSON arrays can be subscripted using integers.
    ///
    /// ```swift
    /// import Athena
    ///
    /// let json = [
    ///     "greek_letters": [
    ///         "alpha",
    ///         "beta",
    ///         "gamma"
    ///     ]
    /// ]
    ///
    /// let path: JSONPath = ["greek_letters", 1]
    /// let beta = try json.value(at: path)
    /// ```
    ///
    /// For more information, see <doc:Subscripting>.
    ///
    /// - Parameter path: The path as expressed by an array of subscript elements
    /// - Returns: The value at the path
    /// - Throws: A ``JSON/Error`` if the provided path is invalid, or if no such value exists at the provided path
    public func value(at path: JSONPath) throws -> JSON {
        guard let `subscript` = path.first else {
            return self
        }
        return try value(for: `subscript`).value(at: Array(path.dropFirst()))
    }

    /// Decode the value into a ``JSONDecodable`` type
    ///
    /// Use this methode to decode this ``JSON`` instance into its ``JSONDecodable`` conforming type. For example:
    ///
    /// ```swift
    /// import Athena
    ///
    /// struct MyType: JSONDecodable { ... }
    ///
    /// let json = JSON( ... )
    /// let instance = try json.decode(MyType.self)
    /// ```
    ///
    /// You can also infer the `type` argument from the type context of the call site. For example:
    ///
    /// ```swift
    /// let instance: MyType = try json.decode()
    /// ```
    ///
    /// For more information, see <doc:EncodingDecoding>
    ///
    /// - Parameter type: The type you wish to decode into. This argument can be inferred from the call site.
    /// - Returns: The decoded `JSON`
    /// - Throws: A ``JSON/Error`` if the value cannot be decoded successfully
    public func decode<T>(_ type: T.Type = T.self) throws -> T where T: JSONDecodable {
        try Decoder.decode(type, from: self)
    }

    /// Serialize the value into UTF-8 data
    ///
    /// Use this method to serialize this ``JSON`` value into UTF-8 encoded data
    ///
    /// For more information, see <doc:Serializing>
    ///
    /// - Returns: The `Data` that represents this JSON object
    /// - Throws: A ``JSON/Error`` if the value cannot be serialized
    public func serialize() throws -> Data {
        try Serializer.serialize(self)
    }

    /// Serialize the value into a string
    ///
    /// Use this method to serialize this ``JSON`` value into a properly formatted JSON string
    ///
    /// For more information, see <doc:Serializing>
    ///
    /// - Returns: The `String` that represents this JSON object
    /// - Throws: A ``JSON/Error`` if the value cannot be serialized
    public func stringify() throws -> String {
        try Serializer.stringify(self)
    }

    // MARK: - Subscripts

    /// Retrive the value at the provided subscript
    /// - Parameter subscript: The subscript
    /// - Returns: The value at subscript, or ``JSON/Literal/null`` if no such value exists
    public subscript<T>(_ subscript: T) -> JSON where T: JSONSubscript {
        (try? value(at: `subscript`)) ?? nil
    }

    /// Retrive the value at the provided path
    /// - Parameter path: The path
    /// - Returns: The value at path, or ``JSON/Literal/null`` if no such value exists
    public subscript(_ path: any JSONSubscript ...) -> JSON {
        (try? value(at: path)) ?? nil
    }

    /// Decode the value at the provided subscript
    /// - Parameters subscript: The subscript
    /// - Returns: The decoded value at subscript, or `nil` if no such value exists, or if the value could not be decoded successfully.
    public subscript<T, Subscript>(_ subscript: Subscript) -> T? where T: JSONDecodable, Subscript: JSONSubscript {
        try? value(for: `subscript`).decode()
    }

    // MARK: - CustomStringConvertible

    /// A textual representation of this instance.
    public var description: String {
        switch self {
        case let .array(array):
            return array.description
        case let .object(dictionary):
            return dictionary.description
        case let .number(number):
            return number.description
        case let .string(string):
            return string.description
        case let .literal(literal):
            return literal.description
        }
    }

    // MARK: - CustomDebugStringConvertible

    /// A type with a customized textual representation suitable for debugging purposes.
    public var debugDescription: String {
        toPrettyString()
    }

    // MARK: - ExpressibleByArrayLiteral

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = JSON

    /// Creates an instance initialized with the given elements.
    ///
    /// Do not call this initializer directly. It is used by the compiler when you use an array literal. Instead, create a new ``JSON`` using an array literal as its value by enclosing a comma-separated list of values in square brackets. You can use an array literal anywhere a ``JSON`` is expected by the type context. For example:
    ///
    /// ```swift
    /// let ingredients: JSON = ["cocoa beans", "sugar", "cocoa butter", "salt"]
    /// ```
    /// In this example, the assignment to the `ingredients` constant calls this array literal initializer behind the scenes.
    ///
    /// - Parameter elements: A list of elements of the new set.
    public init(arrayLiteral elements: ArrayLiteralElement...) {
        self = .array(elements)
    }

    // MARK: - ExpressibleByDictionaryLiteral

    /// The key type of a dictionary literal.
    public typealias Key = String

    /// The value type of a dictionary literal.
    public typealias Value = JSON

    /// Creates an instance initialized to a dictionary based on the provided list of key value pair tuples
    ///
    /// Do not call this initializer directly. Instead, initialize a variable or constant using a dictionary literal as its value by encluding a comma separate list of key value pairs, each separated by a colon. You can use a dictionary literal anywhere a ``JSON`` is expected by the type context. For example:
    ///
    /// ```swift
    /// let person: JSON = ["first_name": "Steve", "last_name": "Jobs"]
    /// ```
    /// In this example, the assignment to the `person` constant calls this dictionary literal initializer behind the scenes.
    /// - Parameter elements: A list of key value pair tuples.
    public init(dictionaryLiteral elements: (Key, Value)...) {
        self = .object(elements.reduce([:]) { dict, pair in
            var next = dict
            let (key, value) = pair
            next[key] = value
            return next
        })
    }

    // MARK: - ExpressibleByBooleanLiteral

    /// A type that represents a Boolean literal, such as `Bool`.
    public typealias BooleanLiteralType = Bool

    /// Creates an instance initialized to the given Boolean value.
    ///
    /// Do not call this initializer directly. Instead, initialize a variable or constant using one of the Boolean literals `true` and `false`. You can use aa Boolean literal anywhere a ``JSON`` is expected by the type context: For example:
    ///
    /// ```swift
    /// let value: JSON = true
    /// ```
    /// In this example, the assignment to the `value` constant calls this Boolean literal initializer behind the scenes.
    ///
    /// - Parameter value: The value of the new instance.
    public init(booleanLiteral value: Bool) {
        self = .literal(.init(value))
    }

    // MARK: - ExpressibleByIntegerLiteral

    /// A type that represents an integer literal.
    public typealias IntegerLiteralType = Int

    /// Creates an instance initialized to the specified integer value.
    ///
    /// Do not call this initializer directly. Instead, initialize a variable or constant using an integer literal. You can use an integer literal anywhere a ``JSON`` is expected by the type context. For example:
    ///
    /// ```swift
    /// let x: JSON = 23
    /// ```
    /// In this example, the assignment to the `x` constant calls this integer literal initializer behind the scenes
    ///
    /// - Parameter value: The value to create.
    public init(integerLiteral value: Int) {
        self = .number(.int(value))
    }

    // MARK: - ExpressibleByFloatLiteral

    /// A type that represents a floating-point literal.
    public typealias FloatLiteralType = Double

    /// Creates an instance initialized to the specified floating-point value.
    ///
    /// Do not call this initializer directly. Instead, initialize a variable or constant using a floating-point literal. You can use a floating-point literal anywhere a ``JSON`` is expected by the type context. For example:
    ///
    /// ```swift
    /// let x: JSON = 21.5
    /// ```
    /// In this example, the assignment to the `x` constant calls this floating-point literal initializer behind the scenes.
    ///
    /// - Parameter value: The value to create.
    public init(floatLiteral value: Double) {
        self = .number(.double(value))
    }

    // MARK: - ExpressibleByStringLiteral

    /// A type that represents a string literal.
    public typealias StringLiteralType = String

    /// Creates an instance initialized to the given string value.
    ///
    /// Do not call this initializer directly. Instead, initialize a variable or constant using a string literal. You can use a string literal anywhere a ``JSON`` is expected by the type context. For example:
    ///
    /// ```swift
    /// let key: JSON = "value"
    /// ```
    /// In this example, the assignment to the `key` constant calls this string literal initializer behind the scenes.
    ///
    /// - Parameter value: The value of the new instance.
    public init(stringLiteral value: String) {
        self = .string(value)
    }

    // MARK: - ExpressibleByNilLiteral

    /// Creates an instance initialized with nil.
    ///
    /// Do not call this initializer directly. Instead, initialize a variable or constnant using a `nil` literal. You can use a `nil` literal anywhere a ``JSON`` is expected by the type context. For example:
    ///
    /// ```swift
    /// let null: JSON = nil
    /// ```
    /// In this example, the assignment to the `null` constant calls this nill literal initialize behind the scenes.
    public init(nilLiteral: Void) {
        self = .literal(.null)
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
        case let .literal(literal):
            switch literal {
            case .true:
                return "true"
            case .false:
                return "false"
            case .null:
                return "null"
            }
        case let .number(number):
            return number.description
        case let .string(string):
            return "\"" + string + "\""

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
        case let .number(number):
            return number.description
        case let .string(string):
            return "\"" + string + "\""
        case let .literal(literal):
            switch literal {
            case .true:
                return "true"
            case .false:
                return "false"
            case .null:
                return "null"
            }
        }
    }
}
