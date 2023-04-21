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
    
    private let userInfoTableView = UITableView().then {
        $0.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileTableViewCell")
        $0.separatorStyle = .singleLine
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.rowHeight = 67
        $0.isScrollEnabled = false
        $0.layer.applySketchShadow(
            color: UIColor.black,
            alpha: 0.1,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0
            )
        }
    
    override func addView() {
        [profileImage, userName, userNum, userInfoTableView].forEach {
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
        userInfoTableView.snp.makeConstraints {
            $0.top.equalTo(userNum.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(26)
            $0.trailing.equalToSuperview().offset(-26)
            $0.bottom.equalToSuperview().inset(190)
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
