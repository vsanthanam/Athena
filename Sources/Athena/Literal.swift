// Athena
// Literal.swift
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

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public extension JSON {

    /// A Swift represention of a legal JSON literal — `true`, `false`, or `null`
    enum Literal: Equatable, Hashable, Sendable, ExpressibleByNilLiteral, ExpressibleByBooleanLiteral, CustomStringConvertible {

        // MARK: - Initializers

        /// Initialize a ``JSON/Literal`` with a `null` value
        public init() {
            self = .null
        }

        /// Initialize a ``JSON/Literal`` based on a `Bool`
        public init(_ bool: Bool) {
            self = bool ? .true : .false
        }

        // MARK: - API

        /// A `true` JSON literal
        case `true`

        /// A `false` JSON literal
        case `false`

        /// A `null` JSON literal
        case null

        /// Retrieve the the value as a `Bool`
        ///
        /// Use this throwing var to retieve the literal as `Bool`, if possible. For example:
        ///
        /// ```swift
        /// import Athena
        ///
        /// let bool = Literal.true
        /// let null = Literal.null
        ///
        /// let val1 = try bool.boolValue // Succeeds
        /// let val2 = try null.boolValue // Throws
        /// ```
        ///
        /// - Throws: A ``JSON/Error`` if the literall cannot be expressed as a `Bool`
        public var boolValue: Bool {
            get throws {
                switch self {
                case .true:
                    return true
                case .false:
                    return false
                case .null:
                    throw Error("")
                }
            }
        }

        /// Determines whether the literal represents a `null`
        ///
        /// This `var` evaluates to `true` if this literal represents `null` or `false` if it does not.
        public var isNull: Bool {
            switch self {
            case .null:
                return true
            case .true, .false:
                return false
            }
        }

        /// Decode the value into a ``LiteralDecodable`` type
        ///
        /// Use this methode to decode this ``JSON/Literal`` instance into a ``LiteralDecodable`` conforming type. For example:
        ///
        /// ```swift
        /// import Athena
        ///
        /// let literal = JSON.Literal( ... )
        /// let bool = try literal.decode(Int.self)
        /// ```
        ///
        /// You can also infer the `type` argument from the type context of the call site. For example:
        ///
        /// ```swift
        /// let bool: Bool = try literal.decode()
        /// ```
        ///
        /// - Parameter type: The type you wish to decode into. This argument can be inferred from the call site.
        /// - Returns: The decoded ``JSON/Literal``
        /// - Throws: A ``JSON/Error`` if the value cannot be decoded successfully
        public func decode<T>(_ type: T.Type = T.self) throws -> T where T: LiteralDecodable {
            try T(jsonLiteral: self)
        }

        // MARK: - ExpressibleByBooleanLiteral

        /// A type that represents a Boolean literal, such as `Bool`.
        public typealias BooleanLiteralType = Bool

        /// Creates an instance initialized to the given Boolean value.
        ///
        /// Do not call this initializer directly. Instead, initialize a variable or constant using one of the Boolean literals `true` and `false`. You can use aa Boolean literal anywhere a ``JSON/Literal`` is expected by the type context: For example:
        ///
        /// ```swift
        /// let value: JSON.Literal = true
        /// ```
        /// In this example, the assignment to the `value` constant calls this Boolean literal initializer behind the scenes.
        ///
        /// - Parameter value: The value of the new instance.
        public init(booleanLiteral value: BooleanLiteralType) {
            self.init(value)
        }

        // MARK: - ExpressibleByNilLiteral

        /// Creates an instance initialized with nil.
        ///
        /// Do not call this initializer directly. Instead, initialize a variable or constant using a `nil` literal. You can use a `nil` literal anywhere a ``JSON/Literal`` is expected by the type context. For example:
        ///
        /// ```swift
        /// let null: JSON.Literal = nil
        /// ```
        /// In this example, the assignment to the `null` constant calls this nill literal initialize behind the scenes.
        public init(nilLiteral: ()) {
            self = .null
        }

        // MARK: - CustomStringConvertible

        /// A textual representation of this instance.
        public var description: String {
            switch self {
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
