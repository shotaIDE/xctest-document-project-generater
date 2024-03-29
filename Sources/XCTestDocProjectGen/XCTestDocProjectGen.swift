import Foundation

@main public struct XCTestDocProjectGen {
    private let inputDirectoryPath: String
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

        let module = Self(inputDirectoryPath: directoryPath, outputDirectoryPath: markdownOutputDirectory)

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

    init(inputDirectoryPath: String, outputDirectoryPath: String) {
        self.inputDirectoryPath = inputDirectoryPath
        self.outputRootDirectory = outputDirectoryPath
    }

    func run() throws {
        let fileManager = FileManager.default

        let originalFileRelativePaths = findTestSwiftFileRelativePaths(in: inputDirectoryPath)

        print("Found \(originalFileRelativePaths.count) test files in \(inputDirectoryPath)")
        if originalFileRelativePaths.isEmpty {
            exit(0)
        }

        for originalFileRelativePath in originalFileRelativePaths {
            print("Found test file at \(originalFileRelativePath)")
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
            let originalFilePath = (inputDirectoryPath as NSString).appendingPathComponent(originalFileRelativePath)
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

    private func convertToAbsolutePath(path: String) -> String {
        let fileManager = FileManager.default

        let currentDirectoryUrl = URL(fileURLWithPath: fileManager.currentDirectoryPath)

        let absoluteUrl = URL(fileURLWithPath: path, relativeTo: currentDirectoryUrl).standardized

        return absoluteUrl.path
    }

    private func findTestSwiftFileRelativePaths(in directoryPath: String) -> [String] {
        let fileManager = FileManager.default
        let directoryAbsolutePath = convertToAbsolutePath(path: directoryPath)
        let directoryAbsoluteUrl = URL(fileURLWithPath: directoryAbsolutePath)

        print("Target directory path: \(directoryPath)")
        print("Target directory absolute path: \(directoryAbsolutePath)")

        guard let enumerator = fileManager.enumerator(
            at: directoryAbsoluteUrl,
            includingPropertiesForKeys: [.isRegularFileKey]
        ) else {
            print("Could not create directory enumerator")
            return []
        }

        var originalFileAbsolutePaths: [String] = []

        for case let fileURL as URL in enumerator {
            if let isRegularFile = try? fileURL.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile,
               isRegularFile,
               isTestSwiftFile(filePath: fileURL.path) {
                originalFileAbsolutePaths.append(fileURL.path)
            }
        }

        return originalFileAbsolutePaths.map {
            $0.replacingOccurrences(of: "\(directoryAbsolutePath)/", with: "")
        }
    }

    private func isTestSwiftFile(filePath: String) -> Bool {
        filePath.hasSuffix("Tests.swift")
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
