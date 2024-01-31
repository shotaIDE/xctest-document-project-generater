// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "extractdoccomments",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "extractdoccomments",
            targets: ["extractdoccomments"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.1.0"),
        .package(url: "https://github.com/apple/swift-syntax.git", exact: "509.1.1")
    ],
    targets: [
        .executableTarget(
            name: "extractdoccomments",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax")
            ]
        ),
        .testTarget(
            name: "extractdoccommentsTests",
            dependencies: ["extractdoccomments"]
        ),
    ]
)
