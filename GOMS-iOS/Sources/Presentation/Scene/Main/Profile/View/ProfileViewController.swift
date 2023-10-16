import UIKit
import Then
import SnapKit
import Foundation
import Kingfisher
import RxSwift
import RxCocoa

class ProfileViewController: BaseViewController<ProfileReactor> {
    
    private let cellName = ["이름","학년","반","번호","지각횟수"]
    
    var cellDetail = ["로딩중..","로딩중..","로딩중..","로딩중..","로딩중.."]
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
        userInfoTableView.layer.cornerRadius = 20
        userInfoTableView.layer.masksToBounds = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    var profileImage = UIImageView().then {
        $0.image = UIImage(named: "DummyProfile.svg")
        $0.layer.cornerRadius = 50
        $0.layer.masksToBounds = true
    }
    
    var userNameText = UILabel().then {
        $0.text = "로딩중..."
        $0.font = UIFont.GOMSFont(size: 18,family:.Medium)
        $0.textColor = .black
    }
    
    var userNumText = UILabel().then {
        $0.text = "로딩중..."
        $0.font = UIFont.GOMSFont(size: 14,family:.Regular)
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
        $0.font = UIFont.GOMSFont(size: 14,family: .Medium)
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
    
    let userInfoTableView = UITableView().then {
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
        $0.backgroundColor = .background
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = false
    }
    
    override func addView() {
        [
            profileImage,
            userNameText,
            userNumText,
            backgroundShadow,
            userInfoTableView,
            logoutButton,
            logoutText,
            logoutIcon
        ].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        profileImage.snp.makeConstraints {
            $0.bottom.equalTo(userNameText.snp.top).offset(-6)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(100)
        }
        userNameText.snp.makeConstraints {
            $0.bottom.equalTo(userInfoTableView.snp.top).offset(-49)
            $0.centerX.equalToSuperview()
        }
        userNumText.snp.makeConstraints {
            $0.top.equalTo(userNameText.snp.bottom).offset(0)
            $0.centerX.equalToSuperview()
        }
        backgroundShadow.snp.makeConstraints {
            $0.top.equalTo(userNumText.snp.bottom).offset((bounds.height) / 2.82)
            $0.leading.equalToSuperview().offset(26)
            $0.trailing.equalToSuperview().offset(-26)
            $0.bottom.equalToSuperview().inset((bounds.height) / 4.2736842105)
        }
        userInfoTableView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset((bounds.height) / 2.82)
            $0.leading.equalToSuperview().offset(26)
            $0.trailing.equalToSuperview().offset(-26)
            $0.bottom.equalToSuperview().inset((bounds.height) / 4.2736842105)
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
    
    override func bindView(reactor: ProfileReactor) {
        logoutButton.rx.tap
            .map {ProfileReactor.Action.logoutButtonDidTap}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func bindAction(reactor: ProfileReactor) {
        self.rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in ProfileReactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func bindState(reactor: ProfileReactor) {
        reactor.state
            .map { $0.userData }
            .bind(to: self.rx.cellDetail)
            .disposed(by: disposeBag)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userInfoTableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        cell.cellName.text = cellName[indexPath.row]
        cell.cellDetail.text = "\(cellDetail[indexPath.row])"
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (bounds.height / 2.42) / 5
    }
}
