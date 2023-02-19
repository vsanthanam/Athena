// Athena
// LiteralDecodable.swift
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

/// A type that can decode itself from an external ``JSON/Literal`` representation.
///
/// You need not implement this protocol yourself.
/// 
/// Athena includes conformance to ``LiteralDecodable`` for the following Swift types:
///  - `Bool`
///  - `String`
@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public protocol LiteralDecodable {

    /// Initialize an instance using a ``JSON/Literal`` value
    ///
    /// This initializer should be used to produce an instance based on the provided ``JSON/Literal``.
    /// If the provided ``JSON/Literal`` is shaped incorrectly or missing data necessary to initialize an instance, it should throw an error.
    ///
    /// - Parameter json: The ``JSON/Literal`` value to decode into `Self`
    /// - Throws: An error if an instance cannot be decoded from the provided ``JSON/Literal``
    init(jsonLiteral: JSON.Literal) throws
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Bool: LiteralDecodable {
    public init(jsonLiteral: JSON.Literal) throws {
        self = try jsonLiteral.boolValue
    }
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension String: LiteralDecodable {
    public init(jsonLiteral: JSON.Literal) throws {
        switch jsonLiteral {
        case .true:
            self = "true"
        case .false:
            self = "false"
        case .null:
            self = "null"
        }
    }
}
