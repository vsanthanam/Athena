// Athena
// EncodeDecodeTests.swift
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
import Foundation
import XCTest

final class EncodeDecodeTests: XCTestCase {

    struct TestStruct: JSONCodable, Equatable, Hashable {

        init(prop: String,
             list: [Int],
             op: String?,
             nest: Nest) {
            self.prop = prop
            self.list = list
            self.op = op
            self.nest = nest
        }

        init(json: JSON) throws {
            prop = try json["prop"].decode()
            list = try json["list"].decode()
            op = try json["op"].decode()
            nest = try json["nest"].decode()
        }

        let prop: String
        let list: [Int]
        let op: String?
        let nest: Nest

        struct Nest: JSONCodable, Equatable, Hashable {

            init(double: Double) {
                self.double = double
            }

            init(json: JSON) throws {
                double = try json["double"].decode()
            }

            let double: Double

            func toJSON() -> JSON {
                [
                    "double": JSON(double)
                ]
            }
        }

        func toJSON() -> JSON {
            [
                "prop": prop.toJSON(),
                "list": list.toJSON(),
                "op": op.toJSON(),
                "nest": nest.toJSON()
            ]
        }
    }

    func test_sync() {
        let test = TestStruct(prop: "value", list: [1, 2, 3], op: nil, nest: .init(double: 4.2))

        let expected: JSON = [
            "prop": "value",
            "list": [1, 2, 3],
            "op": nil,
            "nest": [
                "double": 4.2
            ]
        ]

        let encoded = test.toJSON()

        XCTAssertEqual(expected, encoded)
        let decoded = try! encoded.decode(TestStruct.self)
        XCTAssertEqual(decoded, test)

        let int = try! encoded["list"][1].decode(Int.self)
        XCTAssertEqual(int, 2)
    }

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func test_async() async {
        let test = TestStruct(prop: "value", list: [1, 2, 3], op: nil, nest: .init(double: 4.2))

        let expected: JSON = [
            "prop": "value",
            "list": [1, 2, 3],
            "op": nil,
            "nest": [
                "double": 4.2
            ]
        ]

        let encoded = test.toJSON()

        XCTAssertEqual(expected, encoded)
        let decoded = try! await JSON.Decoder.decode(TestStruct.self, from: encoded)
        XCTAssertEqual(decoded, test)

        let json = encoded["list"][1]
        let int: Int = try! await JSON.Decoder.decode(from: json)
        XCTAssertEqual(int, 2)
    }

    func test_auto_implementation_through_codable() {

        struct Person: Codable, JSONCodable, Equatable, Hashable {
            let age: Int
            let firstName: String
            let lastName: String
            let favoriteColors: [String]
            let optionalString: String?
            let home: Home
            let secondHome: Home?

            struct Home: Codable, JSONCodable, Equatable, Hashable {
                let address: String
            }
        }

        let person = Person(age: 32, firstName: "Varun", lastName: "Santhanam", favoriteColors: ["purple", "black"], optionalString: "whoops", home: .init(address: "addr"), secondHome: nil)

        let expected: JSON = [
            "age": 32,
            "firstName": "Varun",
            "lastName": "Santhanam",
            "favoriteColors": ["purple", "black"],
            "optionalString": "whoops",
            "home": [
                "address": "addr",
            ]
        ]

        let encoded = JSON(person)

        XCTAssertEqual(encoded, expected)
        let decoded = try! encoded.decode(Person.self)
        XCTAssertEqual(person, decoded)
    }
}
