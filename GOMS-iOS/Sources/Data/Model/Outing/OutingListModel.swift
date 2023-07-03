import Foundation

struct OutingListModel: Codable {
    let data: OutingListResponse
}

struct OutingListResponse: Codable {
    let accountIdx: UUID
    let name: String
    let studentNum: StudentNum
    let profileUrl: String?
    let createdTime: String
    
    struct StudentNum: Codable{
        let grade: Int
        let classNum: Int
        let number: Int
    }
}
