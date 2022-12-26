// Athena
// JSONSubscript.swift
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

/// A type representing a valid JSON subscript
///
/// Because JSON subscripts are always strings (for JSON objects) or integers (for JSON arrays), you likely do not need to implement this protocol yourself.
/// Athena provides implementations for `String` and `Int`
@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public protocol JSONSubscript {

    /// Retrieve the value using a subscript from a dictionary of `String` keys and `JSON` values
    /// - Parameter dictionary: The dictionary to evaluate using `self` as the subscript
    /// - Returns: The `JSON` value for the provided subscript
    /// - Throws: An errror if the provided dictionary is not subscriptable using `self`
    func value(in dictionary: [String: JSON]) throws -> JSON

    /// Retrieve the value using a subscript from an array of `JSON` values
    /// - Parameter array: The array to evaluate using `self` as the subscript
    /// - Returns: The `JSON` value for the provided subscript
    /// - Throws: An errror if the provided array is not subscriptable using `self`
    func value(in array: [JSON]) throws -> JSON
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public extension JSONSubscript {
    func value(in dictionary: [String: JSON]) throws -> JSON {
        throw JSON.Error("Invalid JSON subscript", .subscript)
    }

    func value(in array: [JSON]) throws -> JSON {
        throw JSON.Error("Invalid JSON subscript", .subscript)
    }
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Int: JSONSubscript {
    public func value(in array: [JSON]) throws -> JSON {
        guard case array.indices = self else {
            throw JSON.Error("Index out of bounds", .subscript)
        }
        return array[self]
    }
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension String: JSONSubscript {
    public func value(in dictionary: [String: JSON]) throws -> JSON {
        guard let next = dictionary[self] else {
            throw JSON.Error("Key not found in object", .subscript)
        }
        return next
    }
}

public extension JSONSubscript where Self: RawRepresentable, RawValue: JSONSubscript {
    func value(in dictionary: [String: JSON]) throws -> JSON {
        try rawValue.value(in: dictionary)
    }

    func value(in array: [JSON]) throws -> JSON {
        try rawValue.value(in: array)
    }
}