// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCTestDocProject",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "XCTestDocProject",
            targets: ["XCTestDocProject"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.1.0")
    ],
    targets: [
        .executableTarget(
            name: "XCTestDocProject"
        )
    ]
)
