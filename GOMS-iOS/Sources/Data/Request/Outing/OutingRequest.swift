import Foundation

struct OutingRequest: Codable {
    let Authorization: String
    
    init(Authorization: String) {
        self.Authorization = Authorization
    }
}
