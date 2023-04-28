import Foundation

struct RefreshTokenRequest: Codable {
    let Authorization: String
    
    init(Authorization: String) {
        self.Authorization = Authorization
    }
}
