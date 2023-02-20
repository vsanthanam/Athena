// Athena
// Serializer.swift
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

    /// A static interface used to serialize ``JSON`` values into other types.
    struct Serializer {

        /// Synchronously serialize a ``JSON`` value into UTF-8 encoded data
        ///
        /// Use this method to create UTF-8 encoded data based on a ``JSON`` value. For example:
        ///
        /// ```swift
        /// import Athena
        ///
        /// let json: JSON( ... )
        /// let data = try JSON.Serializer.serialize(json, options: [.nullSkipsKey, .prettyPrinted])
        /// ```
        /// - Parameters:
        ///   - json: The ``JSON`` value to serialize
        ///   - options: The options bitmask used to configure the serialization process
        /// - Returns: The `Data` containing the serialzied ``JSON``
        /// - Throws: A ``JSON/Error`` if the serialization process fails
        public static func serialize(
            _ json: JSON,
            options: Options = .default
        ) throws -> Data {
            var serializer = Serializer(json)
            serializer.options = options
            return try serializer.serializeData()
        }

        /// Asynchronously serialize a ``JSON`` value into UTF-8 encoded data
        ///
        /// Use this method to create UTF-8 encoded data based on a ``JSON`` value. For example:
        ///
        /// ```swift
        /// import Athena
        ///
        /// let json: JSON( ... )
        /// let data = try await JSON.Serializer.serialize(json, options: [.nullSkipsKey, .prettyPrinted])
        /// ```
        /// - Parameters:
        ///   - json: The ``JSON`` value to serialize
        ///   - options: The options bitmask used to configure the serialization process
        /// - Returns: The `Data` containing the serialzied ``JSON``
        /// - Throws: A ``JSON/Error`` if the serialization process fails
        @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
        public static func serialize(
            _ json: JSON,
            options: Options = .default
        ) async throws -> Data {
            try await Task { try serialize(json, options: options) }.value
        }

        /// Asynchronously serialize a ``JSON`` value into UTF-8 encoded data using a completion handler
        ///
        /// Use this method to create UTF-8 encoded data based on a ``JSON`` value. For example:
        ///
        /// ```swift
        /// import Athena
        ///
        /// let json: JSON( ... )
        /// JSON.Serializer.serialize(json, options: [.nullSkipsKey, .prettyPrinted]) { json, result in
        ///     do {
        ///         let data = try result.get()
        ///         // Do something with `data`
        ///     } catch {
        ///         // Handle any thrown errors
        ///     }
        /// }
        /// ```
        /// - Parameters:
        ///   - json: The ``JSON`` value to serialize
        ///   - options: The options bitmask used to configure the serialization process
        ///   - completionHandler: The closure used to handle the result of the asynchronous operation
        @available(macOS, deprecated: 12.0, message: "Use the Swift Concurrency based APIs instead.")
        @available(iOS, deprecated: 15.0, message: "Use the Swift Concurrency based APIs instead.")
        @available(watchOS, deprecated: 8.0, message: "Use the Swift Concurrency based APIs instead.")
        @available(tvOS, deprecated: 15.0, message: "Use the Swift Concurrency based APIs instead.")
        public static func serialize(
            _ json: JSON,
            options: Options = .default,
            completionHandler: @escaping (JSON, Result<Data, any Swift.Error>) -> Void
        ) {
            DispatchQueue.global().async {
                let result = Result<Data, any Swift.Error> {
                    try serialize(json, options: options)
                }
                completionHandler(json, result)
            }
        }

        public static func stringify(
            _ json: JSON,
            options: Options = .default
        ) throws -> String {
            var serializer = Serializer(json)
            serializer.options = options
            return try serializer.serializeString()
        }

        @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
        public static func stringify(
            _ json: JSON,
            options: Options = .default
        ) async throws -> String {
            try await Task { try stringify(json, options: options) }.value
        }

        @available(macOS, deprecated: 12.0, message: "Use the Swift Concurrency based APIs instead.")
        @available(iOS, deprecated: 15.0, message: "Use the Swift Concurrency based APIs instead.")
        @available(watchOS, deprecated: 8.0, message: "Use the Swift Concurrency based APIs instead.")
        @available(tvOS, deprecated: 15.0, message: "Use the Swift Concurrency based APIs instead.")
        public static func stringify(
            _ json: JSON,
            options: Options = .default,
            completionHandler: @escaping (JSON, Result<String, any Swift.Error>) -> Void
        ) {
            DispatchQueue.global().async {
                let result = Result {
                    try stringify(json, options: options)
                }
                completionHandler(json, result)
            }
        }

        // MARK: - Private

        private init(_ json: JSON) {
            self.json = json
        }

        private var options: Options = .default
        private let json: JSON

        private func serializeData() throws -> Data {
            func buildNSObject(_ json: JSON, using options: Options) -> Any {
                switch json {
                case let .array(array):
                    return array.map { json in buildNSObject(json, using: options) }
                case let .object(dictionary):
                    var cocoa = [String: Any](minimumCapacity: dictionary.count)
                    for (key, json) in dictionary {
                        if json != nil || (json == nil && !options.contains(.nullSkipsKey)) {
                            cocoa[key] = buildNSObject(json, using: options)
                        }
                    }
                    return cocoa
                case let .number(number):
                    switch number {
                    case let .int(int):
                        return NSNumber(value: int)
                    case let .double(double):
                        return NSNumber(value: double)
                    }
                case let .string(string):
                    return string
                case let .literal(literal):
                    switch literal {
                    case .true:
                        return NSNumber(value: true)
                    case .false:
                        return NSNumber(value: false)
                    case .null:
                        return NSNull()
                    }
                }
            }

            let serializable = buildNSObject(json, using: options)
            guard JSONSerialization.isValidJSONObject(serializable) else {
                throw Error("Unknown Error")
            }
            do {
                return try JSONSerialization.data(withJSONObject: serializable, options: options.writingOptions)
            } catch {
                throw Error(error.localizedDescription)
            }
        }

        private func serializeString() throws -> String {
            let data = try serializeData()
            guard let string = String(data: data, encoding: .utf8) else {
                throw Error("Couldn't serialize data into a UTF8 encoded string")
            }
            return string
        }
    }
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public extension Data {

    /// Initialize a `Data` value be serializing a ``JSON`` value
    ///
    /// Use this initializer to serialize a ``JSON`` value into UTF-8 encoded `Data`. For example:
    ///
    /// ```swift
    /// import Athena
    ///
    /// let json: JSON = ["key": "value"]
    /// let data = try Data(serializing: json)
    /// ```
    ///
    /// - Parameter json: The ``JSON`` value to serialize
    /// - Throws: A ``JSON/Error`` if the serialization fails
    init(serializing json: JSON) throws {
        self = try json.serialize()
    }
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public extension String {

    /// Initialize a `String` value be serializing a ``JSON`` value
    ///
    /// Use this initializer to serialize a ``JSON`` value into a properly formatter JSON string. For example:
    ///
    /// ```swift
    /// import Athena
    ///
    /// let json: JSON = ["key": "value"]
    /// let string = try String(serializing: json)
    /// ```
    ///
    /// - Parameter json: The ``JSON`` value to serialize
    /// - Throws: A ``JSON/Error`` if the serialization fails
    init(serializing json: JSON) throws {
        self = try json.stringify()
    }

}
