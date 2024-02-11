# Contributing

This document is a guide to the development process.

## Environment

### SwiftFormat

SwiftFormat is introduced by Swift Package Manager.

To format Swift codes on Xcode, see the following.

https://github.com/nicklockwood/SwiftFormat/tree/main?tab=readme-ov-file#trigger-plugin-from-xcode

## Develop as a CocoaPods library

#### Environment

Install [rbenv](https://github.com/rbenv/rbenv).

Install CocoaPods and its dependencies with the following command.

```shell
bundle install
```

#### Lint Pod spec file

Check the Pod spec file with the following command.

```shell
bundle exec pod spec lint XCTestDocProjectGen.podspec
```

#### Publish

Run the following command.

```shell
pod trunk push
```
