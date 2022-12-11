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

public extension JSON {

    /// An error produced when working with JSON
    struct Error: LocalizedError, CustomNSError, Equatable, Hashable, Sendable, CustomStringConvertible, CustomDebugStringConvertible {

        // MARK: - API

        public enum Code: Int {
            case unknown = 0
            case parse = 1
            case encoding = 2
            case decoding = 3
            case casting = 4
            case `subscript` = 5
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

        public private(set) static var errorDomain: String = "com.athena.json"

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
            lhs.message == rhs.message && lhs.file.description == rhs.file.description && lhs.function.description == rhs.function.description && lhs.line == rhs.line && lhs.column == rhs.column
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
            _ message: String = "The operation couldn't be completed.",
            _ code: Code = .unknown,
            file: StaticString = #file,
            function: StaticString = #function,
            line: UInt = #line,
            column: UInt = #column
        ) {
            self.message = message
            errorCode = code.rawValue
            self.file = file
            self.function = function
            self.line = line
            self.column = column
        }

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
