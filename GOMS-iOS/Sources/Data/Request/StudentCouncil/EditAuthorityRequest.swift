import Foundation

struct EditAuthorityRequest: Codable {
    let accountIdx: UUID
    let authority: String
    
    init(accountIdx: UUID, authority: String) {
        self.accountIdx = accountIdx
        self.authority = authority
    }
}
