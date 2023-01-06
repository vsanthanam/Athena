# ``Athena/JSON/Literal``

## Overview

This enumeration represents a literal value in a JSON object

```swift
enum Literal {
    case `true`
    case `false`
    case `nil`
}
```

In practice, you do not need to interface with the enumeration cases directly. ``JSON/Literal`` contains strictly typed initalizers that accept a `Bool` value to create the `true` and `false` enumeration cases. It also contains an argument-less initailzer used to create the `null` enumeration case.

These two snippets of code are identical:

```swift
let bool = JSON.Literal.true
let null = JSON.Literal.null
```

```swift
let bool = JSON.Literal(true)
let null = JSON.Literal()
```

``JSON/Literal`` also conforms to `ExpressibleByBooleanLiteral` and `ExpressibleByNilLiteral`, so you could further simplify the above code like this:

```swift
let bool: JSON.Literal = true
let null: JSON.Literal = nil
```

## Topics

### Initializers

- ``JSON/Literal/init(_:)``
- ``JSON/Literal/init()``

### Enumeration Cases

- ``JSON/Literal/true``
- ``JSON/Literal/false``
- ``JSON/Literal/null``

### Enumeration Associated Values

- ``JSON/Literal/boolValue``
- ``JSON/Literal/isNull``

### Literal Expression Support

- ``JSON/Literal/BooleanLiteralType``
- ``JSON/Literal/init(booleanLiteral:)``
- ``JSON/Literal/init(nilLiteral:)``
