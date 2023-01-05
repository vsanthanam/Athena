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
    enum Number: Equatable, Hashable, Sendable, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, CustomStringConvertible {

        /// Create a ``JSON/Number`` from an `Int`
        /// - Parameter value: The integer
        public init(_ value: Int) {
            self = .int(value)
        }

        /// Create a ``JSON/Number`` a `Double`
        /// - Parameter value: The double
        public init(_ value: Double) {
            if value.truncatingRemainder(dividingBy: 1) == 0 {
                self = .int(Int(value))
            } else {
                self = .double(value)
            }
        }

        // MARK: - API

        /// A JSON bumber backed by a Swift `Int`
        case int(Int)

        /// A JSON number backed by a Swift `Double`
        case double(Double)

        /// Retrieve the value as an `Int`, if possible.
        /// - Throws: a ``JSON/Error`` if the value cannot be expressed as an `Int` without losing precision
        public var intValue: Int {
            get throws {
                switch self {
                case let .int(int):
                    return int
                case let .double(double):
                    guard double.truncatingRemainder(dividingBy: 1) == 0 else {
                        throw Error()
                    }
                    return Int(double)
                }
            }
        }

        /// Retrieve the value as a `Double`
        public var doubleValue: Double {
            switch self {
            case let .int(int):
                return Double(int)
            case let .double(double):
                return double
            }
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

        // MARK: - Equatable

        /// Returns a Boolean value indicating whether two values are equal.
        ///
        /// Equality is the inverse of inequality. For any values a and b, a == b implies that a != b is false.
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        /// - Returns: `true` if the values are equal. Otherwise, `false`.
        public static func == (lhs: JSON.Number, rhs: JSON.Number) -> Bool {
            switch (lhs, rhs) {
            case let (.int(l), .int(r)):
                return l == r
            case let (.double(l), .double(r)):
                return l == r
            case let (.int(l), .double(r)):
                return Double(l) == r
            case let (.double(l), .int(r)):
                return l == Double(r)
            }
        }

        // MARK: - Hashable

        /// Hashes the essential components of this value by feeding them into the given hasher.
        ///
        /// Implement this method to conform to the Hashable protocol. The components used for hashing must be the same as the components compared in your type’s == operator implementation. Call hasher.combine(_:) with each of these components.
        /// - Parameter hasher: The hasher to use when combining the components of this instance
        public func hash(into hasher: inout Hasher) {
            switch self {
            case let .int(int):
                hasher.combine(int)
            case let .double(double):
                if double.truncatingRemainder(dividingBy: 1) == 0 {
                    let int = Int(double)
                    hasher.combine(int)
                } else {
                    hasher.combine(double)
                }
            }
        }
    }
}
