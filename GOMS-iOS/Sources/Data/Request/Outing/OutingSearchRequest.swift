import Foundation

struct OutingSearchRequest: Codable {
    let Authorization: String
    let name: String
    
    init(Authorization: String, name: String) {
        self.Authorization = Authorization
        self.name = name
    }
}

