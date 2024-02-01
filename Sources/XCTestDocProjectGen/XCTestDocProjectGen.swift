import Foundation

@main public struct XCTestDocProjectGen {
    private let directoryPath: String
    private let outputRootDirectory: String

    static func main() {
        if CommandLine.arguments.count == 1
            || CommandLine.arguments.contains("-h")
            || CommandLine.arguments.contains("--help") {
            printUsage()
            exit(0)
        }

        let directoryPath = CommandLine.arguments[1]
        let markdownOutputDirectory = CommandLine.arguments[2]

        let module = Self(directoryPath: directoryPath, outputDirectory: markdownOutputDirectory)

        do {
            try module.run()
        } catch {
            print("An error occurred: \(error)")
        }
    }

    static func printUsage() {
        let usage = """
        USAGE: XCTestDocProjectGen <input directory> <output directory>

        ARGUMENTS:
            <input directory> (Required)
                The path of the folder containing Swift files in a test target of Xcode project
                for which you want to generate documents.
            <output directory> (Required)
                The path of the project's root folder for generating documents.
        """
        print(usage)
    }

    init(directoryPath: String, outputDirectory: String) {
        self.directoryPath = directoryPath
        self.outputRootDirectory = outputDirectory
    }

    func run() throws {
        let fileManager = FileManager.default
        let originalCandidateFileRelativePaths = try fileManager.contentsOfDirectory(atPath: directoryPath)
        let originalFileRelativePaths = originalCandidateFileRelativePaths.filter { $0.hasSuffix("Tests.swift") }

        print("Found \(originalFileRelativePaths.count) test files in \(directoryPath)")
        if originalFileRelativePaths.isEmpty {
            exit(0)
        }

        guard let packageSwiftFileOriginalUrl = Bundle.module.url(forResource: "Package", withExtension: "swift") else {
            print("Package.swift is not found. This executable is broken.")
            exit(1)
        }

        let packageSwiftFileOutputUrl = URL(fileURLWithPath: outputRootDirectory)
            .appendingPathComponent("Package.swift")

        try createParentDirectoryIfNeeded(fileUrl: packageSwiftFileOutputUrl)

        do {
            try fileManager.copyItem(at: packageSwiftFileOriginalUrl, to: packageSwiftFileOutputUrl)
        } catch {
            print("Failed to copy Package.swift to \(packageSwiftFileOutputUrl.path): \(error)")
            exit(2)
        }

        let outputSourceDirectory = URL(fileURLWithPath: outputRootDirectory)
            .appendingPathComponent("Sources")
            .appendingPathComponent("XCTestDocProject")

        for originalFileRelativePath in originalFileRelativePaths {
            let originalFilePath = (directoryPath as NSString).appendingPathComponent(originalFileRelativePath)
            guard let originalSource = try? String(contentsOfFile: originalFilePath) else {
                print("Unable to read file at path: \(originalFilePath)")
                continue
            }

            let testClasses = parseSwiftCode(source: originalSource)
            let swiftCode = generateEmptySwiftCode(testClasses: testClasses)

            let destinationUrl = outputSourceDirectory.appendingPathComponent(originalFileRelativePath)

            try createParentDirectoryIfNeeded(fileUrl: destinationUrl)

            let destinationPath = destinationUrl.path
            fileManager.createFile(atPath: destinationPath, contents: nil, attributes: nil)
            try swiftCode.write(toFile: destinationPath, atomically: true, encoding: .utf8)

            print("Output Swift code in \(destinationPath)")
        }
    }

    private func createParentDirectoryIfNeeded(fileUrl: URL) throws {
        let directoryUrl = fileUrl.deletingLastPathComponent()
        let directoryPath = directoryUrl.path

        let fileManager = FileManager.default

        if !fileManager.fileExists(atPath: directoryPath) {
            try fileManager.createDirectory(
                atPath: directoryPath, withIntermediateDirectories: true, attributes: nil
            )
        }
    }
}
