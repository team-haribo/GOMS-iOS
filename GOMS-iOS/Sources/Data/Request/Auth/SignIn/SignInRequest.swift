//
//  SignInRequest.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/25.
//

import Foundation

struct SignInRequest: Codable {
    let code: String
    
    init(code: String) {
        self.code = code
    }
}
