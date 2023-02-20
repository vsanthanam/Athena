# Retrieving Nested Values with Subscripts

Get values out of a ``JSON`` using subscripts

## Overview

You can use integers or strings as subscripts to retrieve nested JSON values. For example, given the following ``JSON`` value:

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

You could access its nested ``JSON`` values like this:

```swift
import Athena

let firstName: JSON = try innovator.value(for: "first_name")

let firstProductName: JSON = try innovator
    .value(for: "inventions")
    .value(for: 0)
    .value(for: "name")
```

You can combine multiple calls to ``JSON/value(for:)`` using a single call to ``JSON/value(at:)-65345`` using variadic arguments:

```swift
import Athena

let innovator = JSON( ... )
let firstProductName: JSON = try innovator.value(at: "inventions", 0, "name")
```

You can also use an Array of `any JSONSubscript` types:

```swift
import Athena

let innovator = JSON( ... )
let path: JSONPath = ["inventions", 0, "name"]
let firstProductName = try innovator(at: path)
```

You can also use Swift's built-in subscript syntax to achieve the same effect.
Doing so returns ``JSON/Literal/null`` for invalid subscripts instead of throwing an error

Using chained subsripts:

```swift
import Athena

let innovator = JSON( ... )
let firstProductName: JSON = innovator["inventions"][0]["name"]
```

Using a single subscript with variadic arguments:

```swift
import Athena

let innovator = JSON( ... )
let firstProductName: JSON = innovator["inventions", 0, "name"]
```

You can also use subscripts to mutate a JSON value

```swift
import Athena

try innovator.setValue("Steven", forSubscript: "first_name")
innovator["middle_name"] = "Paul"
```

## Topics

### Protocols

- ``JSONSubscript``

### Typealiases

- ``JSONPath``
