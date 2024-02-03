# Contributing

本ドキュメントは、開発に必要な手順を記載したものです。

## 開発する

### SwiftFormat

SwiftFormat を Swift Package Manager により導入しています。

Xcode 上でフォーマッターをかけるにるには以下を参考にしてください。

https://github.com/nicklockwood/SwiftFormat/tree/main?tab=readme-ov-file#trigger-plugin-from-xcode

### CocoaPods

#### Setup

[rbenv](https://github.com/rbenv/rbenv) をインストールします。

以下コマンドにより CocoaPods とその依存関係をインストールします。

```shell
bundle install
```

#### Lint Pod spec file

以下コマンドにより Pod spec ファイルをチェックします。

```shell
bundle exec pod spec lint XCTestDocProjectGen.podspec
```
