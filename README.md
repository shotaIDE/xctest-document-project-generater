# XCTest Document Project Generator

A tool for generating documents from doc comments in test files included in Xcode test targets.

## What is this?

Sometimes you might want to generate documents for test codes in Xcode test targets.

However, the documents generator in Xcode or [Swift-DocC](https://www.swift.org/documentation/docc/), [jazzy](https://github.com/realm/jazzy) only generates documents for targets that can be run directly in Xcode.

This tool allows the tools mentioned above to generate documents for test codes in test targets.

## Base idea

![Concept explanation](/Docs/convert-image.gif)

This tool generates a non-behavioral Swift file that contains only the information needed to generate documents.

Use another tool to generate documents for the Swift files generated above.

## Install

Install using Swift Package Manager.

### Swift Package Manager

Register as a dependency in `Package.swift`.

```swift:Package.swift
let package = Package(
    // name, platforms, products, etc.
    dependencies: [
        // other dependencies
        .package(url: "https://github.com/shotaIDE/xctest-document-project-generate", from: "0.1.0")
    ],
    targets: [
        // targets
    ]
)
```

> [!NOTE]
> Currently, plugin usage is not supported.
> This is because Swift Package Manager does not allow the development of plugins using libraries other than the standard library and this tool depends on non-standard libraries such as Swift Syntax.
> See https://github.com/apple/swift-package-manager/blob/main/Documentation/Plugins.md#implementing-the-command-plugin-script for more information.

## Usage

To generate documents, you need the following steps.

1. Create a project for generating documents.
2. Generate documents.

### 1. Create a project for generating documents

#### Swift Package Manager

Run the following command to create a project for generating documents.

```shell
swift run XCTestDocProjectGen path/to/your/test/swift/directory XCTestDocProject
```

### 2. Generate documents

Run the following command to generate documents.

```shell
cd XCTestDocProject
swift package generate-documentation
```

For more details on document generation, please see the [Swift-DocC Plugin documents](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/).
