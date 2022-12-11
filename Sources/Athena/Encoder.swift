// Athena
// Encoder.swift
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

    /// A type used to encode ``JSONEncodable`` conforming types into their ``JSON`` representations
    struct Encoder {

        /// Synchronously encode a ``JSONEncodable`` type into ``JSON``
        ///
        /// Use this method to create a ``JSON`` representation of a ``JSONEncodable`` conforming type. For example:
        ///
        /// ```swift
        /// import Athena
        ///
        /// struct MyStruct: JSONEncodable { ... }
        ///
        /// let instance = MyStruct()
        /// let json = JSON.Encoder.encode(instance)
        /// ```
        /// - Parameter value: The value to encode
        /// - Returns: The ``JSON`` representing the provided value
        public static func encode<T>(_ value: T) -> JSON where T: JSONEncodable {
            let encoder = Encoder(value)
            return encoder.encode()
        }

        /// Asynchronously encode a ``JSONEncodable`` type into ``JSON``
        ///
        /// Use this method to create a ``JSON`` representation of a ``JSONEncodable`` conforming type. For example:
        ///
        /// ```swift
        /// import Athena
        ///
        /// struct MyStruct: JSONEncodable { ... }
        ///
        /// let instance = MyStruct()
        /// let json = await JSON.Encoder.encode(instance)
        /// ```
        /// - Parameter value: The value to encode
        /// - Returns: The ``JSON`` representing the provided value
        @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
        public static func encode<T>(_ value: T) async -> JSON where T: JSONEncodable {
            await Task { encode(value) }.value
        }

        /// Asynchronously encode a ``JSONEncodable`` type into ``JSON`` using a completion handler
        ///
        /// Use this method to create a ``JSON`` representation of a ``JSONEncodable`` conforming type. For example:
        ///
        /// ```swift
        /// import Athena
        ///
        /// struct MyStruct: JSONEncodable { ... }
        ///
        /// let instance = MyStruct()
        /// JSON.encoder.encode(instance) { instance, json in
        ///     // Do something with `json`
        /// }
        /// ```
        ///
        /// - Parameters:
        ///   - value: The value to encode
        ///   - completionHandler: The closure used to handle the result of the asynchronous operation
        @available(macOS, deprecated: 12.0, message: "Use the Swift Concurrency based APIs instead.")
        @available(iOS, deprecated: 15.0, message: "Use the Swift Concurrency based APIs instead.")
        @available(watchOS, deprecated: 8.0, message: "Use the Swift Concurrency based APIs instead.")
        @available(tvOS, deprecated: 15.0, message: "Use the Swift Concurrency based APIs instead.")
        public static func encode<T>(
            _ value: T,
            completionHandler: @escaping (T, JSON) -> Void
        ) where T: JSONEncodable {
            DispatchQueue.global().async {
                let json = encode(value)
                completionHandler(value, json)
            }
        }

        // MARK: - Private

        private init<T>(_ value: T) where T: JSONEncodable {
            self.value = value
        }

        private func encode() -> JSON {
            value.toJSON()
        }

        private let value: any JSONEncodable
    }

}
