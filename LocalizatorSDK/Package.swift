// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocalizatorSDK",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "LocalizatorSDK",
            targets: ["LocalizatorSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ooodin/ChatGPTSwift", branch: "main")
    ],
    targets: [
        .target(
            name: "LocalizatorSDK",
            dependencies: [
                .product(name: "ChatGPTSwift", package: "ChatGPTSwift")
            ]
        ),
        .testTarget(
            name: "LocalizatorSDKTests",
            dependencies: ["LocalizatorSDK"]
        ),
    ]
)

