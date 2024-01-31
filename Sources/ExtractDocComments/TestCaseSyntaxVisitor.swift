import Foundation
import SwiftSyntax

class TestCaseSyntaxVisitor: SyntaxVisitor {
    var currentClassName: String? = nil
    var currentTestClass: TestClass? = nil
    var classes = [TestClass: [TestCase]]()

    public override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        let className = node.name.text
        let docCommentLines = node.leadingTrivia.compactMap { triviaPiece -> String? in
            if case .docLineComment(let text) = triviaPiece {
                return text
            }
            return nil
        }

        let docCommentBodies = docCommentLines.map { docCommentLine in
            docCommentLine
                .replacingOccurrences(of: "///", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let docComment: DocComment?
        if docCommentBodies.count >= 1 {
            let docCommentSummary = docCommentBodies[0]

            if docCommentBodies.count >= 3 {
                let docCommentDetails = docCommentBodies[2...].joined(separator: "\n")
                docComment = DocComment(
                    summary: docCommentSummary,
                    description: docCommentDetails,
                    lines: docCommentLines
                )

                print("Found document comment (summary and description) for \"\(className)\".")
            } else {
                docComment = DocComment(
                    summary: docCommentSummary,
                    description: nil,
                    lines: docCommentLines
                )

                print("Found document comment (summary only) for \"\(className)\".")
            }
        } else {
            docComment = nil

            print("Not Found document comment for \"\(className)\".")
        }

        let testClass = TestClass(name: className, docComment: docComment)

        currentTestClass = testClass
        currentClassName = className

        classes[testClass] = []

        return .visitChildren
    }

    public override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        let function: FunctionDeclSyntax = node
        let name = function.name.text
        if !name.hasPrefix("test") {
            return .skipChildren
        }

        let testClass = currentTestClass!

        print("Found test case \"\(name)\" in test class \"\(testClass.name)\"")

        let docCommentLines = node.leadingTrivia.compactMap { triviaPiece -> String? in
            if case .docLineComment(let text) = triviaPiece {
                return text
            }
            return nil
        }

        let docCommentBodies = docCommentLines.map { docCommentLine in
            docCommentLine
                .replacingOccurrences(of: "///", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let docComment: DocComment?
        if docCommentBodies.count >= 1 {
            let docCommentSummary = docCommentBodies[0]

            if docCommentBodies.count >= 3 {
                let docCommentDetails = docCommentBodies[2...].joined(separator: "\n")
                docComment = DocComment(
                    summary: docCommentSummary,
                    description: docCommentDetails,
                    lines: docCommentLines
                )

                print("Found document comment (summary and description) for \"\(name)\".")
            } else {
                docComment = DocComment(
                    summary: docCommentSummary,
                    description: nil,
                    lines: docCommentLines
                )

                print("Found document comment (summary only) for \"\(name)\".")
            }
        } else {
            docComment = nil

            print("Not Found document comment for \"\(name)\".")
        }

        let testCase = TestCase(name: name, docComment: docComment)

        var classCases = classes[testClass]!
        classCases.append(testCase)
        classes[testClass] = classCases

        return .skipChildren
    }
}
