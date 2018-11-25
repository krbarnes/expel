// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "expel",
    dependencies: [
        .package(url: "https://github.com/tuist/xcodeproj.git", .upToNextMajor(from: "6.3.0")),
    ],
    targets: [
        .target(
            name: "expel",
            dependencies: ["xcodeproj"]),
        .testTarget(
            name: "expelTests",
            dependencies: ["expel"]),
    ]
)
