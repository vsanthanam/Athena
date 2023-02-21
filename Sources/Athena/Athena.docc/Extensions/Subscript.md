# ``Athena/JSON/Subscript``

## Overview

A JSON object can be subscripted with a `String` if is an object, or an `Int` if it is an `Array`. JSON strings, numbers, and literals cannot be subscripted.

This enumeration is used to represent a valid JSON subscript:

```swift
enum Subscript {
    case key(String)
    case index(Int)
}
```

``JSON/Subscript`` conforms to `ExpressibleByStringLiteral` and `ExpressibleByIntegerLiteral`, so you can use literals whenever the type context expects a ``JSON/Subscript`` instead of using the enumeration cases.

The following code snippets are functionally identical:

```swift
let key = JSON.Subscript.key("some-key")
let index = JSON.Subscript.index(23)
```

```swift
let key = JSON.Subscript("some-key")
let index = JSON.Subscript(23)
```

```swift
let key: JSON.Subscript = "some-key"
let index: JSON.Subscript = 23
```

## Topics

### Initializers

- ``JSON/Subscript/init(_:)``

### Enumeration Cases

- ``JSON/Subscript/key(_:)``
- ``JSON/Subscript/index(_:)``

### Enumeration Associated Values

- ``JSON/Subscript/keyValue``
- ``JSON/Subscript/indexValue``

### Literal Expression Support

- ``JSON/Subscript/StringLiteralType``
- ``JSON/Subscript/init(stringLiteral:)``
- ``JSON/Subscript/IntegerLiteralType``
- ``JSON/Subscript/init(integerLiteral:)``
