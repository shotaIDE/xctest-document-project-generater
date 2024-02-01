@testable import extractdoccomments
import XCTest

final class TestCaseConverterTests: XCTestCase {
    func testExample() throws {
        XCTAssertEqual(
            parseSwiftCode(
                source: """
                class SomeTests: XCTestCase {
                }
                """
            ),
            [
                TestClass(name: "SomeTests", docComment: nil): [],
            ]
        )
    }
}
