import Foundation
import SwiftParser

private let testMethodIndent = "    "

public func generateEmptySwiftCode(testClasses: [TestClass: [TestCase]]) -> String {
    let testClassSwiftCodeList = testClasses.map { (testClass: TestClass, testCases: [TestCase]) in
        let testCaseSwiftCodeList = testCases.map { testCase in
            let docCommentString: String = if let docCommentStrings = testCase.docComment?.map({ line in
                "\(testMethodIndent)\(line)"
            }) {
                docCommentStrings.joined(separator: "\n") + "\n"
            } else {
                ""
            }

            let testCaseMethodString = "\(testMethodIndent)func \(testCase.name)() {}"

            return "\(docCommentString)\(testCaseMethodString)"
        }

        let testCasesSwiftCode = testCaseSwiftCodeList.joined(separator: "\n\n")

        let docCommentString: String = if let docCommentStrings = testClass.docComment {
            docCommentStrings.joined(separator: "\n") + "\n"
        } else {
            ""
        }

        let classSwiftString = """
        class \(testClass.name) {
            private init() {}

        \(testCasesSwiftCode)
        }
        """

        return "\(docCommentString)\(classSwiftString)"
    }

    return testClassSwiftCodeList.joined(separator: "\n\n")
}
