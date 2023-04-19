//
//  HomeCollectionViewCell.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/19.
//

import Foundation
import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    static let identifier = "homeCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addView()
        self.setLayout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let userProfileImage = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let studentName = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor.black
        $0.font = UIFont.GOMSFont(size: 14, family: .Medium)
    }
    
    let studentNum = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor.subColor
        $0.font = UIFont.GOMSFont(size: 12, family: .Regular)
    }
    
    func addView() {
        [userProfileImage, studentName, studentNum].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setLayout() {
        userProfileImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.centerX.equalToSuperview().offset(0)
        }
        studentName.snp.makeConstraints {
            $0.top.equalTo(userProfileImage.snp.bottom).offset(16)
            $0.centerX.equalToSuperview().offset(0)
        }
        studentNum.snp.makeConstraints {
            $0.top.equalTo(studentName.snp.bottom).offset(5)
            $0.centerX.equalToSuperview().offset(0)
        }
    }
}
