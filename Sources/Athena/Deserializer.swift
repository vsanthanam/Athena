// Athena
// Deserializer.swift
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

    /// A type used to deserialze `String` and `Data` values into ``JSON``
    struct Deserializer {

        // MARK: - API

        /// Synchronously deserialize UTF-8 encoded `Data` into a ``JSON`` value
        ///
        /// Use this method to create a ``JSON`` value from UTF-8 data. For example:
        ///
        /// ```swift
        /// import Athena
        ///
        /// let data = Data( ... )
        /// let json = try JSON.Deserializer.deserialize(data, options: .fragmentsAllowed)
        /// ```
        ///
        /// - Parameters:
        ///   - data: The data to deserialize
        ///   - options: The options bitmask used to configure the deserialization process
        /// - Returns: The ``JSON`` value produced by deserializing the provided data
        /// - Throws: A ``JSON/Error`` if the data cannot be deserialized.
        public static func deserialize(
            _ data: Data,
            options: Options = .default
        ) throws -> JSON {
            try parse(data, maximumDepth: 1024, options: options)
        }

        /// Asynchronously deserialize UTF-8 encoded `Data` into a ``JSON`` value
        ///
        /// Use this method to create a ``JSON`` value from UTF-8 data. For example:
        ///
        /// ```swift
        /// import Athena
        ///
        /// let data = Data( ... )
        /// let json = try await JSON.Deserializer.deserialize(data, options: .fragmentsAllowed)
        /// ```
        ///
        /// - Parameters:
        ///   - data: The data to deserialize
        ///   - options: The options bitmask used to configure the deserialization process
        /// - Returns: The ``JSON`` value produced by deserializing the provided data
        /// - Throws: A ``JSON/Error`` if the data cannot be deserialized.
        @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
        public static func deserialize(
            _ data: Data,
            options: Options = .default
        ) async throws -> JSON {
            try await Task { try parse(data, maximumDepth: .max, options: options) }.value
        }

        /// Asynchronously deserialize UTF-8 encoded `Data` into a ``JSON`` value using a completion handler
        ///
        /// Use this method to create a ``JSON`` value from UTF-8 data. For example:
        ///
        /// ```swift
        /// import Athena
        ///
        /// let data = Data( ... )
        /// JSON.Deserializer.deserialize(data, options: .fragmentsAllowed) { data, result in
        ///     do {
        ///         let json = try result.get()
        ///         // Do something with `json`
        ///     } catch {
        ///         // Handle any thrown errors
        ///     }
        /// }
        /// ```
        ///
        /// - Parameters:
        ///   - data: The data to deserialize
        ///   - options: The options bitmask used to configure the deserialization process
        ///   - completionHandler: The closure used to handle the result of the asynchronous operation
        @available(macOS, deprecated: 12.0, message: "Use the Swift Concurrency based APIs instead.")
        @available(iOS, deprecated: 15.0, message: "Use the Swift Concurrency based APIs instead.")
        @available(watchOS, deprecated: 8.0, message: "Use the Swift Concurrency based APIs instead.")
        @available(tvOS, deprecated: 15.0, message: "Use the Swift Concurrency based APIs instead.")
        public static func deserialize(
            _ data: Data,
            options: Options = .default,
            completionHandler: @escaping (Data, Result<JSON, any Swift.Error>) -> Void
        ) {
            DispatchQueue.global().async {
                let result: Result<JSON, any Swift.Error> = .init {
                    try parse(data, maximumDepth: .max, options: options)
                }
                completionHandler(data, result)
            }
        }

        /// Synchronously deserialize a formatted JSON `String` into a ``JSON`` value
        ///
        /// Use this method to create a ``JSON`` value from a properly formatted JSON string. For example:
        ///
        /// ```swift
        /// import Athena
        ///
        /// let string = "{\"key\" : \"value\"}"
        /// let json = try JSON.Deserializer.deserialize(string, options: .fragmentsAllowed)
        /// ```
        ///
        /// - Parameters:
        ///   - data: The data to deserialize
        ///   - options: The options bitmask used to configure the deserialization process
        /// - Returns: The ``JSON`` value produced by deserializing the provided data
        /// - Throws: A ``JSON/Error`` if the data cannot be deserialized.
        public static func deserialize(
            _ jsonString: String,
            options: Options = .default
        ) throws -> JSON {
            try parse(jsonString, maximumDepth: 1024, options: options)
        }

        /// Asynchronously deserialize a formatted JSON `String` into a ``JSON`` value
        ///
        /// Use this method to create a ``JSON`` value from a properly formatted JSON string. For example:
        ///
        /// ```swift
        /// import Athena
        ///
        /// let string = "{\"key\" : \"value\"}"
        /// let json = try await JSON.Deserializer.deserialize(string, options: .fragmentsAllowed)
        /// ```
        ///
        /// - Parameters:
        ///   - data: The data to deserialize
        ///   - options: The options bitmask used to configure the deserialization process
        /// - Returns: The ``JSON`` value produced by deserializing the provided data
        /// - Throws: A ``JSON/Error`` if the data cannot be deserialized.
        @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
        public static func deserialize(
            _ jsonString: String,
            options: Options = .default
        ) async throws -> JSON {
            try await Task { try parse(jsonString, maximumDepth: .max, options: options) }.value
        }

        /// Asynchronously deserialize a formatted JSON `String` into a ``JSON`` value using a completion handler
        ///
        /// Use this method to create a ``JSON`` value from a properly formatted JSON string. For example:
        ///
        /// ```swift
        /// import Athena
        ///
        /// let string = "{\"key\" : \"value\"}"
        /// JSON.Deserializer.deserialize(string, options: .fragmentsAllowed) { string, result in
        ///     do {
        ///         let json = try result.get()
        ///         // Do something with `json`
        ///     } catch {
        ///         // Handle any thrown errors
        ///     }
        /// }
        /// ```
        ///
        /// - Parameters:
        ///   - data: The data to deserialize
        ///   - options: The options bitmask used to configure the deserialization process
        ///   - completionHandler: The closure used to handle the result of the asynchronous operation
        @available(macOS, deprecated: 12.0, obsoleted: 13.0)
        @available(iOS, deprecated: 15.0, obsoleted: 16.0)
        @available(watchOS, deprecated: 8.0, obsoleted: 9.0)
        @available(tvOS, deprecated: 15.0, obsoleted: 16.0)
        public static func deserialize(
            _ jsonString: String,
            options: Options = .default,
            completionHandler: @escaping (String, Result<JSON, any Swift.Error>) -> Void
        ) {
            DispatchQueue.global().async {
                let result: Result<JSON, any Swift.Error> = .init {
                    try parse(jsonString, maximumDepth: .max, options: options)
                }
                completionHandler(jsonString, result)
            }
        }

        // MARK: - Private

        private static func parse(
            _ data: Data,
            maximumDepth: Int,
            options: Options
        ) throws -> JSON {
            try data.withUnsafeBytes { buffer in
                let pointer = buffer.bindMemory(to: UInt8.self)
                var parser = Deserializer(input: pointer)
                parser.maximumDepth = maximumDepth
                parser.options = options
                return try parser.parse()
            }
        }

        private static func parse(
            _ jsonString: String,
            maximumDepth: Int,
            options: Options
        ) throws -> JSON {
            try jsonString.utf8CString.withUnsafeBufferPointer { nullTerminatedBuffer in
                try nullTerminatedBuffer.baseAddress!.withMemoryRebound(to: UInt8.self, capacity: nullTerminatedBuffer.count) { utf8Base in
                    let buffer = UnsafeBufferPointer(start: utf8Base, count: nullTerminatedBuffer.count - 1)
                    var parser = Deserializer(input: buffer)
                    parser.maximumDepth = maximumDepth
                    parser.options = options
                    return try parser.parse()
                }
            }
        }

        private init(input: UnsafeBufferPointer<UInt8>) {
            self.input = input
        }

        private var input: UnsafeBufferPointer<UInt8>
        private var maximumDepth = 0
        private var offset = 0
        private var depth = 0
        private var stringDecodingBuffer = [UInt8]()
        private var lineNumber = 0
        private var options = Options.default

        private mutating func parse() throws -> JSON {
            try assertEncoding([.utf8])
            if let first = input.first, !options.contains(.fragmentsAllowed) {
                guard first == .leftCurlyBracket else {
                    throw parseError(offset: 0)
                }
            }
            let value = try parseFromOffset()
            skipWhitespace()
            guard offset == input.count else {
                throw parseError(offset: offset)
            }
            return value
        }

        private mutating func parseFromOffset() throws -> JSON {
            guard depth <= 2048 else {
                throw Error("Maximum parse depth exceeded")
            }
            guard !input.isEmpty else {
                throw endOfStream()
            }

            advancing: while offset < input.count {
                do {
                    let character = input[offset]
                    switch character {
                    case .leftStraightBracket:
                        depth += 1
                        defer { depth -= 1 }
                        return try decodeArray()
                    case .leftCurlyBracket:
                        depth += 1
                        defer { depth -= 1 }
                        return try decodeObject()
                    case .doubleQuote:
                        return try decodeString()
                    case .t:
                        return try decodeTrue()
                    case .f:
                        return try decodeFalse()
                    case .n:
                        return try decodeNull()
                    case .minus:
                        return try decodeNumeric(.init(input: input, offset: offset, state: .leadingMinus))
                    case .zero:
                        return try decodeNumeric(.init(input: input, offset: offset, state: .leadingZero))
                    case .one ... .nine:
                        return try decodeNumeric(.init(input: input, offset: offset, state: .preDecimalDigit))
                    case .space, .tab, .return, .newLine:
                        skipWhitespace()
                    default:
                        break advancing
                    }
                } catch let CatchableError.overflow(start) {
                    return try decodeNumberAsString(from: start)
                }
            }
            if offset < input.count {
                throw parseError(offset: offset, character: input[offset])
            } else {
                throw endOfStream()
            }
        }

        private mutating func decodeArray() throws -> JSON {
            advance()
            var items = [JSON]()
            while offset < input.count {
                let character = input[offset]
                switch character {
                case .rightStraightBracket:
                    advance()
                    return .array(items)
                case .space, .tab, .return, .newLine:
                    skipWhitespace()
                case .comma:
                    advance()
                default:
                    let item = try parseFromOffset()
                    items.append(item)
                }
            }
            throw endOfStream()
        }

        private mutating func decodeObject() throws -> JSON {
            advance()
            var currentKey: String?
            var pairs = [(String, JSON)]()
            while offset < input.count {
                let character = input[offset]
                switch character {
                case .rightCurlyBracket:
                    advance()
                    let dict: [String: JSON] = pairs.reduce([:]) { dict, pair in
                        var next = dict
                        let (key, value) = pair
                        next[key] = value
                        return next
                    }
                    if options.contains(.nullSkipsKey) {
                        return .object(dict.filter { pair in
                            let (_, value) = pair
                            return value != .literal(.null)
                        })
                    } else {
                        return .object(dict)
                    }
                case .space, .tab, .return, .newLine:
                    skipWhitespace()
                case .colon:
                    guard let currentKey else {
                        throw parseError(offset: offset, character: character)
                    }
                    advance()
                    let json = try parseFromOffset()
                    pairs.append((currentKey, json))
                case .comma:
                    guard currentKey != nil else {
                        throw parseError(offset: offset, character: character)
                    }
                    currentKey = nil
                    advance()
                case .doubleQuote:
                    guard currentKey == nil else {
                        throw parseError(offset: offset, character: character)
                    }
                    currentKey = try decodeString().stringValue
                default:
                    throw parseError(offset: offset, character: character)
                }
            }
            throw endOfStream()
        }

        private mutating func decodeTrue() throws -> JSON {
            guard input.index(offset, offsetBy: 3, limitedBy: input.count) != input.count else {
                throw endOfStream()
            }

            try [
                (0, .t),
                (1, .r),
                (2, .u),
                (3, .e)
            ]
            .forEach { (stride: Int, character: UInt8) in
                guard input[offset + stride] == character else {
                    throw parseError(offset: offset, character: character)
                }
            }

            advance(by: 4)
            return .literal(.true)
        }

        private mutating func decodeFalse() throws -> JSON {
            guard input.index(offset, offsetBy: 4, limitedBy: input.count) != input.count else {
                throw endOfStream()
            }

            try [
                (0, .f),
                (1, .a),
                (2, .l),
                (3, .s),
                (4, .e)
            ]
            .forEach { (stride: Int, character: UInt8) in
                guard input[offset + stride] == character else {
                    throw parseError(offset: offset, character: character)
                }
            }

            advance(by: 5)
            return .literal(.false)
        }

        private mutating func decodeNull() throws -> JSON {
            guard input.index(offset, offsetBy: 3, limitedBy: input.count) != input.count else {
                throw endOfStream()
            }

            try [
                (0, .n),
                (1, .u),
                (2, .l),
                (3, .l)
            ]
            .forEach { (stride: Int, character: UInt8) in
                guard input[offset + stride] == character else {
                    throw parseError(offset: offset, character: character)
                }
            }

            advance(by: 4)
            return .literal(.null)
        }

        private mutating func decodeString() throws -> JSON {
            advance()
            stringDecodingBuffer.removeAll(keepingCapacity: true)
            advancing: while offset < input.count {
                let character = input[offset]
                switch character {
                case .backslash:
                    advance()
                    guard offset < input.count else {
                        throw endOfStream()
                    }
                    let character = input[offset]
                    switch character {
                    case .doubleQuote:
                        stringDecodingBuffer.append(.doubleQuote)
                        advance()
                    case .backslash:
                        stringDecodingBuffer.append(.backslash)
                        advance()
                    case .slash:
                        stringDecodingBuffer.append(.slash)
                        advance()
                    case .b:
                        stringDecodingBuffer.append(.backspace)
                        advance()
                    case .f:
                        stringDecodingBuffer.append(.formfeed)
                        advance()
                    case .r:
                        stringDecodingBuffer.append(.return)
                        advance()
                    case .t:
                        stringDecodingBuffer.append(.tab)
                        advance()
                    case .n:
                        stringDecodingBuffer.append(.newLine)
                        advance()
                    case .u:
                        advance()
                        var unicodeParser = UnicodeEscapeParser(input: input, offset: offset)
                        try unicodeParser.parse(into: &stringDecodingBuffer)
                        move(to: unicodeParser.offset)
                    default:
                        throw parseError("Invalid escape", offset: offset, character: character)
                    }
                case .doubleQuote:
                    advance()
                    stringDecodingBuffer.append(0)
                    break advancing
                case let other:
                    stringDecodingBuffer.append(other)
                    advance()
                }
            }
            let string = stringDecodingBuffer.withUnsafeBufferPointer { pointer in
                String(cString: UnsafePointer(pointer.baseAddress!))
            }
            return .string(string)
        }

        private mutating func decodeNumeric(_ parser: NumberParser) throws -> JSON {
            var sign: Int = .postive
            var parser = parser
            var value = 0
            while parser.state != .complete {
                switch parser.state {
                case .leadingMinus:
                    sign = .negative
                    try parser.leadingMinus()
                case .leadingZero:
                    parser.leadingZero()
                case .preDecimalDigit:
                    let start = parser.start
                    try parser.preDecimalDigit { character in
                        guard case (let exponent, false) = 10.multipliedReportingOverflow(by: value) else {
                            throw CatchableError.overflow(start)
                        }
                        guard case (let newValue, false) = exponent.addingReportingOverflow(Int(character - .zero)) else {
                            throw CatchableError.overflow(start)
                        }
                        value = newValue
                    }
                case .decimalPoint, .exponentLetter:
                    return try detectFloatingPointErrors(start: parser.start) {
                        try decodeFloatingPointValue(parser, sign: sign, value: Double(value))
                    }

                case .postDecimalDigit, .exponentSign, .exponentDigit, .complete:
                    fatalError("Invalid JSON Parser State")
                }
            }

            guard case (let signedValue, false) = sign.multipliedReportingOverflow(by: value) else {
                throw CatchableError.overflow(parser.start)
            }

            move(to: parser.offset)
            return .number(.int(signedValue))
        }

        private mutating func decodeFloatingPointValue(_ parser: NumberParser, sign: Int, value: Double) throws -> JSON {
            var parser = parser
            var value = value
            var exponentSign: Int = .postive
            var exponent = Double(0)
            var decimalPlace = 0.1
            while parser.state != .complete {
                switch parser.state {
                case .leadingMinus, .leadingZero, .preDecimalDigit:
                    fatalError("Invalid JSON Parser State")
                case .decimalPoint:
                    try parser.decimalPoint()
                case .postDecimalDigit:
                    parser.postDecimalDigit { character in
                        value += decimalPlace * Double(character - .zero)
                        decimalPlace /= 10
                    }
                case .exponentLetter:
                    exponentSign = try parser.exponentLetter()
                case .exponentSign:
                    try parser.exponentSign()
                case .exponentDigit:
                    parser.exponentDigit { character in
                        exponent = exponent * 10 + Double(character - .zero)
                    }
                case .complete:
                    fatalError("Invalid JSON Parser State")
                }
            }

            move(to: parser.offset)
            return .number(.double(Double(sign) * value * pow(10, Double(exponentSign) * exponent)))
        }

        private mutating func decodeNumberAsString(from offset: Int) throws -> JSON {
            var parser = {
                let state: NumberParser.State
                switch input[offset] {
                case .minus: state = .leadingMinus
                case .zero: state = .leadingZero
                case .one ... .nine: state = .preDecimalDigit
                default:
                    fatalError("Invalid JSON Parser State")
                }
                return NumberParser(input: input, offset: offset, state: state)
            }()

            stringDecodingBuffer.removeAll(keepingCapacity: true)

            while true {
                switch parser.state {
                case .leadingMinus:
                    try parser.leadingMinus()
                    stringDecodingBuffer.append(.minus)
                case .leadingZero:
                    parser.leadingZero()
                    stringDecodingBuffer.append(.zero)
                case .preDecimalDigit:
                    parser.preDecimalDigit { character in
                        stringDecodingBuffer.append(character)
                    }
                case .decimalPoint:
                    try parser.decimalPoint()
                    stringDecodingBuffer.append(.period)
                case .postDecimalDigit:
                    parser.postDecimalDigit { character in
                        stringDecodingBuffer.append(character)
                    }
                case .exponentLetter:
                    stringDecodingBuffer.append(input[parser.offset])
                    _ = try parser.exponentLetter()
                case .exponentSign:
                    stringDecodingBuffer.append(input[parser.offset])
                    try parser.exponentSign()
                case .exponentDigit:
                    parser.exponentDigit { character in
                        stringDecodingBuffer.append(character)
                    }
                case .complete:
                    stringDecodingBuffer.append(0)
                    let string = stringDecodingBuffer.withUnsafeBufferPointer { pointer in
                        String(cString: UnsafePointer(pointer.baseAddress!))
                    }

                    move(to: parser.offset)
                    return .string(string)
                }
            }
        }

        private mutating func advance(by n: Int = 1, reason: StaticString = #function) {
            offset += n
        }

        private mutating func move(to offset: Int) {
            self.offset = offset
        }

        private mutating func assertEncoding(_ encodings: [EncodingDetector.Encoding]) throws {
            let header = input.prefix(4)
            let encodingPrefixInformation = EncodingDetector.detectEncoding(header)
            guard encodings.contains(encodingPrefixInformation.encoding) else {
                throw Error("Unsupported string encoding")
            }
            offset = offset.advanced(by: encodingPrefixInformation.byteOrderMarkLength)
        }

        private mutating func skipWhitespace() {
            while offset < input.count {
                let character = input[offset]
                switch character {
                case .space, .tab:
                    advance()
                case .return, .newLine:
                    lineNumber += 1
                    advance()
                default:
                    return
                }
            }
        }
    }
}

private func detectFloatingPointErrors<T>(
    start: Int,
    in operation: () throws -> T
) throws -> T {
    let flags: Int32 = FE_UNDERFLOW | FE_OVERFLOW
    feclearexcept(flags)
    let value = try operation()
    guard fetestexcept(flags) == 0 else {
        throw CatchableError.overflow(start)
    }
    return value
}

private enum CatchableError: Swift.Error {
    case overflow(Int)
}

func parseError(
    _ title: String? = nil,
    offset: Int,
    character: UInt8? = nil,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line,
    column: UInt = #column
) -> any Error {
    let message: String
    if let character,
       let str = String(bytes: [character], encoding: .utf8) {
        message = "Unexpected \(str) at offset \(offset)"
    } else {
        message = "Unexpected character at offset \(offset)"
    }
    if let title {
        let full = [title, message.lowercased()].joined(separator: " - ")
        return JSON.Error(full, file: file, function: function, line: line, column: column)
    } else {
        return JSON.Error(message, file: file, function: function, line: line, column: column)
    }
}

func endOfStream(
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line,
    column: UInt = #column
) -> any Error {
    JSON.Error("Unexpected end of stream", file: file, function: function, line: line, column: column)
}
