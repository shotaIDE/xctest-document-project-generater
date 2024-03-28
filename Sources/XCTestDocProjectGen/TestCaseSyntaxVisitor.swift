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
        guard isTarget(node: node) else {
            return .skipChildren
        }

        let methodName = node.name.text
        let testClass = currentTestClass!

        print("Found test case \"\(methodName)\" in test class \"\(testClass.name)\"")

        let docComment = extractDocComment(trivia: node.leadingTrivia)
        let testCase = TestCase(name: methodName, docComment: docComment)

        var testCases = classes[testClass]!
        testCases.append(testCase)
        classes[testClass] = testCases

        return .skipChildren
    }

    private func isTarget(node: FunctionDeclSyntax) -> Bool {
        guard node.name.text.hasPrefix("test") else {
            return false
        }

        for modifier in node.modifiers where modifier.name.text == "private" {
            return false
        }

        return true
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
