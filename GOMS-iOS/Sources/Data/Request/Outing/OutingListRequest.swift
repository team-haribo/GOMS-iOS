import Foundation

struct OutingListRequest: Codable {
    let Authorization: String
    
    init(Authorization: String) {
        self.Authorization = Authorization
    }
}
