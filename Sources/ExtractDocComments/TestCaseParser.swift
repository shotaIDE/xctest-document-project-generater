import Foundation
import SwiftParser

public func parseSwiftCode(source: String) -> [TestClass: [TestCase]] {
    let sourceFileSyntax = Parser.parse(source: source)

    let visitor = TestCaseSyntaxVisitor(viewMode: .all)
    visitor.walk(sourceFileSyntax)

    return visitor.classes
}
