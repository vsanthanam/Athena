// Athena
// Subscript.swift
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

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public extension JSON {

    /// An enumeration representing a valid JSON subscript
    enum Subscript: Equatable, Hashable, Sendable, ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, CustomStringConvertible {

        // MARK: - Initializers

        /// Create a ``JSON/Subscript`` from a string
        /// - Parameter key: The string
        public init(key: String) {
            self = .key(key)
        }

        /// Create a ``JSON/Subscript`` from an integer
        /// - Parameter index: The integer
        public init(index: Int) {
            self = .index(index)
        }

        /// Create a ``JSON/Subscript`` from a ``JSONSubscriptRepresentable``-conforming value
        /// - Parameter value: The conforming value
        public init<T>(_ value: T) where T: JSONSubscriptRepresentable {
            self = value.toJSONSubscript()
        }

        // MARK: - Enumeration Cases

        /// A subscript representing a key inside a JSON object
        case key(String)

        /// A subscript representing an index inside a JSON array
        case index(Int)

        // MARK: - ExpressibeByStringLiteral

        /// A type that represents a string literal.
        public typealias StringLiteralType = String

        /// Creates an instance initialized to the given string value.
        ///
        /// Do not call this initializer directly. Instead, initialize a variable or constant using a string literal. You can use a string literal anywhere a ``JSON/Subscript`` is expected by the type context. For example:
        ///
        /// ```swift
        /// let key: JSON.Subscript = "value"
        /// ```
        /// In this example, the assignment to the `key` constant calls this string literal initializer behind the scenes.
        ///
        /// - Parameter value: The value of the new instance.
        public init(stringLiteral value: StringLiteralType) {
            self = .key(value)
        }

        // MARK: - ExpressibleByIntegerLiteral

        /// A type that represents an integer literal.
        public typealias IntegerLiteralType = Int

        /// Creates an instance initialized to the specified integer value.
        ///
        /// Do not call this initializer directly. Instead, initialize a variable or constant using an integer literal. You can use an integer literal anywhere a ``JSON/Subscript`` is expected by the type context. For example:
        ///
        /// ```swift
        /// let index: JSON.Subscript = 23
        /// ```
        /// In this example, the assignment to the `index` constant calls this integer literal initializer behind the scenes
        ///
        /// - Parameter value: The value to create.
        public init(integerLiteral value: IntegerLiteralType) {
            self = .index(value)
        }

        // MARK: - API

        /// Get the `String` value of this subscript, if this subscript represents a key.
        /// - Throws: An error, if this subscript does not represent a key.
        public var keyValue: String {
            get throws {
                switch self {
                case let .key(key):
                    return key
                case .index:
                    throw Error("The subscript is not an index")
                }
            }
        }

        /// Get the `Int` value of this subscript, if this subscript represents an index.
        /// - Throws: An error, if this subscript does not represent an index.
        public var indexValue: Int {
            get throws {
                switch self {
                case .key:
                    throw Error("The subscript is not a key")
                case let .index(index):
                    return index
                }
            }
        }

        // MARK: - CustomStringConvertible

        /// A textual representation of this instance.
        public var description: String {
            switch self {
            case let .key(key):
                return key.description
            case let .index(index):
                return index.description
            }
        }

    }

    /// A typealias representing a JSON Path
    typealias Path = [any JSONSubscriptRepresentable]

}
