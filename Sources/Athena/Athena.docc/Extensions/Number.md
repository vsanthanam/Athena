# ``Athena/JSON/Number``

## Overview

This enumeration represents a number in a JSON object.

```swift
enum Number {
    case int(Int)
    case double(Double)
}
```

In practice, you do not need to interface with the enumeration cases directly, as ``JSON/Number`` has strictly typed initializers for valid types.

These two snippets of code are identical:

```swift
let int = JSON.Number.int(23)
let double = JSON.Number.double(4.2)
```

```swift
let int = JSON.Number(23)
let double = JSON.Number(4.2)
```

``JSON/Number``  conforms to `ExpressibleByIntegerLiteral` and `ExpressibleByFloatLiteral`, so you could further simplify the above code like this:

```swift
let int: Number = 23
let double: Number = 4.2
```

You retrive a ``JSON/Number`` as a Swift `Int` or Swift `Double` using the following methods:

```swift
let number = Number(16)
let int = try number.intValue
let double = number.doubleValue
```

`intValue` is a throwing `var`, while `doubleValue` is a regular  `var`, since all ``JSON/Number`` values can be expressed as a `Double`, but not all ``JSON/Number`` values can be expressed as an `Int`.

``Number`` values are considered equivelent if their `doubleValue` values are the same:

```swift
let int = Number.int(4)
let double = Number.double(4.0)
let isEqual = int == double
// `isEqual` is `true`
```

## Topics

### Initializers

- ``init(_:)-4a0pn``
- ``init(_:)-4xqnw``

### Enumeration Cases

- ``int(_:)``
- ``double(_:)``

### Enumeration Associated Values

- ``intValue``
- ``doubleValue``

### Literal Expression Support

- ``IntegerLiteralType``
- ``init(integerLiteral:)``
- ``FloatLiteralType``
- ``init(floatLiteral:)``
