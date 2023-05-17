import Foundation

struct SearchRequest: Codable {
    let Authorization: String
    let grade: Int?
    let classNum: Int?
    let name: String?
    let isBlackList: Bool
    let authority: String?
    
    init(
        Authorization: String,
        grade: Int?,
        classNum: Int?,
        name: String?,
        isBlackList: Bool,
        authority: String?
    ) {
        self.Authorization = Authorization
        self.grade = grade
        self.classNum = classNum
        self.name = name
        self.isBlackList = isBlackList
        self.authority = authority
    }
}
