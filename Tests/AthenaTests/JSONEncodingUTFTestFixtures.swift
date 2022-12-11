// Athena
// JSONEncodingUTFTestFixtures.swift
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

import Athena
import Foundation

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
struct JSONEncodingUTFTestFixtures {

    func hexArray(_ encoding: JSON.EncodingDetector.Encoding, includeBOM: Bool) -> [UInt8] {
        switch encoding {
        case .utf8:
            return includeBOM ? utf8BOM + utf8Hex : utf8Hex
        case .utf16LE:
            return includeBOM ? utf16LEBOM + utf16LEHex : utf16LEHex
        case .utf16BE:
            return includeBOM ? utf16BEBOM + utf16BEHex : utf16BEHex
        case .utf32LE:
            return includeBOM ? utf32LEBOM + utf32LEHex : utf32LEHex
        case .utf32BE:
            return includeBOM ? utf32BEBOM + utf32BEHex : utf32BEHex
        }
    }

    #if swift(>=3.3)
        public typealias PrefixSlice = Slice<UnsafeBufferPointer<UInt8>>
    #else
        public typealias PrefixSlice = RandomAccessSlice<UnsafeBufferPointer<UInt8>>
    #endif

    func withPrefixSlice<R>(_ encoding: JSON.EncodingDetector.Encoding, includeBOM: Bool, body: (PrefixSlice) throws -> R) rethrows -> R {
        let array = hexArray(encoding, includeBOM: includeBOM)
        return try array.withUnsafeBufferPointer {
            try body($0.prefix(4))
        }
    }

    // MARK: - UTF16

    // String literal representation "{\"u\":16}"
    private let utf16LEHex: [UInt8] = [
        0x7B, 0x0,
        0x22, 0x0,
        0x75, 0x0,
        0x22, 0x0,
        0x3A, 0x0,
        0x31, 0x0,
        0x36, 0x0,
        0x7D, 0x0
    ]

    private let utf16LEBOM: [UInt8] = [
        0xFF,
        0xFE
    ]

    // String literal representation "{\"u\":16}"
    private let utf16BEHex: [UInt8] = [
        0x00, 0x7B,
        0x00, 0x22,
        0x00, 0x75,
        0x00, 0x22,
        0x00, 0x3A,
        0x00, 0x31,
        0x00, 0x36,
        0x00, 0x7D
    ]

    private let utf16BEBOM: [UInt8] = [
        0xFE,
        0xFF
    ]

    // MARK: - UTF32

    // String literal representation "{\"u\":32}"
    private let utf32LEHex: [UInt8] = [
        0x7B, 0x00, 0x00, 0x00,
        0x22, 0x00, 0x00, 0x00,
        0x75, 0x00, 0x00, 0x00,
        0x22, 0x00, 0x00, 0x00,
        0x3A, 0x00, 0x00, 0x00,
        0x33, 0x00, 0x00, 0x00,
        0x32, 0x00, 0x00, 0x00,
        0x7D, 0x00, 0x00, 0x00
    ]

    private let utf32LEBOM: [UInt8] = [
        0xFF,
        0xFE,
        0x00,
        0x00
    ]

    // String literal representation "{\"u\":32}"
    private let utf32BEHex: [UInt8] = [
        0x00, 0x00, 0x00, 0x7B,
        0x00, 0x00, 0x00, 0x22,
        0x00, 0x00, 0x00, 0x75,
        0x00, 0x00, 0x00, 0x22,
        0x00, 0x00, 0x00, 0x3A,
        0x00, 0x00, 0x00, 0x33,
        0x00, 0x00, 0x00, 0x32,
        0x00, 0x00, 0x00, 0x7D
    ]

    private let utf32BEBOM: [UInt8] = [
        0x00,
        0x00,
        0xFE,
        0xFF
    ]

    // MARK: - UTF8

    // String literal representation "{\"u\":8}"
    private let utf8Hex: [UInt8] = [
        0x7B,
        0x22,
        0x75,
        0x22,
        0x3A,
        0x38,
        0x7D
    ]

    private let utf8BOM: [UInt8] = [
        0xEF,
        0xBB,
        0xBF
    ]
}
