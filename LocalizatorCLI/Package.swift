// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocalizatorCLI",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(
            name: "localizator",
            targets: ["localizator"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/tuist/Noora", .upToNextMajor(from: "0.17.0")),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
        .package(path: "../LocalizatorSDK")
    ],
    targets: [
        .executableTarget(
            name: "localizator",
            dependencies: [
                .product(name: "LocalizatorSDK", package: "LocalizatorSDK"),
                .product(name: "Noora", package: "Noora"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        )
    ]
)
