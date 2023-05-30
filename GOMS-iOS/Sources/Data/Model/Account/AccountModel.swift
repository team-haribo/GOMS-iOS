import Foundation

struct AccountModel: Codable {
    let data: AccountResponse
}

struct AccountResponse: Codable {
    let accountIdx: UUID
    let name: String
    let studentNum: StudentNum
    let profileUrl: String?
    let lateCount: Int
    let isBlackList: Bool
    let isOuting: Bool
    
    struct StudentNum: Codable{
        let grade: Int
        let classNum: Int
        let number: Int
    }
}
