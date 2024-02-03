# XCTest Document Project Generator

## What is this?

Xcode のプロジェクトにおけるテストターゲットのドキュメントを生成したいケースがあります。

ところが、Xcode のドキュメント生成機能や [Swift-DocC](https://www.swift.org/documentation/docc/)、[jazzy](https://github.com/realm/jazzy) などのドキュメント生成ツールは、Xcode で直接実行できるターゲットに対してしかドキュメントを生成してくれません。

このツールは、上記のツールでテストターゲットに含まれるファイル群のドキュメントコメントのドキュメントを生成できるようにします。

## Base idea

![コンセプト解説図](/Docs/convert-image.gif)

このツールにより、ドキュメント生成に必要な情報だけを記載した動作がない Swift ファイルを生成します。

別のツールにより、上記で生成した Swift ファイル群に対してドキュメント生成を行います。

## Install

Xcode プロジェクトの Swift Package Manager を利用して、依存関係として登録します。

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

さらに、別のツールの Swift-DocC Plugin を依存関係として登録します。

```swift:Package.swift
let package = Package(
    // name, platforms, products, etc.
    dependencies: [
        // other dependencies
        .package(url: "https://github.com/shotaIDE/xctest-document-project-generate", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.1.0")
    ],
    targets: [
        // targets
    ]
)
```

## Usage

以下のコマンドを実行してドキュメント生成用のプロジェクトを作ります。

```shell
swift run XCTestDocProjectGen path/to/your/test/swift/directory XCTestDocProject
```

> [!NOTE]
> 現在 Swift Package Manager では標準のライブラリ以外を利用してプラグインを開発することが許可されていません。
> 本ツールでは Swift Syntax などの標準ではないライブラリに依存しているため、現在プラグインとしての利用はサポートされていません。
> See https://github.com/apple/swift-package-manager/blob/main/Documentation/Plugins.md#implementing-the-command-plugin-script for more information.

以下のコマンドを実行してドキュメントを生成します。

```shell
cd XCTestDocProject
swift package generate-documentation
```

ドキュメント生成の詳しい内容は、[Swift-DocC Plugin](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/) のドキュメントを参照してください。
