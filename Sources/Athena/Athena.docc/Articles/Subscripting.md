# Working with Nested Values using Subscripts

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

let firstName: JSON = try innovator.value(forKey: "first_name")

let firstProductName: JSON = try innovator
    .value(forKey: "inventions")
    .value(atIndex: 0)
    .value(forKey: "name")
```

You can also create a ``JSON/Path`` from an array of valid subscripts. For example:

```swift
import Athena

let innovator = JSON( ... )
let path: JSON.Path = ["inventions", 0, "name"]
let firstProductName: JSON = try innovator.value(atPath: path)
```

See the symbol documentation for ``JSON/Subscript`` for more information.

You can also use Swift's built-in subscript syntax to achieve the same effect.
Doing so returns ``JSON/Literal/null`` for invalid subscripts instead of throwing an error.

```swift
import Athena

let innovator = JSON( ... )
let firstProductName: JSON = innovator["inventions"][0]["name"]
```

You can also use subscripts to add, remove, or replace values from a ``JSON`` value.

```swift
import Athena

try innovator.setValue("Steven", forSubscript: "first_name")
innovator["middle_name"] = "Paul"
try innovator["inventions"].removeValue(atIndex: 3)
```

- Note: ``JSON`` is a value type. To mutate a JSON value using subscripts, it must be declared as a variable, not as a constant.
