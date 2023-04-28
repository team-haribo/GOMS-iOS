import Foundation

struct RefrshTokenModel: Codable {
    let data: RefrshTokenesponse
}

struct RefrshTokenesponse: Codable {
    let accessToken: String
    let refreshToken: String
    let accessTokenExp: String
    let refreshTokenExp: String
    let authority: String
}
