import Foundation

struct SearchRequest: Codable {
    let grade: Int?
    let classNum: Int?
    let name: String?
    let isBlackList: Bool
    let authority: String?
    
    init(
        grade: Int?,
        classNum: Int?,
        name: String?,
        isBlackList: Bool,
        authority: String?
    ) {
        self.grade = grade
        self.classNum = classNum
        self.name = name
        self.isBlackList = isBlackList
        self.authority = authority
    }
}
