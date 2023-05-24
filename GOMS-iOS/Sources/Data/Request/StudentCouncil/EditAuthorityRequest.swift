import Foundation

struct EditAuthorityRequest: Codable {
    let Authorization: String
    let accountIdx: UUID
    let authority: String
    
    init(Authorization: String, accountIdx: UUID, authority: String) {
        self.Authorization = Authorization
        self.accountIdx = accountIdx
        self.authority = authority
    }
}
