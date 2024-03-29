# Deserializing Data into JSON

Parse UFT-8 encoded data into ``JSON``

## Overview

You can deserialize UTF-8 encoded data or properly formatted JSON strings into a ``JSON`` value. 

The easiest way to do that is to use ``JSON/init(data:)`` or ``JSON/init(jsonString:)`` initializers:

```swift
import Athena

let utf8: Data = ...
let jsonString: String = ...

let jsonFromData = try JSON(data: utf8)
let jsonFromString = try JSON(jsonString: jsonString)
```

If you need more control over the way the type is serialized, you can use the static interface from ``JSON/Deserializer``.
This API allows you to perform deserialization operations asynchronously. It also allows you to supply an options bitmask for further customization.

For example:

```swift
import Athena

let jsonString = "[{\"first_key\": \"value\", \"second_key\": null}]"
let json = try await JSON.Deserializer.deserialize(jsonString, options: [.nullSkipsKey, .fragmentsAllowed])
```
