import XCTest
@testable import XCTestDocProjectGen

class GenerateEmptySwiftCodeTests: XCTestCase {
    func testGenerateEmptySwiftCodeWithoutDocComments() {
        // Given
        let testCases = [TestCase(name: "testExample", docComment: nil)]
        let testClasses: [TestClass: [TestCase]] = [TestClass(name: "ExampleTests", docComment: nil): testCases]

        // When
        let generatedCode = generateEmptySwiftCode(testClasses: testClasses)

        // Then
        let expectedCode = """
        class ExampleTests {
            private init() {}

            func testExample() {}
        }
        """

        XCTAssertEqual(generatedCode, expectedCode)
    }

    func testGenerateEmptySwiftCodeWithDocComments() {
        // Given
        let docComment = DocComment(summary: "Test Example", description: nil, lines: ["/// This is a test case"])
        let testCases = [TestCase(name: "testDocCommentExample", docComment: docComment)]
        let classDocComment = DocComment(
            summary: "Test Class Example", description: nil, lines: ["/// This is a test class"]
        )
        let testClasses = [TestClass(name: "DocCommentTests", docComment: classDocComment): testCases]

        // When
        let generatedCode = generateEmptySwiftCode(testClasses: testClasses)

        // Then
        let expectedCode = """
        /// This is a test class
        class DocCommentTests {
            private init() {}

            /// This is a test case
            func testDocCommentExample() {}
        }
        """

        XCTAssertEqual(generatedCode, expectedCode)
    }

    // Add more tests here to cover edge cases, error handling, and other scenarios.
}
