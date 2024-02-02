import Foundation
import PackagePlugin

@main public struct XCTestDocProjectGen: CommandPlugin {
    public init() {}

    public func performCommand(context: PluginContext, arguments: [String]) throws {
        print("Test output")
    }
}
