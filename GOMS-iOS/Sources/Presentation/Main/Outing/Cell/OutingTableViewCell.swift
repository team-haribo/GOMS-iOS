//
//  OutingTableViewCell.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/20.
//

import UIKit
import Then
import SnapKit

class OutingTableViewCell: UITableViewCell {
    
    let userProfile = UIImageView().then {
        $0.image = UIImage(named: "userProfile.svg")
    }
    
    let userName = UILabel().then {
        $0.text = "선민재"
        $0.font = UIFont.GOMSFont(size: 16, family:.Regular)
        $0.textColor = .black
    }
    
    let userNum = UILabel().then {
        $0.text = "3학년 1반 11번"
        $0.font = UIFont.GOMSFont(size: 14, family:.Regular)
        $0.textColor = .subColor
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView() {
        [userProfile, userName, userNum].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setLayout() {
        userProfile.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
        }
        userName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.equalTo(userProfile.snp.trailing).offset(24)
        }
        userNum.snp.makeConstraints {
            $0.top.equalTo(userName.snp.bottom).offset(6)
            $0.leading.equalTo(userProfile.snp.trailing).offset(24)
        }
    }
}
