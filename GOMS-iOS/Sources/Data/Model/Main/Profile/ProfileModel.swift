//
//  ProfileModel.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/27.
//

import Foundation

struct ProfileModel: Codable {
    let data: ProfileResponse
}

struct ProfileResponse: Codable {
    let accountIdx: UUID
    let name: String
    let studentNum: StudentNum
    let profileUrl: String
    let rateCount: String
    
    struct StudentNum: Codable{
        let grade: Int
        let classNum: Int
        let number: Int
    }
}
