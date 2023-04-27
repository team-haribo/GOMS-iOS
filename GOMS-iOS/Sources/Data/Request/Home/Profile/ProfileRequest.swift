//
//  ProfileRequest.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/27.
//

import Foundation

struct ProfileRequest: Codable {
    let Authorization: String
    
    init(Authorization: String) {
        self.Authorization = Authorization
    }
}
