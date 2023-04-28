import Foundation

struct LateRankRequest: Codable {
    let Authorization: String
    
    init(Authorization: String) {
        self.Authorization = Authorization
    }
}
