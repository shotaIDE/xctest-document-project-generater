# XCTest Empty Project Generator

## これは何か？

Xcode のプロジェクトにおけるテストターゲットのドキュメントを生成したいケースがあります。

ところが、Xcode のドキュメント生成機能や DocC、jazzy などのドキュメント生成ツールは、Xcode で直接実行できるターゲットに対してしかドキュメントを生成してくれません。

このツールは、上記のツールでテストターゲットに含まれるファイル群のドキュメントコメントのドキュメントを生成できるようにします。

## 基本的なアイデア

Swift Syntax により、テストターゲットに含まれるテスト Swift ファイルの構文解析をします。

クラス名とクラスの Doc コメント、さらにクラスに含まれるテストメソッド名とテストメソッドの Doc コメントを収集します。

ドキュメント生成に必要な情報だけを記載した動作がない Swift ファイルを生成します。

（ツールの動作外）動作がない Swift ファイル群に対してドキュメント生成を行います。

## Usage

Xcode プロジェクトの Swift Package Manager を利用して、依存関係として登録します。

```swift:Package.swift
let package = Package(
    // name, platforms, products, etc.
    dependencies: [
        // other dependencies
        .package(url: "https://github.com/organization/repository", from: "1.0.0"),
    ],
    targets: [
        // targets
    ]
)
```

## ドキュメントを生成する

以下のコマンドを実行して空のモジュールを作ります。

```shell
swift run extractdoccomments "SampleUITests/" "~/Desktop/SampleUITestsEmptyPackage"
```

以下のコマンドを実行してドキュメントを生成します。

```shell
cd "~/Desktop/SampleUITestsEmptyPackage"
swift package --allow-writing-to-directory ./SampleUITests generate-documentation --target emptyxctestmodule --output-path ./SampleUITests
```

ドキュメント生成の詳しい内容は、[Swift-DocC Plugin](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/) のドキュメントを参照してください。
