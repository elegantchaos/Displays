// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Displays",
    products: [
        .library(
            name: "Displays",
            targets: ["Displays"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Displays",
            dependencies: []),
        .testTarget(
            name: "DisplaysTests",
            dependencies: ["Displays"]),
    ]
)
