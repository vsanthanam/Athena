// Athena
// UInt8Extensions.swift
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
extension UInt8 {
    static let backslash = UInt8(ascii: "\\")
    static let backspace = UInt8(ascii: "\u{0008}")
    static let colon = UInt8(ascii: ":")
    static let comma = UInt8(ascii: ",")
    static let doubleQuote = UInt8(ascii: "\"")
    static let formfeed = UInt8(ascii: "\u{000c}")
    static let leftCurlyBracket = UInt8(ascii: "{")
    static let leftStraightBracket = UInt8(ascii: "[")
    static let minus = UInt8(ascii: "-")
    static let newLine = UInt8(ascii: "\n")
    static let period = UInt8(ascii: ".")
    static let plus = UInt8(ascii: "+")
    static let `return` = UInt8(ascii: "\r")
    static let rightCurlyBracket = UInt8(ascii: "}")
    static let rightStraightBracket = UInt8(ascii: "]")
    static let slash = UInt8(ascii: "/")
    static let space = UInt8(ascii: " ")
    static let tab = UInt8(ascii: "\t")

    static let a = UInt8(ascii: "a")
    static let b = UInt8(ascii: "b")
    static let c = UInt8(ascii: "c")
    static let d = UInt8(ascii: "d")
    static let e = UInt8(ascii: "e")
    static let f = UInt8(ascii: "f")
    static let l = UInt8(ascii: "l")
    static let n = UInt8(ascii: "n")
    static let r = UInt8(ascii: "r")
    static let s = UInt8(ascii: "s")
    static let t = UInt8(ascii: "t")
    static let u = UInt8(ascii: "u")

    static let A = UInt8(ascii: "A")
    static let B = UInt8(ascii: "B")
    static let C = UInt8(ascii: "C")
    static let D = UInt8(ascii: "D")
    static let E = UInt8(ascii: "E")
    static let F = UInt8(ascii: "F")

    static let zero = UInt8(ascii: "0")
    static let one = UInt8(ascii: "1")
    static let two = UInt8(ascii: "2")
    static let three = UInt8(ascii: "3")
    static let four = UInt8(ascii: "4")
    static let five = UInt8(ascii: "5")
    static let six = UInt8(ascii: "6")
    static let seven = UInt8(ascii: "7")
    static let eight = UInt8(ascii: "8")
    static let nine = UInt8(ascii: "9")
}
