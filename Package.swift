// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCTestDocProjectGen",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "XCTestDocProjectGenCommandLineTool",
            targets: ["XCTestDocProjectGenCommandLineTool"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.1.0"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.2"),
        .package(url: "https://github.com/realm/SwiftLint", from: "0.54.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.50.4")
    ],
    targets: [
        .executableTarget(
            name: "XCTestDocProjectGenCommandLineTool",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax")
            ],
            resources: [
                .process("Template/Package.swift")
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .plugin(
            name: "XCTestDocProjectGen",
            capability: .command(
                intent: .custom(verb: "xctest-doc-project-gen", description: "XCTest Document Project Generater")
            ),
            dependencies: [
                .target(name: "XCTestDocProjectGenCommandLineTool")
            ]
        ),
        .testTarget(
            name: "XCTestDocProjectGenTests",
            dependencies: ["XCTestDocProjectGenCommandLineTool"],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        )
    ]
)
