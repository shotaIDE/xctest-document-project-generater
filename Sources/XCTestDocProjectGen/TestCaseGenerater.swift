import Foundation
import SwiftParser

private let testMethodIndent = "    "

public func generateEmptySwiftCode(testClasses: [TestClass: [TestCase]]) -> String {
    let testClassSwiftCodeList = testClasses.map { (testClass: TestClass, testCases: [TestCase]) in
        let testCaseSwiftCodeList = testCases.map { testCase in
            let maybeDocCommentStrings = testCase.docComment?.map({ "\(testMethodIndent)\($0)" })
            let docCommentSwiftCode = if let docCommentStrings = maybeDocCommentStrings {
                docCommentStrings.joined(separator: "\n") + "\n"
            } else {
                ""
            }

            let testCaseSwiftCode = "\(testMethodIndent)func \(testCase.name)() {}"

            return "\(docCommentSwiftCode)\(testCaseSwiftCode)"
        }

        let testCasesSwiftCode = testCaseSwiftCodeList.joined(separator: "\n\n")

        let docCommentSwiftCode = if let docCommentStrings = testClass.docComment {
            docCommentStrings.joined(separator: "\n") + "\n"
        } else {
            ""
        }

        let testClassSwiftCode = """
        class \(testClass.name) {
            private init() {}

        \(testCasesSwiftCode)
        }
        """

        return "\(docCommentSwiftCode)\(testClassSwiftCode)"
    }

    return testClassSwiftCodeList.joined(separator: "\n\n")
}
