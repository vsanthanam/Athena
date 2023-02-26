# ``Athena/JSON``

## Overview

This enumeration represents a JSON object in Swift.

```swift
enum JSON {
    case array([JSON])
    case object([String: JSON])
    case number(Number)
    case string(String)
    case literal(Literal)
}
```

Given the following JSON payload:

```json
{
    "first_name": "Steve",
    "last_name": "Jobs",
    "college_degree": null,
    "inventions": [
        {
            "name": "Macintosh",
            "for_sale": true
        },
        {
            "name": "iPod",
            "for_sale": false
        },
        {
            "name": "iPhone",
            "for_sale": true
        },
        {
            "name": "iPad",
            "for_sale": true
        }
    ]
}
```

You could use the JSON enumeration to model the same data like this:

```swift
import Athena

let innovator: JSON = .object(
    [
        "first_name": .string("Steve"),
        "last_name": .string("Jobs"),
        "college_degree": .null,
        "inventions": .list(
            [
                .object(
                    "name": .string("Macintosh"),
                    "for_sale": .literal(.true)
                ),
                .object(
                    "name": .string("iPod"),
                    "for_sale": .literal(.false)
                ),
                .object(
                    "name": .string("iPhone"),
                    "for_sale": .literal(.true)
                ),
                .object(
                    "name": .string("iPad"),
                    "for_sale": .literal(.true)
                )
            ]
        )
    ]
)
```

In practice, you do not need to interface with the enumeration cases directly. ``JSON`` includes initializers that are strictly typed against any valid input.

These two snippets of code are identical:

```swift
let string = JSON.string("hello")
let int = JSON.number(.int(42)
let bool = JSON.literal(.true)
let null = JSON.literal(.null)
```

```swift
let string = JSON("hello")
let int = JSON(42)
let bool = JSON(true)
let null = JSON.null
```

``JSON`` conforms to many of Swift's `ExpressibleByXLiteral` protocols, which means you could further simplify the above snippet like this:

```swift
let string: JSON = "hello"
let int: JSON = 42
let bool: JSON = true
let null: JSON = nil
```

Because of these conformances, you can express complex, nested JSON objects directly in Swift using `Dictionary`, `Array`, `Bool`, `String`, `Int`, `Double`, and `nil` literals:

```swift
import Athena

let innovator: JSON = [
    "first_name": "Steve",
    "fast_name": "Jobs",
    "college_degree": nil,
    "inventions": [
        [
            "name": "Macintosh",
            "for_sale": true,
        ],
        [
            "name": "iPod",
            "for_sale": false,
        ],
        [
            "name": "Macintosh",
            "for_sale": true,
        ],
        [
            "name": "iPhone",
            "for_sale": true,
        ],
    ]
]
```

You can use built-in throwing vars to determine which enum case is represented by a given ``JSON`` value. For example:

```swift
import Athena

let json = JSON.string("value")

let string = try json.stringValue // Always Succeeds
let array = try json.arrayValue // Always Fails
```

## Topics

### Encoding & Decoding

- ``JSON/init(_:)-3hvss``
- ``JSON/init(_:)-8recc``
- ``JSON/decode(_:)``

### Serializing JSON

- ``JSON/serialize()``
- ``JSON/stringify()``

### Deserializing JSON

- ``JSON/init(data:)``
- ``JSON/init(jsonString:)``

### Retrieving Nested Values

- ``JSON/value(forKey:)``
- ``JSON/value(atIndex:)``
- ``JSON/value(forSubscript:)-1bmhw``
- ``JSON/value(forSubscript:)-4nozx``
- ``JSON/value(atPath:)``

### Updating Nested Values

- ``JSON/setValue(_:forKey:)``
- ``JSON/setValue(_:atIndex:)``
- ``JSON/setValue(_:forSubscript:)-udmw``
- ``JSON/setValue(_:forSubscript:)-8wcl8``
- ``JSON/setValue(_:forPath:)``

### Removing Nested Values

- ``JSON/removeValue(forKey:)``
- ``JSON/removeValue(atIndex:)``
- ``JSON/removeValue(forSubscript:)-968zp``
- ``JSON/removeValue(forSubscript:)-5fpzh``
- ``JSON/removeValue(atPath:)``

### Subscripts

- ``JSON/subscript(_:)-1085k``
- ``JSON/subscript(_:)-80ww6``

### Initializers

- ``JSON/init(_:)-5d9s2``
- ``JSON/init(_:)-53z3l``
- ``JSON/init(_:)-8arij``
- ``JSON/init(_:)-6grph``
- ``JSON/init(_:)-5ho5q``
- ``JSON/init(_:)-3gd7t``
- ``JSON/init(_:)-1u1rq``
- ``JSON/init(_:)-jhl2``
- ``JSON/init(_:)-48vl5``
- ``JSON/init(_:)-8lomf``
- ``JSON/init(_:)-8uzck``
- ``JSON/init(_:)-3okua``
- ``JSON/init()``

### Enumeration Cases

- ``JSON/array(_:)``
- ``JSON/object(_:)``
- ``JSON/number(_:)``
- ``JSON/string(_:)``
- ``JSON/literal(_:)``

### Enumeration Associated Values

- ``arrayValue``
- ``dictionaryValue``
- ``numberValue``
- ``intValue``
- ``doubleValue``
- ``stringValue``
- ``literalValue``
- ``boolValue``
- ``isNull``

### Literal Expression Support

- ``BooleanLiteralType``
- ``init(booleanLiteral:)``
- ``IntegerLiteralType``
- ``init(integerLiteral:)``
- ``FloatLiteralType``
- ``init(floatLiteral:)``
- ``StringLiteralType``
- ``init(stringLiteral:)``
- ``ArrayLiteralElement``
- ``init(arrayLiteral:)``
- ``Key``
- ``Value``
- ``init(dictionaryLiteral:)``
- ``init(nilLiteral:)``
