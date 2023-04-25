//
//  SignInModel.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/25.
//

import Foundation

struct SignInModel: Codable {
    let data: SignInResponse
}

struct SignInResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let accessTokenExpiredAt: String
    let refreshTokenExpiredAt: String
    let authority: String
}
