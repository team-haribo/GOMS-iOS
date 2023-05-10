import Foundation

struct OutingRequest: Codable {
    let Authorization: String
    let outingUUID: UUID
    
    init(Authorization: String, outingUUID: UUID) {
        self.Authorization = Authorization
        self.outingUUID = outingUUID
    }
}
