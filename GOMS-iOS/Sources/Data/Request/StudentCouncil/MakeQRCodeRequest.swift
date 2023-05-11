import Foundation

struct MakeQRCodeRequest: Codable {
    let Authorization: String
    
    init(Authorization: String) {
        self.Authorization = Authorization
    }
}
