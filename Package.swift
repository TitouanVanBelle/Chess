// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chess",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "Chess",
            targets: ["Chess"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "8.0.1")),
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
        .target(
            name: "Chess",
            dependencies: []),
        .testTarget(
            name: "ChessTests",
            dependencies: ["Chess", "Quick", "Nimble"]),
    ]
)
