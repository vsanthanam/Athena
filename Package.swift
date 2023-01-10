// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "Athena",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_14),
        .tvOS(.v12),
        .watchOS(.v5)
    ],
    products: [
        .library(
            name: "Athena",
            targets: ["Athena"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Athena",
            dependencies: []
        ),
        .testTarget(
            name: "AthenaTests",
            dependencies: ["Athena"]
        ),
    ]
)
