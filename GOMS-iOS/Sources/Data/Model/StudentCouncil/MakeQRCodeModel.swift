import Foundation

struct MakeQRCodeModel: Codable {
    let data: MakeQRCodeResponse
}

struct MakeQRCodeResponse: Codable {
    let outingUUID: UUID
}
