import Foundation
import SwiftSyntax

class TestCaseSyntaxVisitor: SyntaxVisitor {
    var currentTestClass: TestClass?
    var classes = [TestClass: [TestCase]]()

    override public func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        let className = node.name.text
        let docComment = extractDocComment(trivia: node.leadingTrivia)
        let testClass = TestClass(name: className, docComment: docComment)

        currentTestClass = testClass
        classes[testClass] = []

        return .visitChildren
    }

    override public func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        let methodName = node.name.text
        if !methodName.hasPrefix("test") {
            return .skipChildren
        }

        let testClass = currentTestClass!

        print("Found test case \"\(methodName)\" in test class \"\(testClass.name)\"")

        let docComment = extractDocComment(trivia: node.leadingTrivia)
        let testCase = TestCase(name: methodName, docComment: docComment)

        var testCases = classes[testClass]!
        testCases.append(testCase)
        classes[testClass] = testCases

        return .skipChildren
    }

    private func extractDocComment(trivia: Trivia) -> DocComment? {
        let lines = trivia.compactMap { triviaPiece -> String? in
            if case let .docLineComment(text) = triviaPiece {
                return text
            }
            return nil
        }

        if lines.isEmpty {
            return nil
        }

        return lines
    }
}
