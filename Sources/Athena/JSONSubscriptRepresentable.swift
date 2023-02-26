// Athena
// JSONSubscriptRepresentable.swift
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

/// A protocol that represents a type that can be represented as a ``JSON/Subscript``
///
/// Athena includes implementations of this protocol for the following Swit types:
///  - `String`
///  - `Int`
///  - `RawRepresentable where RawValue: JSONSubscriptRepresentable`
@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public protocol JSONSubscriptRepresentable {

    /// Convert the value into a ``JSON/Subscript``
    /// - Returns: The value represented as a ``JSON/Subscript``
    func toJSONSubscript() -> JSON.Subscript
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension String: JSONSubscriptRepresentable {
    public func toJSONSubscript() -> JSON.Subscript {
        .key(self)
    }
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Int: JSONSubscriptRepresentable {
    public func toJSONSubscript() -> JSON.Subscript {
        .index(self)
    }
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public extension JSONSubscriptRepresentable where Self: RawRepresentable, RawValue: JSONSubscriptRepresentable {
    func toJSONSubscript() -> JSON.Subscript {
        rawValue.toJSONSubscript()
    }
}
