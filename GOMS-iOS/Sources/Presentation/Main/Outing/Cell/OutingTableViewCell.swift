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
    
    let userProfile = UIImageView()
    
    let userName = UILabel().then {
        $0.font = UIFont.GOMSFont(size: 16, family:.Regular)
        $0.textColor = .black
    }
    
    let userNum = UILabel().then {
        $0.font = UIFont.GOMSFont(size: 14, family:.Regular)
        $0.textColor = .subColor
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
