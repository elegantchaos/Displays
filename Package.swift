// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Displays",
    platforms: [
        .macOS(.v10_10)
    ],
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
