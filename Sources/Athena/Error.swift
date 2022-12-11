// Athena
// Error.swift
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

    /// An error produced when creating, subscripting, traversing, parsing, encoding, decoding or serializing ``JSON`` types
    struct Error: LocalizedError, CustomNSError, Equatable, Hashable, Sendable, CustomStringConvertible, CustomDebugStringConvertible {

        // MARK: - API

        /// Possible error codes in a ``JSON/Error``
        public enum Code: Int {

            /// An unknown error
            case unknown = 0

            /// An error from deserializing `UTF-8` encoded data into ``JSON``
            case parse = 1

            /// An error from encoding ``JSON`` into a Swift type
            case encoding = 2

            /// An error form decodeing a Swift type into ``JSON``
            case decoding = 3

            /// An error when casting a JSON node into a Swift type
            case casting = 4

            /// An error when attempting to subscript a ``JSON`` value
            case `subscript` = 5

            /// An error when the parser's maximum parsing depth has been exceeded.
            case depthExceeded = 6
        }

        // MARK: - LocalizedError

        public var errorDescription: String? {
            message
        }

        // MARK: - CustomNSError

        public let errorCode: Int

        public var errorUserInfo: [String: Any] {
            [
                "message": message,
                "callsite": callsite,
                "code": errorCode
            ]
        }

        public static let errorDomain: String = "com.athena.json"

        // MARK: - CustomStringConvertible

        public var description: String {
            message
        }

        // MARK: - CustomDebugStringConvertible

        public var debugDescription: String {
            [callsite, message].joined(separator: " - ")
        }

        // MARK: - Equatable

        public static func == (lhs: JSON.Error, rhs: JSON.Error) -> Bool {
            lhs.message == rhs.message
                && lhs.file.description == rhs.file.description
                && lhs.function.description == rhs.function.description
                && lhs.line == rhs.line
                && lhs.column == rhs.column
        }

        // MARK: - Hashable

        public func hash(into hasher: inout Hasher) {
            hasher.combine(message)
            hasher.combine(file.description)
            hasher.combine(function.description)
            hasher.combine(line)
            hasher.combine(column)
        }

        // MARK: - Private

        init(
            _ message: String? = nil,
            _ code: Code = .unknown,
            file: StaticString = #file,
            function: StaticString = #function,
            line: UInt = #line,
            column: UInt = #column
        ) {
            self.message = message ?? Error.defaultErrorMessage
            errorCode = code.rawValue
            self.file = file
            self.function = function
            self.line = line
            self.column = column
        }

        private static let defaultErrorMessage = "The operation couldn't be completed."

        private let message: String
        private let file: StaticString
        private let function: StaticString
        private let line: UInt
        private let column: UInt

        private var callsite: String {
            let contents: [Any] = [
                file,
                function,
                column,
                line
            ]

            return contents
                .map(String.init(describing:))
                .joined(separator: ":")
        }
    }
}
