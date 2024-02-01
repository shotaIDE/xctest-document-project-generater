@testable import extractdoccomments
import XCTest

class MainTests: XCTestCase {
    func testNoArgs() {
        let directoryPath = "Tests/ExtractDocCommentsTests/ExampleUITests"
        let outputDirectory = "Tests/ExtractDocCommentsTests/ExampleUITestsDocTests"
        let projectRootAbsolutePath = FileManager.default.currentDirectoryPath
        print(projectRootAbsolutePath)
        let absolutePath = FileManager.default.currentDirectoryPath + "/" + directoryPath
        print(absolutePath)
        let tools = ExtractDocComments(directoryPath: directoryPath, outputDirectory: outputDirectory)

        try? tools.run()
    }
}
