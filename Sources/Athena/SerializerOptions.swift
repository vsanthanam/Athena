// Athena
// SerializerOptions.swift
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
public extension JSON.Serializer {

    /// A bitmask used to provide customization options when using the static interface of ``JSON/Serializer``
    struct Options: OptionSet {

        // MARK: - API

        /// Remove keys from objects with null values
        public static let nullSkipsKey = Options(rawValue: 1 << 0)

        /// Add pretty printing format to the string
        public static let prettyPrinted = Options(rawValue: 1 << 1)

        /// Sort the keys in an object
        public static let sortedKeys = Options(rawValue: 1 << 2)

        /// Allow fragments
        public static let fragmentsAllowed = Options(rawValue: 1 << 4)

        /// Remove escaping slashes
        @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
        public static let withoutEscapingSlashes = Options(rawValue: 1 << 5)

        /// The default options
        public static let `default`: Options = [.fragmentsAllowed]

        // MARK: - OptionSet

        /// Creates a new option set from the given raw value.
        ///
        /// This initializer always succeeds, even if the value passed as `rawValue`
        /// exceeds the static properties declared as part of the option set. This
        /// example creates an instance of `ShippingOptions` with a raw value beyond
        /// the highest element, with a bit mask that effectively contains all the
        /// declared static members.
        ///
        /// ```swift
        /// let extraOptions = ShippingOptions(rawValue: 255)
        /// print(extraOptions.isStrictSuperset(of: .all))
        /// // Prints "true"
        /// ```
        ///
        /// - Parameter rawValue: The raw value of the option set to create. Each bit
        ///   of `rawValue` potentially represents an element of the option set,
        ///   though raw values may include bits that are not defined as distinct
        ///   values of the `OptionSet` type.
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// The raw type that can be used to represent all values of the conforming
        /// type.
        ///
        /// Every distinct value of the conforming type has a corresponding unique
        /// value of the `RawValue` type, but there may be values of the `RawValue`
        /// type that don't have a corresponding value of the conforming type.
        public typealias RawValue = Int

        /// The corresponding value of the raw type.
        ///
        /// A new instance initialized with `rawValue` will be equivalent to this
        /// instance. For example:
        ///
        /// ```swift
        /// enum PaperSize: String {
        ///     case A4, A5, Letter, Legal
        /// }
        ///
        /// let selectedSize = PaperSize.Letter
        /// print(selectedSize.rawValue)
        /// // Prints "Letter"
        ///
        /// print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
        /// // Prints "true"
        /// ```
        public let rawValue: RawValue

    }

}
