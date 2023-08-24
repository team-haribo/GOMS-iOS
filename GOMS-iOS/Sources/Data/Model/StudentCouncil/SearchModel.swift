import Foundation

struct SearchModel: Codable {
    let data: SearchResponse
}

struct SearchResponse: Codable {
    let accountIdx: UUID
    let name: String
    let studentNum: StudentNum
    let profileUrl: String?
    let authority: String
    let isBlackList: Bool

    struct StudentNum: Codable{
        let grade: Int
        let classNum: Int
        let number: Int
    }
}
