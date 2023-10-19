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
    
    var userProfileImage = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }
    
    var studentName = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor.gomsBlack
        $0.font = UIFont.GOMSFont(size: 14, family: .Medium)
    }
    
    var studentNum = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor.n20
        $0.font = UIFont.GOMSFont(size: 12, family: .Regular)
    }
    
    func addView() {
        [userProfileImage, studentName, studentNum].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setLayout() {
        userProfileImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset((bounds.height)/8.5714285714)
            $0.centerX.equalToSuperview().offset(0)
            $0.width.height.equalTo(40)
        }
        studentName.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset((bounds.height)/3.6363636364)
            $0.centerX.equalToSuperview().offset(0)
        }
        studentNum.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset((bounds.height)/8.5714285714)
            $0.centerX.equalToSuperview().offset(0)
        }
    }
}
