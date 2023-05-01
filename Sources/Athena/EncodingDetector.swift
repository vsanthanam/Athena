// Athena
// EncodingDetector.swift
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
public extension JSON.Deserializer {

    /// A value type use to detect the string encoding of a provided data
    enum EncodingDetector {

        // MARK: - API

        /// The Unicode encodings looked for during detection
        public enum Encoding {

            /// UTF-8
            case utf8

            /// UTF-16 (Little Endian)
            case utf16LE

            /// UTF-16 (Big Endian)
            case utf16BE

            /// UTF-32 (Little Endian)
            case utf32LE

            /// UTF-32 (Big Endian)
            case utf32BE
        }

        /// A tuple containing a Uniciode encoding and the length of the BOM
        public typealias ByteStreamPrefixInformation = (encoding: Encoding, byteOrderMarkLength: Int)

        /// A typealias for byte stream prefix
        public typealias ByteStreamPrefix = Slice<UnsafeBufferPointer<UInt8>>

        /// Attempt to detect the unicode encoding of a provided `Data`
        ///
        /// This function initially looks for a Byte Order Mark in the following form:
        ///
        /// Bytes                    | Encoding
        /// ---------------------|---------------
        /// `00 00 FE FF` | UTF-32BE
        /// `FF FE 00 00` | UTF-32LE
        /// `FE FF`              | UTF-16BE
        /// `FF FE`              | UTF-16LE
        /// `EF BB BF`       | UTF-8
        ///
        /// If a BOM is not found, we instead use the detection approach described in [RFC 4627](http://www.ietf.org/rfc/rfc4627.txt)
        ///
        /// Since the first two characters of a JSON text will always be ASCII characters [RFC 0020](https://www.ietf.org/rfc/rfc0020.txt),
        /// it is possible to determine whether an octet stream is UTF-8, UTF-16 (BE or LE), or UTF-32 (BE or LE) by looking at the pattern of nulls in the first four octets using the following table
        ///
        /// First 4 Octets         | Encoding
        /// ----------------------|----------------
        /// `00 00 00 xx`  | UTF-32BE
        /// `00 xx 00 xx`  | UTF-16BE
        /// `xx 00 00 00`  | UTF-32LE
        /// `xx 00 xx 00`  | UTF-16LE
        /// `xx xx xx xx`  | UTF-8
        ///
        /// - Parameter header: The front Slice of data being read and evaluated.
        /// - Returns: A tuple containing the detected Uniciode encoding and the length of the BOM
        public static func detectEncoding(_ header: ByteStreamPrefix) -> ByteStreamPrefixInformation {
            guard let prefix = prefixFromHeader(header) else {
                return (.utf8, 0)
            }

            if let prefixInfo = encodingFromBOM(prefix) {
                return prefixInfo
            } else {
                switch prefix {
                case(0, 0, 0?, _):
                    return (.utf32BE, 0)
                case(_, 0, 0?, 0?):
                    return (.utf32LE, 0)
                case (0, _, 0?, _), (0, _, _, _):
                    return (.utf16BE, 0)
                case (_, 0, _, 0?), (_, 0, _, _):
                    return (.utf16LE, 0)
                default:
                    return (.utf8, 0)
                }
            }
        }

        // MARK: - Private

        private typealias EncodingBytePrefix = (UInt8, UInt8, UInt8?, UInt8?)

        private static func prefixFromHeader(_ header: ByteStreamPrefix) -> EncodingBytePrefix? {
            if header.count >= 4 {
                return (header[0], header[1], header[2], header[3])
            } else if header.count >= 2 {
                return (header[0], header[1], nil, nil)
            }
            return nil
        }

        private static func encodingFromBOM(_ prefix: EncodingBytePrefix) -> ByteStreamPrefixInformation? {
            switch prefix {
            case(0xFE, 0xFF, _, _):
                return (.utf16BE, 2)
            case(0x00, 0x00, 0xFE?, 0xFF?):
                return (.utf32BE, 4)
            case(0xEF, 0xBB, 0xBF?, _):
                return (.utf8, 3)
            case(0xFF, 0xFE, 0?, 0?):
                return (.utf32LE, 4)
            case(0xFF, 0xFE, _, _):
                return (.utf16LE, 2)
            default:
                return nil
            }
        }
    }
}
