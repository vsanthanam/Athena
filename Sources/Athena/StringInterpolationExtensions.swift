// Athena
// StringInterpolationExtensions.swift
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

public extension String.StringInterpolation {

    /// Interpolate a ``JSONEncodable`` value using its raw json representation
    ///
    /// ```swift
    /// import Athena
    ///
    /// struct Car: Codable, JSONCodable {
    ///     let make: String
    ///     let model: String
    ///     let year: Int
    /// }
    ///
    /// let m3 = Car(make: "BMW", model: "M3 Competition", year: 2014)
    ///
    /// let interpolated = "The car is \(json: car)"
    /// print(interpolated)
    /// // Would print "The car is {make: "BMW", model: "M3 Competition", year: 2014}"
    /// ```
    /// - Parameter value: The ``JSONEncodable`` conforming type you want to interpolate
    mutating func appendInterpolation<T>(json value: T) where T: JSONEncodable {
        let json = JSON(value)
        let str = String(escaping: json, pretty: false)
        appendInterpolation(str)
    }

}
