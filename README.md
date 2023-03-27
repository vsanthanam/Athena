# Athena

[![MIT License](https://img.shields.io/github/license/vsanthanam/Athena)](https://github.com/vsanthanam/Athena/blob/main/LICENSE)
[![Package Releases](https://img.shields.io/github/v/release/vsanthanam/Athena)](https://github.com/vsanthanam/Athena/releases)
[![Build Statis](https://img.shields.io/github/actions/workflow/status/vsanthanam/Athena/spm-build-test.yml)](https://github.com/vsanthanam/Athena/actions)
[![Swift Version](https://img.shields.io/badge/swift-5.7-critical)](https://swift.org)
[![Supported Platforms](https://img.shields.io/badge/platform-iOS%2012-lightgrey)](https://developer.apple.com)

Athena is a library that provides type-safe APIs for working with JSON objects in Swift. It provides an idiomatic solution that is both faster and easier to use than Foundation's `JSONSerialization` API. It takes advantage of modern Swift language features, and provides APIs for easily creating, mutating, serializing, and deserializing JSON values. It also provides a system to easily encode other Swift types into a JSON representation and decode those same types from correctly shaped JSON values.

Athena is based on [Freddy](https://github.com/bignerdranch/Freddy), an early library for working with JSON in Swift that is no longer maintained by its original authors. The library itself has no non-Apple dependencies, but the package does use the [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) and [DocC](https://github.com/apple/swift-docc-plugin) Swift Package Manager plugins.

## Installation

Athena currently distributed exclusively through the [Swift Package Manager](https://www.swift.org/package-manager/). 

To add Athena as a dependency to an existing Swift package, add the following line of code to the `dependencies` parameter of your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/vsanthanam/Athena.git", .upToNextMajor(from: "0.0.0"))
]
```

To add Athena as a dependency to an Xcode Project: 

- Choose `File` → `Add Packages...`
- Enter package URL `https://github.com/vsanthanam/Athena.git` and select your release and of choice.

Other distribution mechanisms like CocoaPods or Carthage may be added in the future.

## Usage & Documentation

Athena's documentation is built with [DocC](https://developer.apple.com/documentation/docc) and included in the repository as a DocC archive. The latest version is hosted on [GitHub Pages](https://pages.github.com) and is available [here](https://vsanthanam.github.io/Athena/docs/documentation/athena).

Additional installation instructions are available on the [Swift Package Index](https://swiftpackageindex.com/vsanthanam/Athena)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fvsanthanam%2FAthena%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/vsanthanam/Athena)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fvsanthanam%2FAthena%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/vsanthanam/Athena)

Explore [the documentation](https://vsanthanam.github.io/Athena/docs/documentation/athena) for more details.

## License

**Athena** is available under the MIT license. See the LICENSE file for more information.
