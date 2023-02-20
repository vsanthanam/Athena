// Athena
// Number.swift
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

    /// A Swift represention of a JSON number, either an `Int` or a `Double`
    enum Number: Equatable, Hashable, Sendable, Comparable, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, CustomStringConvertible {

        /// Create a ``JSON/Number`` from an `Int`
        /// - Parameter value: The integer
        public init(_ value: Int) {
            self = .int(value)
        }

        /// Create a ``JSON/Number`` a `Double`
        /// - Parameter value: The double
        public init(_ value: Double) {
            self = .double(value)
        }

        // MARK: - API

        /// A JSON bumber backed by a Swift `Int`
        case int(Int)

        /// A JSON number backed by a Swift `Double`
        case double(Double)

        /// Retrieve the value as an `Int`, if possible.
        /// - Throws: a ``JSON/Error`` if the value is not an int
        public var intValue: Int {
            get throws {
                switch self {
                case let .int(int):
                    return int
                case .double:
                    throw Error("The value is not an integer")
                }
            }
        }

        /// Retrieve the value as an `Double`, if possible.
        /// - Throws: a ``JSON/Error`` if the value is not a double
        public var doubleValue: Double {
            get throws {
                switch self {
                case .int:
                    throw Error("The value is not a double")
                case let .double(double):
                    return double
                }
            }
        }

        /// Decode the value into a ``NumberDecodable`` type
        ///
        /// Use this methode to decode this ``JSON/Number`` instance into a ``NumberDecodable`` conforming type. For example:
        ///
        /// ```swift
        /// import Athena
        ///
        /// let number = JSON.Number( ... )
        /// let int = try number.decode(Int.self)
        /// ```
        ///
        /// You can also infer the `type` argument from the type context of the call site. For example:
        ///
        /// ```swift
        /// let int: Int = try number.decode()
        /// ```
        ///
        /// - Parameter type: The type you wish to decode into. This argument can be inferred from the call site.
        /// - Returns: The decoded ``JSON/Number``
        /// - Throws: A ``JSON/Error`` if the value cannot be decoded successfully
        public func decode<T>(_ type: T.Type = T.self) throws -> T where T: NumberDecodable {
            try T(jsonNumber: self)
        }

        // MARK: - ExpressibleByIntegerLiteral

        /// A type that represents an integer literal.
        public typealias IntegerLiteralType = Int

        /// Creates an instance initialized to the specified integer value.
        ///
        /// Do not call this initializer directly. Instead, initialize a variable or constant using an integer literal. You can use an integer literal anywhere a ``JSON/Number`` is expected by the type context. For example:
        ///
        /// ```swift
        /// let x: JSON.Number = 23
        /// ```
        /// In this example, the assignment to the `x` constant calls this integer literal initializer behind the scenes
        ///
        /// - Parameter value: The value to create.
        public init(integerLiteral value: IntegerLiteralType) {
            self.init(value)
        }

        // MARK: - ExpressibleByFloatLiteral

        /// A type that represents a floating-point literal.
        public typealias FloatLiteralType = Double

        /// Creates an instance initialized to the specified floating-point value.
        ///
        /// Do not call this initializer directly. Instead, initialize a variable or constant using a floating-point literal. You can use a floating-point literal anywhere a ``JSON/Number`` is expected by the type context. For example:
        ///
        /// ```swift
        /// let x: JSON.Number = 21.5
        /// ```
        /// In this example, the assignment to the `x` constant calls this floating-point literal initializer behind the scenes.
        ///
        /// - Parameter value: The value to create.
        public init(floatLiteral value: FloatLiteralType) {
            self.init(value)
        }

        // MARK: - CustomStringConvertible

        /// A textual representation of this instance.
        public var description: String {
            switch self {
            case let .int(int):
                return int.description
            case let .double(double):
                return double.description
            }
        }
    }
}
