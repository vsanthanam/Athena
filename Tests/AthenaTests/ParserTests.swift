// Athena
// ParserTests.swift
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

@testable import Athena
import XCTest

@available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *)
final class ParserTests: XCTestCase {

    func test_parser_throws_an_error_for_an_empty_data() {
        do {
            _ = try JSON.Parser.parse("")
            XCTFail("Unexpectedly did not throw an error")
        } catch {
            print(error)
        }
    }

    func test_parser_throws_error_for_insufficient_data() {
        let hex: [UInt8] = [0x7B]
        let data = Data(bytes: hex, count: hex.count)

        do {
            let json = try JSON.Parser.parse(data)
            print(json)
            XCTFail("Unexpectedly did not throw an error")
        } catch {
            print(error)
        }
    }

    func test_parser_completes_with_single_zero() {
        guard let data = "0".data(using: String.Encoding.utf8) else {
            XCTFail("Cannot create data from string")
            return
        }

        do {
            let json = try JSON.Parser.parse(data)
            guard case let .int(int) = json else {
                XCTFail("fiero")
                return
            }
            XCTAssertEqual(int, 0)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func test_parser_completes_with_bom_and_single_zero() {
        let hex: [UInt8] = [0xEF, 0xBB, 0xBF, 0x30]
        let data = Data(bytes: hex, count: hex.count)

        do {
            _ = try JSON.Parser.parse(data)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func test_parser_understands_null() {
        let value = try! JSON.Parser.parse("null")
        XCTAssertEqual(value, .null)
    }

    func test_parser_skips_leading_whitespace() {
        let value = try! JSON.Parser.parse("   \t\r\nnull")
        XCTAssertEqual(value, .null)
    }

    func test_parser_allows_trailing_whitespace() {
        let value = try! JSON.Parser.parse("null   ")
        XCTAssertEqual(value, .null)
    }

    func test_parser_fails_when_trailing_data_is_present() {
        do {
            _ = try JSON.Parser.parse("null   true")
            XCTFail()
        } catch {
            print(error)
        }
    }

    func test_parser_understands_true() {
        let value = try! JSON.Parser.parse("true")
        XCTAssertEqual(value, .bool(true))
    }

    func test_parser_understands_false() {
        let value = try! JSON.Parser.parse("false")
        XCTAssertEqual(value, .bool(false))
    }

    func test_parser_understands_strings_without_escapes() {
        let string = "a b c d 😀 x y z"
        let value = try! JSON.Parser.parse("\"\(string)\"")
        XCTAssertEqual(value, .string(string))
    }

    func test_parser_understands_strings_with_escaped_characters() {
        let expect = " \" \\ / \n \r \t \u{000c} \u{0008} "

        let value = try! JSON.Parser.parse("\" \\\" \\\\ \\/ \\n \\r \\t \\f \\b \"")
        XCTAssertEqual(value, .string(expect))
    }

    func test_parser_understands_strings_with_escaped_unicode() {
        // try 1-, 2-, and 3-byte UTF8 sequences
        let value = try! JSON.Parser.parse("\"\\u0060\\u012a\\u12AB\"")
        XCTAssertEqual(value, "\u{0060}\u{012a}\u{12AB}")
    }

    func test_parser_fails_when_incomplete_data_is_present() {
        for s in [" ", "[0,", "{\"\":"] {
            do {
                let value = try JSON.Parser.parse(s)
                XCTFail("Unexpectedly parsed \(s) as \(value)")
            } catch {
                print(error)
            }
        }
    }

    func test_parser_understands_numbers() {
        for (string, shouldBeInt) in [
            ("  0  ", 0),
            ("123", 123),
            ("  -20  ", -20),
            ("-0", 0),
            ("0e0", 0),
            ("0e1", 0),
            ("0e1", 0),
            ("-0e20", 0),
            ("0.1e1", 1),
            ("0.1E1", 1),
            ("0e01", 0),
            ("0.1e0001", 1),
        ] {
            do {
                let value = try JSON.Parser.parse(string).decode(type: Int.self)
                XCTAssertEqual(value, shouldBeInt)
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }

        for (string, shouldBeDouble) in [
            ("  -0  ", -0.0),
            ("  -0.0  ", 0.0),
            ("123.0", 123.0),
            ("123.456", 123.456),
            ("-123.456", -123.456),
            ("123e2", 123e2),
            ("123.45E2", 123.45e2),
            ("123.45e+2", 123.45e+2),
            ("-123.45e-2", -123.45e-2),
            ("0.1e-1", 0.01),
            ("-0.1E-1", -0.01),
            ("1472861857112", 1_472_861_857_112),
        ] {
            do {
                let value = try JSON.Parser.parse(string).decode(type: Double.self)
                XCTAssertEqual(value, shouldBeDouble, accuracy: .ulpOfOne)
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func test_parser_rejects_invalid_numbers() {
        let numbers = [
            "012",
            "0.1.2",
            "-.123",
            ".123",
            "1.",
            "1.0e",
            "1.0e+",
            "1.0e-"
        ]

        for number in numbers {
            do {
                _ = try JSON.Parser.parse(number)
                XCTFail()
            } catch {
                return
            }
        }
    }

    func test_parser_number_overflow() {
        for string in [
            // Int64.max + 1
            "9223372036854775808",

            // DBL_MAX is 1.7976931348623158e+308, so add 1 to least significant
            "1.7976931348623159e+308",

            // DBL_TRUE_MIN is 4.9406564584124654E-324, so try something smaller
            "4.9406564584124654E-325",
        ] {
            do {
                let json = try JSON.Parser.parse(string)

                // numbers overflow, but we should be able to get them out as strings
                XCTAssertEqual(try? json.stringValue, string)
            } catch {
                XCTFail("Unexpected error \(error)")
            }
        }
    }

    func test_string_float_can_be_int() {
        // This integer cannot be represented on 32-bit
        let integerString = "4611686018427387901"
        let floatingPointString = "4611686018427387901.0"

        // Converting floatingPointString to a Double and then to an Int changes it's value due to Double imprecision

        let jsonString = "{\"floatingPointString\": \"\(floatingPointString)\"}"

        do {
            let json = try JSON.Parser.parse(jsonString)
            XCTAssertEqual(json["floatingPointString"], Int(integerString))
        } catch {
            XCTFail("Integer from floating point String does not match without loosing precision \(error)")
        }

    }

    func test_parser_understands_empty_array() {
        for string in ["[]", "[  ]", "  [  ]  "] {
            let value = try! JSON.Parser.parse(string)
            XCTAssertEqual(value, [])
        }
    }

    func test_parser_understands_single_item_array() {
        for (s, expect) in [
            (" [ null ] ", [JSON.null]),
            ("[true]", [JSON.bool(true)]),
            ("[ [\"nested\"]]", [JSON.array([.string("nested")])])
        ] {
            let value = try! JSON.Parser.parse(s)
            XCTAssertEqual(value, JSON.array(expect))
        }
    }

    func test_parser_understands_arrays() {
        let tests: [(String, JSON)] = [
            (" [ null   ,   \"foo\" ] ", [nil, "foo"]),
            ("[true,true,false]", [true, true, false]),
            ("[ [\"nested\",null], [[\"doubly\",true]]   ]", [["nested", nil], [["doubly", true]]])
        ]
        for (string, json) in tests {
            let value = try! JSON.Parser.parse(string)
            XCTAssertEqual(value, json)
        }
    }

    func test_parser_understands_empty_objects() {
        for string in ["{}", "  {   }  "] {
            let value = try! JSON.Parser.parse(string)
            XCTAssertEqual(value, [:])
        }
    }

    func test_parser_understands_single_item_objects() {
        let tests: [(String, JSON)] = [
            ("{\"a\":\"b\"}", ["a": "b"]),
            ("{  \"foo\"  :  [null]  }", ["foo": [nil]]),
            ("{  \"a\" : { \"b\": true }  }", ["a": ["b": true]]),
        ]
        for (string, json) in tests {
            let value = try! JSON.Parser.parse(string)
            XCTAssertEqual(value, json)
        }
    }

    func test_parser_understands_objects() {
        let tests: [(String, JSON)] = [
            ("{\"a\":\"b\",\"c\":\"d\"}", ["a": "b", "c": "d"]),
            ("{  \"foo\"  :  [null]   ,   \"bar\":  true  }", ["foo": [nil], "bar": true]),
            ("{  \"a\" : { \"b\": true }, \"c\": { \"x\" : true, \"y\": null }  }", ["a": ["b": true], "c": ["x": true, "y": nil]])
        ]

        for (string, json) in tests {
            let value = try! JSON.Parser.parse(string)
            XCTAssertEqual(value, json)
        }
    }

    func test_parser_fails_non_utf8() {

        let unsupportedEncodings: [JSON.EncodingDetector.Encoding] = [
            .utf16LE,
            .utf16BE,
            .utf32LE,
            .utf32BE
        ]
        let fixtures = JSONEncodingUTFTestFixtures()

        for encoding in unsupportedEncodings {
            let hex = fixtures.hexArray(encoding, includeBOM: false)
            let data = Data(bytes: hex, count: hex.count)
            let hexWithBOM = fixtures.hexArray(encoding, includeBOM: true)
            let dataWithBOM = Data(bytes: hexWithBOM, count: hexWithBOM.count)
            do {
                _ = try JSON.Parser.parse(data)
                _ = try JSON.Parser.parse(dataWithBOM)
                XCTFail("Unexpectedly did not throw an error")
            } catch {
                break
            }
        }
    }

    func test_parser_accepts_surrogate_pairs() {
        for (jsonString, expected) in [
            (#""\uD801\uDC37""#, "𐐷"),
            (#""\ud83d\ude39\ud83d\udc8d""#, "😹💍"),
            (#""😹💍""#, "😹💍"),
            (#""“""#, "“")
        ] {
            do {
                let json = try JSON.Parser.parse(jsonString)
                let decoded: String = try json.decode()
                XCTAssertEqual(decoded, expected)
            } catch {
                break
            }
        }
    }

    func test_invalid_surrogate_pairs() {
        for invalidPairString in [
            "\"\\ud800\\ud123\"",
            "\"\\ud800\"",
            "\"\\ud800abc\"",
        ] {
            do {
                _ = try JSON.Parser.parse(invalidPairString)
                XCTFail("Unexpectedly parsed invalid surrogate pair")
            } catch {
                break
            }
        }
    }

    func test_parser_rejects_string_ending_in_backslash() {
        let invalidJSONString = "[\"\\"
        do {
            _ = try JSON.Parser.parse(invalidJSONString)
            XCTFail("Unexpectedly parsed invalid unicode escape")
        } catch {
            print(error)
        }
    }
}
