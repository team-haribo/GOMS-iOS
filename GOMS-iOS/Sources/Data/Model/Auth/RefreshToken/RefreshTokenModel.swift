import Foundation

struct RefreshTokenModel: Codable {
    let data: RefreshTokenesponse
}

struct RefreshTokenesponse: Codable {
    let accessToken: String
    let refreshToken: String
    let accessTokenExp: String
    let refreshTokenExp: String
    let authority: String
}
