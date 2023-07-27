//
//  OutingTableViewCell.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/20.
//

import UIKit
import Then
import SnapKit

class OutingCollectionViewCell: UICollectionViewCell {
    static let identifier = "outingCell"
        
    let userProfile = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 23
        $0.layer.masksToBounds = true
    }
    
    let userName = UILabel().then {
        $0.font = UIFont.GOMSFont(size: 16, family:.Regular)
        $0.textColor = .black
    }
    
    let userNum = UILabel().then {
        $0.font = UIFont.GOMSFont(size: 14, family:.Regular)
        $0.textColor = .subColor
    }
    
    let createTime = UILabel().then {
        $0.font = UIFont.GOMSFont(size: 12, family:.Regular)
        $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addView()
        self.setLayout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView() {
        [userProfile, userName, userNum, createTime].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setLayout() {
        userProfile.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(50)
        }
        userName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.equalTo(userProfile.snp.trailing).offset(24)
        }
        userNum.snp.makeConstraints {
            $0.top.equalTo(userName.snp.bottom).offset(6)
            $0.leading.equalTo(userProfile.snp.trailing).offset(24)
        }
        createTime.snp.makeConstraints {
            $0.leading.equalTo(userNum.snp.trailing).offset(6)
            $0.centerY.equalTo(userNum.snp.centerY).offset(0)
        }
    }
}
