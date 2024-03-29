# Contributing

This document is a guide to the development process.

## Environment

### SwiftFormat

SwiftFormat is introduced by Swift Package Manager.

To format Swift codes on Xcode, see the following.

https://github.com/nicklockwood/SwiftFormat/tree/main?tab=readme-ov-file#trigger-plugin-from-xcode

### CSpell

[CSpell](https://github.com/streetsidesoftware/cspell) is introduced on GitHub checks.

To check spelling on local, see the following.

```shell
cspell .
```

GitHub checks may point out typos.
This may be an false positive sometimes, so please follow the guidelines below to correct your settings or fix the typo.

#### Typo fix guidelines

**Case 1: the word appears in SDK or external library**

Add a line containing the target proper noun in all lowercase letters to `Dictionary/dependency.txt` and commit.

```plaintext:Dictionary/dependency.txt
# existing lines...
cocoapods # new line
```

**Case 2: the word is a proper noun specific to this project**

Add a line containing the target proper noun in all lowercase letters to `Dictionary/domain.txt` and commit.

```plaintext:Dictionary/domain.txt
# existing lines...
shota # new line
```

**Other case: If none of the above apply**

This is an English spelling mistake, so please correct it.
If you are unsure about how to fix it, please refer to the case study below.

- No breaks in words
  - Not `pushnotification` but `push notification` <!-- cspell:ignore pushnotification -->
- Conjugating words that don't exist in English
  - Not `registed` but `registered` <!-- cspell:ignore registed -->

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
