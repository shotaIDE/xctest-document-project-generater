import Foundation

public struct TestClass: Hashable {
    let name: String
    let docComment: DocComment?

    public static func == (lhs: TestClass, rhs: TestClass) -> Bool {
        return lhs.name == rhs.name && lhs.docComment == rhs.docComment
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(docComment)
    }
}
