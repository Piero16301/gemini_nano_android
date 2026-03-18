// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "gemini_nano_android",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "gemini_nano_android", targets: ["gemini_nano_android"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "gemini_nano_android",
            dependencies: [],
            path: "Classes",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
