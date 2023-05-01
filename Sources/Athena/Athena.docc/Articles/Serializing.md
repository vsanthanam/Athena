# Serializing JSON into Data

Serialize ``JSON`` values into a Swift `String` or UTF-8 encoded `Data`

## Overview

``JSON`` values can be serialized into Swift `String`, values or into UTF8-Encoded Swift `Data` values.

The easiest way to do this is to use the Athena-provided initializers for `String` and `Data`

```swift
import Athena

let json: JSON = [
    "key": [
        "content": "value"
    ],
    "identifier": "some-identifier",
    "content": nil
]

do {
    let data = try Data(serializing: json)
    let string = try String(serializing: json)
} catch {
    print(error)
}
```

You can also invoke ``JSON``'s ``JSON/serialize()`` and ``JSON/stringify()`` instance methods, which do effectively the same thing:

```swift
do {
    let data = try json.serialize()
    let string = try json.stringify()
} catch {
    print(error)
}
```

If you need more control over the way a ``JSON`` value is serialized, you can use the static interface from ``JSON/Serializer``.
This API allows you to perform serialization operations asynchronously. It also allows you to supply an options bitmask for further customization.

For example, the following snippet would lead to the subsequent console output:

```swift
func performSerialization() async {
    do {
        let string = try await JSON.Serializer.stringfy(json, options: [.nullSkipsKey, .sortedKeys, .prettyPrinted])
        print(string)
    } catch {
        print(error)
    }
}
```

```
{
    "identifier": "value",
    "key": {
        "content": "value"
    }
}
```
