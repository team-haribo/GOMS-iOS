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
    
    private let cellBackgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.applySketchShadow(
            color: UIColor.black,
            alpha: 0.1,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0
        )
        $0.layer.cornerRadius = 10
    }
    
    private let userProfileImage = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "dummyImage.svg")
    }
    
    private let studentName = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "선민재"
        $0.textColor = UIColor.black
        $0.font = UIFont.GOMSFont(size: 14, family: .Medium)
    }
    
    private let studentNum = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "3111"
        $0.textColor = UIColor.subColor
        $0.font = UIFont.GOMSFont(size: 12, family: .Regular)
    }
    
    func addView() {
        [cellBackgroundView, userProfileImage, studentName, studentNum].forEach {
            self.addSubview($0)
        }
    }
    
    func setLayout() {
        cellBackgroundView.snp.makeConstraints {
            $0.height.equalTo((bounds.width) / 3.87)
            $0.width.equalTo((bounds.height) / 6.76)
        }
        userProfileImage.snp.makeConstraints {
            $0.top.equalTo(cellBackgroundView.snp.top).offset(14)
            $0.centerX.equalTo(cellBackgroundView.snp.centerX).offset(0)
        }
        studentName.snp.makeConstraints {
            $0.top.equalTo(userProfileImage.snp.bottom).offset(16)
            $0.centerX.equalTo(cellBackgroundView.snp.centerX).offset(0)
        }
        studentNum.snp.makeConstraints {
            $0.top.equalTo(studentName.snp.bottom).offset(5)
            $0.centerX.equalTo(cellBackgroundView.snp.centerX).offset(0)
        }
    }
}
