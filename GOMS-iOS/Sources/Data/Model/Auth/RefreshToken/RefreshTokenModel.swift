import Foundation

struct RefreshTokenModel: Codable {
    let data: ReFreshTokenResponse
}

struct ReFreshTokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let accessTokenExp: String
    let refreshTokenExp: String
    let authority: String
}
