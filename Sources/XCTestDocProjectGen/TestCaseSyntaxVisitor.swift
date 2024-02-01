import Foundation
import SwiftSyntax

class TestCaseSyntaxVisitor: SyntaxVisitor {
    var currentClassName: String?
    var currentTestClass: TestClass?
    var classes = [TestClass: [TestCase]]()

    override public func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        let className = node.name.text

        let docComment = extractDocComment(trivia: node.leadingTrivia)

        let testClass = TestClass(name: className, docComment: docComment)

        currentTestClass = testClass
        currentClassName = className

        classes[testClass] = []

        return .visitChildren
    }

    override public func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        let function: FunctionDeclSyntax = node
        let name = function.name.text
        if !name.hasPrefix("test") {
            return .skipChildren
        }

        let testClass = currentTestClass!

        print("Found test case \"\(name)\" in test class \"\(testClass.name)\"")

        let docComment = extractDocComment(trivia: node.leadingTrivia)

        let testCase = TestCase(name: name, docComment: docComment)

        var classCases = classes[testClass]!
        classCases.append(testCase)
        classes[testClass] = classCases

        return .skipChildren
    }

    private func extractDocComment(trivia: Trivia) -> DocComment? {
        let docCommentLines = trivia.compactMap { triviaPiece -> String? in
            if case let .docLineComment(text) = triviaPiece {
                return text
            }
            return nil
        }

        let docCommentBodies = docCommentLines.map { docCommentLine in
            docCommentLine
                .replacingOccurrences(of: "///", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }

        if docCommentBodies.count >= 1 {
            let docCommentSummary = docCommentBodies[0]

            if docCommentBodies.count >= 3 {
                let docCommentDetails = docCommentBodies[2...].joined(separator: "\n")
                return DocComment(
                    summary: docCommentSummary,
                    description: docCommentDetails,
                    lines: docCommentLines
                )
            }

            return DocComment(
                summary: docCommentSummary,
                description: nil,
                lines: docCommentLines
            )
        }

        return nil
    }
}
