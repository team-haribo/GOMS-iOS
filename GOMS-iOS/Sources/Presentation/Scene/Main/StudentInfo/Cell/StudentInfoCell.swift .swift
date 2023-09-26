import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class StudentInfoCell: UICollectionViewCell {
    static let identifier = "studentInfoCell"

    let userProfile = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 24
        $0.layer.masksToBounds = true
    }

    var editUserAuthorityButtonAction : (() -> ())?

    var deleteBlackListButtonAction : (() -> ())?

    let userName = UILabel().then {
        $0.font = UIFont.GOMSFont(size: 16, family:.Regular)
        $0.textColor = .black
    }

    let userNum = UILabel().then {
        $0.font = UIFont.GOMSFont(size: 14, family:.Regular)
        $0.textColor = .subColor
    }

    var editUserAuthorityButton = UIButton().then {
        $0.backgroundColor = .white
        $0.setImage(UIImage(named:"editStudent.svg"), for: .normal)
    }

    var deleteBlackListButton = UIButton().then {
        $0.isHidden = true
        $0.backgroundColor = .white
        $0.setImage(UIImage(named:"deleteBlackList.svg"), for: .normal)
    }

    var roleView = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.adminColor?.cgColor
        $0.layer.cornerRadius = 8
    }

    var roleText = UILabel().then {
        $0.isHidden = true
        $0.text = "학생회"
        $0.textColor = .adminColor
        $0.font = UIFont.GOMSFont(size: 9, family: .Regular)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addView()
        self.setLayout()
        self.editUserAuthorityButton.addTarget(
            self,
            action: #selector(editUserAuthorityButtonDidTap),
            for: .touchUpInside
        )
        self.deleteBlackListButton.addTarget(
            self,
            action: #selector(edeleteBlackListButtonDidTap),
            for: .touchUpInside
        )
    }

    @objc func editUserAuthorityButtonDidTap() {
        self.editUserAuthorityButtonAction?()
    }

    @objc func edeleteBlackListButtonDidTap() {
        self.deleteBlackListButtonAction?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addView() {
        [userProfile, userName, userNum, editUserAuthorityButton, roleView, roleText, deleteBlackListButton].forEach {
            contentView.addSubview($0)
        }
    }

    func setLayout() {
        userProfile.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.height.width.equalTo(50)
        }
        userName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.equalTo(userProfile.snp.trailing).offset(24)
        }
        userNum.snp.makeConstraints {
            $0.top.equalTo(userName.snp.bottom).offset(6)
            $0.leading.equalTo(userProfile.snp.trailing).offset(24)
        }
        editUserAuthorityButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(17)
        }
        roleView.snp.makeConstraints {
            $0.centerX.equalTo(userProfile.snp.centerX).offset(0)
            $0.bottom.equalToSuperview().inset(15)
            $0.height.equalTo(16)
            $0.width.equalTo(50)
        }
        roleText.snp.makeConstraints {
            $0.center.equalTo(roleView.snp.center).offset(0)
        }
        deleteBlackListButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(17)
        }
    }
}
