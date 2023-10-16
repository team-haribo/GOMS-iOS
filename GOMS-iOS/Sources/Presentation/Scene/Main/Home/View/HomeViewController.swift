import Foundation
import UIKit
import Then
import SnapKit
import RxSwift
import Kingfisher

class HomeViewController: BaseViewController<HomeReactor> {
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem()
        self.navigationItem.leftLogoImage()
        super.viewDidLoad()
        tardyCollectionView.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkRole()
    }
    
    func checkRole() {
        if userAuthority == "ROLE_STUDENT_COUNCIL" {
            manageStudentButton.isHidden = false
            manageStudnetText.isHidden = false
            manageStudnetSubText.isHidden = false
            profileImg.isHidden = true
            profileButton.isHidden = true
            userNumText.isHidden = true
            userNameText.isHidden = true
            homeMainText.text = "간편하게\n수요외출제를\n관리해보세요"
            homeMainImage.image = UIImage(named: "adminHomeImage.svg")
            useQRCodeButton.backgroundColor = .adminColor
            useQRCodeButton.setTitle("생성하기", for: .normal)
        }
    }
    
    let homeMainImage = UIImageView().then {
        $0.image = UIImage(named: "homeUndraw.svg")
    }
    
    let homeMainText = UILabel().then {
        $0.text = "간편하게\n수요외출제를\n이용해보세요"
        $0.numberOfLines = 3
        $0.font = UIFont.GOMSFont(
            size: 24,
            family: .Bold
        )
        $0.textColor = .black
    }
    
    var useQRCodeButton = UIButton().then {
        $0.setTitle("외출하기", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont.GOMSFont(size: 14, family: .Bold)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .mainColor
    }
    
    private let outingButton = UIButton().then {
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
    
    private let totalStudentText = UILabel().then {
        $0.text = "현재 183명의 학생 중에서"
        $0.textColor = UIColor.subColor
        $0.font = UIFont.GOMSFont(size: 12, family: .Regular)
    }
    
   let outingStudentText = UILabel().then {
        $0.text = "0 명이 외출중이에요!"
        $0.textColor = UIColor.black
        $0.font = UIFont.GOMSFont(size: 16, family: .Medium)
        let fullText = $0.text ?? ""
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "0")
        attribtuedString.addAttribute(
            .foregroundColor,
            value: UIColor.mainColor!,
            range: range
        )
        $0.attributedText = attribtuedString
    }
    
    lazy var outingNavigationButton = UIImageView().then {
        $0.image = UIImage(named: "navigationButton.svg")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = userAuthority == "ROLE_STUDENT" ? .mainColor : .adminColor
    }
    
    private let tardyText = UILabel().then {
        $0.text = "지각의 전당"
        $0.textColor = UIColor(
            red: 120/255,
            green: 120/255,
            blue: 120/255,
            alpha: 1.00
        )
        $0.font = UIFont.GOMSFont(size: 20, family: .SemiBold)
    }
    
    private let layout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(
            width: (
                (UIScreen.main.bounds.width) / 3.87
            ),
            height: (
                (UIScreen.main.bounds.height) / 6.76
            )
        )
        $0.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5) //아이템 상하좌우 사이값 초기화
    }
    
    private let tardyCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        $0.isScrollEnabled = false
        $0.backgroundColor = .background
        $0.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "homeCell")
    }
    
    private let profileButton = UIButton().then {
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
    
    var profileImg = UIImageView().then {
        $0.image = UIImage(named: "dummyImage.svg")
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }
    
    var userNameText = UILabel().then {
        $0.text = "로딩중입니다..."
        $0.textColor = UIColor.black
        $0.font = UIFont.GOMSFont(size: 16, family: .Medium)
    }
    
    lazy var profileNavigationButton = UIImageView().then {
        $0.image = UIImage(named: "navigationButton.svg")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = userAuthority == "ROLE_STUDENT" ? .mainColor : .adminColor
    }
    
    var userNumText = UILabel().then {
        $0.text = "로딩중입니다..."
        $0.textColor = UIColor.subColor
        $0.font = UIFont.GOMSFont(size: 12, family: .Regular)
    }
    
    private let manageStudentButton = UIButton().then {
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
        $0.isHidden = true
    }
    
    private let manageStudnetSubText = UILabel().then {
        $0.text = "모든 학생들의 역할을 관리해보세요!"
        $0.textColor = UIColor.subColor
        $0.font = UIFont.GOMSFont(size: 12, family: .Regular)
        $0.isHidden = true
    }
    
    private let manageStudnetText = UILabel().then {
        $0.text = "학생 관리하기"
        $0.textColor = UIColor.black
        $0.font = UIFont.GOMSFont(size: 16, family: .Medium)
        $0.isHidden = true
    }
    
    override func addView() {
        [
            homeMainImage,
            homeMainText,
            useQRCodeButton,
            outingButton,
            totalStudentText,
            outingStudentText,
            outingNavigationButton,
            tardyText,
            tardyCollectionView,
            profileButton,
            profileImg,
            userNameText,
            userNumText,
            profileNavigationButton,
            manageStudentButton,
            manageStudnetSubText,
            manageStudnetText
        ].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        homeMainImage.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset((bounds.height)/25.375)
            $0.trailing.equalToSuperview().offset(16)
            $0.height.equalTo((bounds.height)/4.6666666667)
        }
        homeMainText.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset((bounds.height)/18.4545454545)
            $0.leading.equalToSuperview().offset(26)
        }
        useQRCodeButton.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset((bounds.height)/5.2051282051)
            $0.leading.equalToSuperview().offset(26)
            $0.height.equalTo((bounds.height) / 21.36)
            $0.trailing.equalTo(homeMainImage.snp.leading).inset(23)
        }
        outingButton.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset((bounds.height)/3.4117647059)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo((bounds.height) / 11.6)
        }
        totalStudentText.snp.makeConstraints {
            $0.top.equalTo(outingButton.snp.top).offset((bounds.height) / 54)
            $0.leading.equalTo(outingButton.snp.leading).offset(16)
        }
        outingStudentText.snp.makeConstraints {
            $0.top.equalTo(totalStudentText.snp.bottom).offset(6)
            $0.leading.equalTo(outingButton.snp.leading).offset(16)
        }
        outingNavigationButton.snp.makeConstraints {
            $0.centerY.equalTo(outingButton.snp.centerY).offset(0)
            $0.trailing.equalTo(profileButton.snp.trailing).inset(23)
        }
        tardyText.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset((bounds.height)/2.3882352941)
            $0.leading.equalToSuperview().offset(26)
        }
        tardyCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset((bounds.height)/2.1312335958)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(bounds.height / 6.7)
        }
        profileButton.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset((bounds.height)/1.5234521576)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(view.bounds.height / 11.6)
        }
        profileImg.snp.makeConstraints {
            $0.centerY.equalTo(profileButton.snp.centerY).offset(0)
            $0.leading.equalTo(profileButton.snp.leading).offset(16)
            $0.width.height.equalTo(40)
        }
        userNameText.snp.makeConstraints {
            $0.top.equalTo(profileButton.snp.top).offset((bounds.height) / 42.7368421053)
            $0.leading.equalTo(profileImg.snp.trailing).offset(14)
        }
        userNumText.snp.makeConstraints {
            $0.top.equalTo(userNameText.snp.bottom).offset((bounds.height) / 203)
            $0.leading.equalTo(profileImg.snp.trailing).offset(14)
        }
        profileNavigationButton.snp.makeConstraints {
            $0.centerY.equalTo(profileButton.snp.centerY).offset(0)
            $0.trailing.equalTo(profileButton.snp.trailing).inset(23)
        }
        manageStudentButton.snp.makeConstraints {
            $0.top.equalTo(tardyCollectionView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(70)
        }
        manageStudnetSubText.snp.makeConstraints {
            $0.top.equalTo(manageStudentButton.snp.top).offset(14)
            $0.leading.equalTo(manageStudentButton.snp.leading).offset(16)
        }
        manageStudnetText.snp.makeConstraints {
            $0.top.equalTo(manageStudnetSubText.snp.bottom).offset(6)
            $0.leading.equalTo(manageStudentButton.snp.leading).offset(16)
        }
    }
    
    // MARK: - Reactor
    
    override func bindAction(reactor: HomeReactor) {
        self.rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in HomeReactor.Action.fetchOutingCount }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        self.rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in HomeReactor.Action.fetchLateRank }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        self.rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in HomeReactor.Action.fetchProfile }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func bindView(reactor: HomeReactor) {
        navigationItem.rightBarButtonItem?.rx.tap
            .map { HomeReactor.Action.profileButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        useQRCodeButton.rx.tap
            .map { HomeReactor.Action.createQRCodeButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        outingButton.rx.tap
            .map { HomeReactor.Action.outingButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        profileButton.rx.tap
            .map { HomeReactor.Action.profileButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        manageStudentButton.rx.tap
            .map { HomeReactor.Action.manageButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func bindState(reactor: HomeReactor) {
        reactor.state
            .map{ $0.count }
            .distinctUntilChanged()
            .bind(to: outingStudentText.rx.outingCount)
            .disposed(by: disposeBag)
        reactor.state
            .map { $0.lateRank }
            .bind(
                to: tardyCollectionView.rx.items(cellIdentifier: "homeCell", cellType: HomeCollectionViewCell.self)
            ) { ip, item, cell in
                cell.backgroundColor = .white
                cell.layer.cornerRadius = 10
                cell.layer.applySketchShadow(
                    color: UIColor.black,
                    alpha: 0.1,
                    x: 0,
                    y: 2,
                    blur: 8,
                    spread: 0
                )
                let url = URL(string: item.profileUrl ?? "")
                cell.userProfileImage.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "dummyImage.svg")
                )
                cell.studentName.text = item.name
                cell.studentNum.text = "\(item.studentNum.grade)\(item.studentNum.classNum)\(item.studentNum.number)"
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.userData }
            .bind(to: self.rx.fetchUserData)
            .disposed(by: disposeBag)
        
    }
}
