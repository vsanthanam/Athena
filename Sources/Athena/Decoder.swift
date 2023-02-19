// Athena
// Decoder.swift
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

    /// A type used to decode ``JSONDecodable``conforming types from their ``JSON`` representations
    struct Decoder {

        /// Synchronously decode a ``JSONDecodable`` type from ``JSON``
        ///
        /// Use this method when you want to decode a ``JSONDecodable`` conforming type from a correctly shaped ``JSON`` value. For example:
        ///
        /// ```swift
        /// import Athena
        ///
        /// struct MyType: JSONDecodable {}
        ///
        /// let json: JSON( ... )
        /// let instance = try JSON.Decoder.decode(MyType.self, from: json)
        /// ```
        /// - Parameters:
        ///   - type: The type to decode into. This argument can be inferred by the compiler from the call site
        ///   - json: The JSON data to decode
        /// - Returns: The Swift type decoded from the provided JSON
        /// - Throws: A ``JSON/Error`` if the value could not be decoded successfully
        public static func decode<T>(
            _ type: T.Type = T.self,
            from json: JSON
        ) throws -> T where T: JSONDecodable {
            let decoder = Decoder(json)
            return try decoder.decode(type)
        }

        /// Asynchronously decode a ``JSONDecodable`` type from ``JSON``
        ///
        /// Use this method when you want to decode a ``JSONDecodable`` conforming type from a correctly shaped ``JSON`` value. For example:
        ///
        /// ```swift
        /// import Athena
        ///
        /// struct MyType: JSONDecodable {}
        ///
        /// let json: JSON( ... )
        /// let instance = try await JSON.Decoder.decode(MyType.self, from: json)
        /// ```
        ///
        /// - Parameters:
        ///   - type: The type to decode into. This argument can be inferred by the compiler from the call site
        ///   - json: The JSON data to decode
        /// - Returns: The Swift type decoded from the provided JSON
        /// - Throws: A ``JSON/Error`` if the value could not be decoded successfully
        @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
        public static func decode<T>(
            _ type: T.Type = T.self,
            from json: JSON
        ) async throws -> T where T: JSONDecodable {
            try await Task { try decode(type, from: json) }.value
        }

        /// Asynchronously decode a `JSONDecodable` type from ``JSON`` using a completion handler
        ///
        /// Use this method when you want to decode a ``JSONDecodable`` conforming type from a correctly shaped ``JSON`` value. For example:
        ///
        /// ```swift
        /// import Athena
        ///
        /// struct MyType: JSONDecodable {}
        ///
        /// let json: JSON( ... )
        /// JSON.Decoder.decode(MyType.self, from: json) { json, result in
        ///     do {
        ///         let instace = try result.get()
        ///         // Do something with `instance`
        ///     } catch {
        ///         // Handle thrown errors
        ///     }
        /// }
        /// ```
        ///
        /// - Parameters:
        ///   - type: The type to decode into. This argument can be inferred by the compiler from the call site
        ///   - json: The JSON data to decode
        ///   - completionHandler: The closure used to handle the result of the asynchronous operation
        @available(macOS, deprecated: 12.0, message: "Use the Swift Concurrency based APIs instead.")
        @available(iOS, deprecated: 15.0, message: "Use the Swift Concurrency based APIs instead.")
        @available(watchOS, deprecated: 8.0, message: "Use the Swift Concurrency based APIs instead.")
        @available(tvOS, deprecated: 15.0, message: "Use the Swift Concurrency based APIs instead.")
        public static func decode<T>(
            _ type: T.Type = T.self,
            from json: JSON,
            completionHandler: @escaping (JSON, Result<T, any Swift.Error>) -> Void
        ) where T: JSONDecodable {
            DispatchQueue.global().async {
                let result = Result {
                    try decode(type, from: json)
                }
                completionHandler(json, result)
            }
        }

        // MARK: - Private

        private init(_ json: JSON) {
            self.json = json
        }

        private let json: JSON

        private func decode<T>(_ type: T.Type) throws -> T where T: JSONDecodable {
            try T(json: json)
        }
    }

}
