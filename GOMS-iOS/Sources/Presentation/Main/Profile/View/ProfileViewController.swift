//
//  ProfileViewController.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/21.
//

import UIKit
import Then
import SnapKit

class ProfileViewController: BaseViewController<BaseViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private let profileImage = UIImageView().then {
        $0.image = UIImage(named: "profileImg")
    }
    
    private let userName = UILabel().then {
        $0.text = "선민재"
        $0.font = UIFont.GOMSFont(size: 18,family: .Medium)
        $0.textColor = .black
    }
    
    private let userNum = UILabel().then {
        $0.text = "3111"
        $0.font = UIFont.GOMSFont(size: 14,family: .Regular)
        $0.textColor = .subColor
    }
    
    override func addView() {
        [profileImage, userName, userNum].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        profileImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset((bounds.height) / 7.31)
            $0.centerX.equalToSuperview()
        }
        userName.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        userNum.snp.makeConstraints {
            $0.top.equalTo(userName.snp.bottom).offset(0)
            $0.centerX.equalToSuperview()
        }
    }
}
