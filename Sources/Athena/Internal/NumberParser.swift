// Athena
// NumberParser.swift
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
struct NumberParser {

    // MARK: - Initializers

    init(
        input: UnsafeBufferPointer<UInt8>,
        offset: Int,
        state: State
    ) {
        assert(offset < input.count)
        start = offset
        self.input = input
        self.offset = offset
        self.state = state
    }

    // MARK: - API

    enum State {
        case leadingMinus
        case leadingZero
        case preDecimalDigit
        case decimalPoint
        case postDecimalDigit
        case exponentLetter
        case exponentSign
        case exponentDigit
        case complete
    }

    let start: Int
    private(set) var offset: Int
    private(set) var state: State

    mutating func leadingMinus() throws {
        assert(state == .leadingMinus)
        advance()
        guard offset < input.count else {
            throw endOfStream()
        }
        let character = input[offset]
        switch character {
        case .zero:
            state = .leadingZero
        case .one ... .nine:
            state = .preDecimalDigit
        default:
            throw parseError(offset: offset, character: character)
        }
    }

    mutating func leadingZero() {
        assert(state == .leadingZero)
        advance()
        guard offset < input.count else {
            state = .complete
            return
        }

        let character = input[offset]
        switch character {
        case .period:
            state = .decimalPoint
        case .e, .E:
            state = .exponentLetter
        default:
            state = .complete
        }
    }

    mutating func preDecimalDigit(_ operation: (UInt8) throws -> Void) rethrows {
        assert(state == .preDecimalDigit)
        advancing: while offset < input.count {
            let character = input[offset]
            switch character {
            case .zero ... .nine:
                try operation(character)
                advance()
            case .period:
                state = .decimalPoint
                return
            case .e, .E:
                state = .exponentLetter
                return
            default:
                break advancing
            }
        }

        state = .complete
    }

    mutating func decimalPoint() throws {
        assert(state == .decimalPoint)
        advance()
        guard offset < input.count else {
            throw endOfStream()
        }
        let character = input[offset]
        switch character {
        case .zero ... .nine:
            state = .postDecimalDigit
        default:
            throw parseError(offset: offset, character: character)
        }
    }

    mutating func postDecimalDigit(_ operation: (UInt8) throws -> Void) rethrows {
        assert(state == .postDecimalDigit, "Unexpected state entering parsePostDecimalDigits")
        advancing: while offset < input.count {
            let character = input[offset]
            switch character {
            case .zero ... .nine:
                try operation(character)
                advance()
            case .e, .E:
                state = .exponentLetter
                return
            default:
                break advancing
            }
        }

        state = .complete
    }

    mutating func exponentLetter() throws -> Int {
        assert(state == .exponentLetter)
        advance()
        guard offset < input.count else {
            throw endOfStream()
        }

        let character = input[offset]
        switch character {
        case .zero ... .nine:
            state = .exponentDigit
        case .plus:
            state = .exponentSign
        case .minus:
            state = .exponentSign
            return .negative
        default:
            throw parseError(offset: offset, character: character)
        }
        return .postive
    }

    mutating func exponentSign() throws {
        assert(state == .exponentSign)
        advance()

        guard offset < input.count else {
            throw endOfStream()
        }

        let character = input[offset]
        switch character {
        case .zero ... .nine:
            state = .exponentDigit
        default:
            throw parseError(offset: offset, character: character)
        }
    }

    mutating func exponentDigit(
        _ operation: (UInt8) throws -> Void
    ) rethrows {
        assert(state == .exponentDigit)
        advancing: while offset < input.count {
            let character = input[offset]
            switch character {
            case .zero ... .nine:
                try operation(character)
                advance()
            default:
                break advancing
            }
        }

        state = .complete
    }

    // MARK: - Private

    private let input: UnsafeBufferPointer<UInt8>

    private mutating func advance(by n: Int = 1) {
        offset += n
    }
}
