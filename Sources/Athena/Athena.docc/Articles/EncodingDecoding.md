# Encoding & Decoding between Swift Types and JSON

Encode & decode your custom Swift types to and from their JSON representations

## Overview

Athena provides interfaces that allow any Swift type to be easily represented as ``JSON`` and to be initialized from a properly shaped ``JSON`` instance.

- To make a Swift type encodable into ``JSON``, make it conform to ``JSONEncodable``.
- To make a Swift type decodable from ``JSON``, make it conform to ``JSONDecodable``.

You can use the ``JSONCodable`` typealias to declare conformance or type constraints to both protocols together.

```swift

import Athena

struct Car: JSONCodable {
    
    enum Make: String, JSONCodable {
        case vw
        case bmw
        case toyota
        case hyundai
        case stelantis
        case generalMotors
        case mercedesBenz
        case honda
    }

    let model: String

    let make: Make

    let horsepower: Int

    let year: Int

    // MARK: - JSONEncodable

    func toJSON() -> JSON {
        [
            "make": JSON(make),
            "model": JSON(model),
            "horsepower": JSON(horsepower),
            "year": JSON(year)
        ]
    }

    // MARK: - JSONDecodable

    init(json: JSON) throws {
        self.model = try json["model"].decode()
        self.make = try json["make"].decode()
        self.horsepower = try json["horsepower"].decode()
        self.year = try json["year"].decode()
    }

}
```

Athena contains default implementations of ``JSONCodable`` for the following Swift types:

- `Bool`
- `Int`
- `Double`
- `String`
- `URL`
- `UUID`
- `Array where Element: JSONCodable`
- `Set where Element: JSONCodable`
- `Dictionary where Key == String, Element: JSONCodable`
- `Optional where Wrapped: JSONCodable`

> tip: When implementing `JSONCodable` for your custom types, implement `JSONCodable` for your depedent types as well. This will make your implemention much cleaner, with the parent type invoking the encode & decode method of its children.

### Using the Compiler to Synthesize Conformance

Athena can synthesize conformance to ``JSONCodable`` if the compiler can synthesize conformance to `Codable` for the same type. 

```swift
struct MyType: Codable, JSONCodable {
    let value: String
    let entries: [String]
}
```

> important: You should avoid doing this for types where you have implemented `Codable` conformance yourself. Use this method only for compiler synthesized implementations of `Codable`.

Using this implementation, Athena will piggy back on the compiler synthesized implementation of `Codable` conformance and use it to implement conformance to ``JSONCodable``.

### Encoding & Decoding Values

The simplest way to encode a ``JSONEncodable`` conforming type into ``JSON`` value is to use the ``JSON/init(_:)-3hvss`` initializer. For example:

```swift
let myInstance = MyType(value: "SomeString", entries: ["Some", "Entries"])
let encoded = JSON(myInstance)
```

You can also invoke the type's `toJSON()` method:

```swift
let encoded = myInstance.toJSON()
```

The simplest way to decode a ``JSONDecodable`` value from a ``JSON`` is to use the ``JSON/decode(_:)`` instance method. For example:

```swift
let json = JSON( ... )
let decoded = try json.decode(MyType.self)
```

The ``JSON/decode(_:)`` method can infer its `type` argument from the type context of the call site:

```swift
let decoded: MyType = try json.decode()
```

You can also invoke the conforming type's `init(json:)` initializer:

```swift
let decoded = try MyType(json: json)
```

#### Decoding a Nested JSON Value

You can combine the standard ``JSON/decode(_:)`` method with the regular subscripting process. For example, given the following JSON, using any of the identical subsequent options:

```swift
struct Entry: JSONDecodable {
    let title: String
    let message: String
}

let json: JSON = [
    "name": "Steve"
    "notableEntry": [
        "title": "Entry Title",
        "message": "Entry Message"
    ]
]
```

```swift
let entry = try json.value(for: "notableEntry").decode(Entry.self)
```

```swift
let entry = try json["notableEntry"].decode(Entry.self)
```

```swift
let entry: Entry = try json["notableEntry"].decode()
```

```swift
let entry = try Entry(json: json["notableEntry"])
```

If the type context expects an `Optional where Wrapped: JSONDecodable`, you can drop the decode methods entirely and just use subscripts. Doing so will replace decoding errors with `nil`.

```swift
let entry: Entry? = json["notableEntry"]
```

#### Configuring Encode / Decode Operations

If you need more control over the way a type is encoded or decoded, you can use the static interfaces from ``JSON/Encoder`` and ``JSON/Decoder``.
These APIs allow you to perform encoding & decoding operations asynchronously. For example:

```swift
let myInstance = MyType(value: "SomeString", entries: ["Some", "Entries"])
let encoded = await JSON.Encoder.encode(myInstance)
let decoded = try await JSON.Decoder.decode(MyType.self, from: encoded)
```
