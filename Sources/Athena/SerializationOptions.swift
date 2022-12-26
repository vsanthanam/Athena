// Athena
// SerializationOptions.swift
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

public extension JSON {

    /// A type describing the various available options that Athena can use when serializing instances of ``JSON`` into other types.
    struct SerializationOptions: OptionSet {

        // MARK: - Initializer

        /// Create a `SerializationOptions` bitmask from a raw value
        /// - Parameter rawValue: The raw value
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        // MARK: - API

        /// Remove keys from objects with null values
        public static let nullSkipsKey = SerializationOptions(rawValue: 1 << 0)

        /// Add pretty printing format to the string
        public static let prettyPrinted = SerializationOptions(rawValue: 1 << 1)

        /// Sort the keys in an object
        public static let sortedKeys = SerializationOptions(rawValue: 1 << 2)

        /// Allow fragments
        public static let fragmentsAllowed = SerializationOptions(rawValue: 1 << 4)

        /// Remove escaping slashes
        @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
        public static let withoutEscapingSlashes = SerializationOptions(rawValue: 1 << 5)

        /// The default options
        public static let `default`: SerializationOptions = []

        // MARK: - OptionSet

        public let rawValue: Int

    }

}