//
//  ProfileTableViewCell.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/21.
//
import UIKit
import Then
import SnapKit

class ProfileTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addView()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cellName = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.GOMSFont(size: 16,family: .Medium)
    }
    
    let cellDetail = UILabel().then {
        $0.textColor = .subColor
        $0.font = UIFont.GOMSFont(size: 14,family: .Regular)
    }
    
    func addView() {
        [cellName, cellDetail].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setLayout() {
        cellName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(24)
        }
        
        cellDetail.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
}
