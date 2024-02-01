import Foundation

@main public struct XCTestDocProjectGen {
    private let directoryPath: String
    private let outputDirectory: String

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
            print("An error occurred while reading the directory \(directoryPath): \(error)")
        }
    }

    static func printUsage() {
        let usage = """
        USAGE: XCTestDocProjectGen <input directory> <output directory>

        ARGUMENTS:
            <input directory> (Required)
                The path of the output Symbol Graph JSON file representing the snippets for the a module or package
            <output directory> (Required)
                The module name to use for the Symbol Graph (typically should be the package name)
        """
        print(usage)
    }

    init(directoryPath: String, outputDirectory: String) {
        self.directoryPath = directoryPath
        self.outputDirectory = outputDirectory
    }

    func run() throws {
        let fileManager = FileManager.default
        let files = try fileManager.contentsOfDirectory(atPath: directoryPath)
        let testFiles = files.filter { $0.hasSuffix("Tests.swift") }

        print("Found \(testFiles.count) test files in \(directoryPath)")

        for testFile in testFiles {
            let filePath = (directoryPath as NSString).appendingPathComponent(testFile)
            guard let fileSource = try? String(contentsOfFile: filePath) else {
                print("Unable to read file at path: \(filePath)")
                continue
            }

            let testClasses = parseSwiftCode(source: fileSource)
            let swiftCode = generateEmptySwiftCode(testClasses: testClasses)

            let destinationPath = (outputDirectory as NSString).appendingPathComponent(testFile)
            let destinationUrl = URL(fileURLWithPath: destinationPath)
            let destinationDirectory = destinationUrl.deletingLastPathComponent()

            if !fileManager.fileExists(atPath: destinationDirectory.path) {
                do {
                    try fileManager.createDirectory(
                        atPath: destinationDirectory.path, withIntermediateDirectories: true, attributes: nil
                    )
                    print("Created directory: \(destinationDirectory.path)")
                } catch {
                    print("Failed to create directory in \(destinationDirectory.path): \(error)")
                    continue
                }
            }

            fileManager.createFile(atPath: destinationPath, contents: nil, attributes: nil)
            try swiftCode.write(toFile: destinationPath, atomically: true, encoding: .utf8)

            print("Output markdown in \(destinationPath)")
        }
    }
}
