// Athena
// NumberDecodable.swift
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

/// A type that can decode itself from an external ``JSON/Number`` representation.
///
/// You need not implement this protocol yourself.
/// 
/// Athena includes conformance to ``NumberDecodable`` for the following Swift types:
///  - `Int`
///  - `Double`
///  - `String`
///  - `Bool`
@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
public protocol NumberDecodable {

    /// Initialize an instance using a ``JSON/Number`` value
    ///
    /// This initializer should be used to produce an instance based on the provided ``JSON/Number``.
    /// If the provided ``JSON/Number`` is shaped incorrectly or missing data necessary to initialize an instance, it should throw an error.
    ///
    /// - Parameter json: The ``JSON/Number`` value to decode into `Self`
    /// - Throws: An error if an instance cannot be decoded from the provided ``JSON/Number``
    init(jsonNumber: JSON.Number) throws
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Int: NumberDecodable {
    public init(jsonNumber: JSON.Number) throws {
        switch jsonNumber {
        case let .int(int):
            self = int
        case let .double(double):
            guard double.truncatingRemainder(dividingBy: 1) == 0 else {
                throw JSON.Error()
            }
            self = Int(double)
        }
    }

}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Double: NumberDecodable {
    public init(jsonNumber: JSON.Number) throws {
        switch jsonNumber {
        case let .int(int):
            self = Double(int)
        case let .double(double):
            self = Double(double)
        }
    }
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension String: NumberDecodable {
    public init(jsonNumber: JSON.Number) throws {
        switch jsonNumber {
        case let .int(int):
            self = String(int)
        case let .double(double):
            self = String(double)
        }
    }
}

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
extension Bool: NumberDecodable {
    public init(jsonNumber: JSON.Number) throws {
        switch jsonNumber {
        case let .int(int):
            switch int {
            case 0:
                self = false
            case 1:
                self = true
            default:
                throw JSON.Error()
            }
        case .double:
            throw JSON.Error()
        }
    }
}
