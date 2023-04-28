import Foundation

struct LateRankModel: Codable {
    let data: OutingListResponse
}

struct LateRankResponse: Codable {
    let accountIdx: UUID
    let name: String
    let studentNum: StudentNum
    let profileUrl: String?
    
    struct StudentNum: Codable{
        let grade: Int
        let classNum: Int
        let number: Int
    }
}
