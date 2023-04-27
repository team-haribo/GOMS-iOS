import Foundation

struct OutingCountModel: Codable {
    let data: OutingCountResponse
}

struct OutingCountResponse: Codable {
    let outingCount: Int
}
