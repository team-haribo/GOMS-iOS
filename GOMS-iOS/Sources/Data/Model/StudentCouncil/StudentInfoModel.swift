import Foundation

struct StudentInfoModel: Codable {
    let data: StudentInfoResponse
}

struct StudentInfoResponse: Codable {
    let accountIdx: UUID
    let name: String
    let studentNum: StudentNum
    let profileUrl: String?
    let authority: String
    
    struct StudentNum: Codable{
        let grade: Int
        let classNum: Int
        let number: Int
    }
}
