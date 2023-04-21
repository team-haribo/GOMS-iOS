//
//  ProfileTableViewCell.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/21.
//
import UIKit
import Then
import SnapKit

class ProfileCollectionViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addView()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let cellName = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.GOMSFont(size: 16,family: .Medium)
    }
    
    private let cellResult = UILabel().then {
        $0.textColor = .subColor
        $0.font = UIFont.GOMSFont(size: 14,family: .Regular)
    }
    
    func addView() {
        [cellName, cellResult].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setLayout() {
        cellName.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
        }
        
        cellResult.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
        }
    }
}
