// Athena
// UnicodeEscapeParser.swift
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

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
struct UnicodeEscapeParser {

    // MARK: - Initializer

    init(
        input: UnsafeBufferPointer<UInt8>,
        offset: Int
    ) {
        self.input = input
        self.offset = offset
    }

    // MARK: - API

    private(set) var offset: Int

    mutating func parse(into buffer: inout [UInt8]) throws {
        func readCodeUnit() -> UInt16? {
            guard offset + 4 <= input.count else {
                return nil
            }
            var unit: UInt16 = 0
            for character in input[offset ..< offset + 4] {
                let nibble: UInt16

                switch character {
                case .zero ... .nine:
                    nibble = UInt16(character - .zero)

                case .a ... .f:
                    nibble = 10 + UInt16(character - .a)

                case .A ... .F:
                    nibble = 10 + UInt16(character - .A)

                default:
                    return nil
                }
                unit = (unit << 4) | nibble
            }
            advance(by: 4)
            return unit
        }

        guard let codeUnit = readCodeUnit() else {
            throw parseError("Invalid unicode escape", offset: offset, character: input[offset])
        }

        let codeUnits: [UInt16]

        if UTF16.isLeadSurrogate(codeUnit) {
            // First half of a UTF16 surrogate pair - we must parse another code unit and combine them

            // First confirm and skip over that we have another "\u"
            guard input.index(offset, offsetBy: 6, limitedBy: input.count) != input.count,
                  input[offset] == .backslash,
                  input[offset + 1] == .u else {
                throw parseError("Invalid unicode escaoe", offset: offset)
            }
            advance(by: 2)

            // Ensure the second code unit is valid for the surrogate pair
            guard let secondCodeUnit = readCodeUnit(),
                  UTF16.isTrailSurrogate(secondCodeUnit) else {
                throw parseError("Invalid unicode escaoe", offset: offset)
            }

            codeUnits = [codeUnit, secondCodeUnit]
        } else {
            codeUnits = [codeUnit]
        }

        let transcodeHadError = transcode(codeUnits.makeIterator(), from: UTF16.self, to: UTF8.self, stoppingOnError: true) { (outputEncodingCodeUnit) in
            buffer.append(outputEncodingCodeUnit)
        }

        if transcodeHadError {
            throw parseError("Invalid unicode escaoe", offset: offset)
        }
    }

    // MARK: - Private

    private let input: UnsafeBufferPointer<UInt8>

    private mutating func advance(by n: Int = 1) {
        offset += n
    }
}
