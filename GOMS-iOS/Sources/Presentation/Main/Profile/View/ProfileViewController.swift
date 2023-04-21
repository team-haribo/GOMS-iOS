//
//  ProfileViewController.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/21.
//

import UIKit
import Then
import SnapKit

class ProfileViewController: BaseViewController<BaseViewModel> {
    private let cellName = ["이름","학년","반","번호","지각횟수"]
    private let cellDetail = ["선민재","3","1","11","11"]
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
        userInfoTableView.delegate = self
        userInfoTableView.dataSource = self
        userInfoTableView.layer.cornerRadius = 20
        userInfoTableView.layer.masksToBounds = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private let profileImage = UIImageView().then {
        $0.image = UIImage(named: "profileImg")
    }
    
    private let userName = UILabel().then {
        $0.text = "선민재"
        $0.font = UIFont.GOMSFont(size: 18,family: .Medium)
        $0.textColor = .black
    }
    
    private let userNum = UILabel().then {
        $0.text = "3111"
        $0.font = UIFont.GOMSFont(size: 14,family: .Regular)
        $0.textColor = .subColor
    }
    
    private var logoutButton = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.applySketchShadow(
            color: UIColor.black,
            alpha: 0.1,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0
        )
        $0.layer.cornerRadius = 20
    }
    
    private let logoutText = UILabel().then {
        $0.text = "로그아웃"
        $0.font = UIFont.GOMSFont(size: 14, family: .Medium)
        $0.textColor = UIColor(
            red: 255 / 255,
            green: 126 / 255,
            blue: 126 / 255,
            alpha: 1
        )
    }
    
    private let logoutIcon = UIImageView().then {
        $0.image = UIImage(named: "logoutIcon.svg")
    }
    
    private let userInfoTableView = UITableView().then {
        $0.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileTableViewCell")
        $0.separatorStyle = .singleLine
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.isScrollEnabled = false
    }
    
    private let backgroundShadow = UIView().then {
        $0.layer.masksToBounds = false
        $0.layer.applySketchShadow(
            color: UIColor.black,
            alpha: 0.1,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0
        )
        $0.backgroundColor = UIColor.background
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = false
    }
    
    override func addView() {
        [profileImage, userName, userNum, backgroundShadow, userInfoTableView, logoutButton, logoutText, logoutIcon].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        profileImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset((bounds.height) / 7.31)
            $0.centerX.equalToSuperview()
        }
        userName.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        userNum.snp.makeConstraints {
            $0.top.equalTo(userName.snp.bottom).offset(0)
            $0.centerX.equalToSuperview()
        }
        backgroundShadow.snp.makeConstraints {
            $0.top.equalTo(userNum.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(26)
            $0.trailing.equalToSuperview().offset(-26)
            $0.bottom.equalToSuperview().inset((bounds.height) / 4.27)
        }
        userInfoTableView.snp.makeConstraints {
            $0.top.equalTo(userNum.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(26)
            $0.trailing.equalToSuperview().offset(-26)
            $0.bottom.equalToSuperview().inset((bounds.height) / 4.27)
        }
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(userInfoTableView.snp.bottom).offset(34)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(67)
        }
        logoutText.snp.makeConstraints {
            $0.centerY.equalTo(logoutButton.snp.centerY).offset(0)
            $0.leading.equalTo(logoutButton.snp.leading).offset(24)
        }
        logoutIcon.snp.makeConstraints {
            $0.centerY.equalTo(logoutButton.snp.centerY).offset(0)
            $0.trailing.equalTo(logoutButton.snp.trailing).inset(24)
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userInfoTableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        cell.cellName.text = cellName[indexPath.row]
        cell.cellDetail.text = cellDetail[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
}
