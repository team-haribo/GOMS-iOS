import Foundation
import UIKit
import Then
import SnapKit

class RoleCell: UICollectionViewCell {
    static let identifier = "roleCell"
    
    let roleText = UILabel().then {
        $0.textColor = .subColor
        $0.font = UIFont.GOMSFont(size: 14, family: .Medium)
    }
    
    var backgroundButton = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
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
        [backgroundButton,roleText].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setLayout() {
        backgroundButton.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.width.equalTo(74)
            $0.center.equalToSuperview()
        }
        roleText.snp.makeConstraints {
            $0.center.equalTo(backgroundButton.snp.center).offset(0)
        }
    }
}
