import Foundation

struct OutingSearchModel: Codable {
    let data: OutingSearchResponse
}

struct OutingSearchResponse: Codable {
    let accountIdx: UUID
    let name: String
    let studentNum: StudentNum
    let profileUrl: String?
    let createdTime: String
    
    struct StudentNum: Codable {
        let grade: Int
        let classNum: Int
        let number: Int
    }
}
