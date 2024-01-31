import Foundation

public struct DocComment: Hashable {
    let summary: String
    let description: String?
    let lines: [String]
}
