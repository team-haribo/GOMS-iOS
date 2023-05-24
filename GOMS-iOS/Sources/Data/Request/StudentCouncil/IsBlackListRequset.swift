import Foundation

struct IsBlackListRequset: Codable {
    let Authorization: String
    let accountIdx: UUID
    
    init(Authorization: String, accountIdx: UUID) {
        self.Authorization = Authorization
        self.accountIdx = accountIdx
    }
}
