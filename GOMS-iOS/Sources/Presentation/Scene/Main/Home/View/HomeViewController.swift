//
//  HomeViewController.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import Foundation
import UIKit
import Then
import SnapKit
import RxSwift
import Kingfisher

class HomeViewController: BaseViewController<HomeViewModel>, HomeViewModelDelegate {
    
    private let userGrade = UserDefaults.standard.integer(forKey: "userGrade")
    private let userClassNum = UserDefaults.standard.integer(forKey: "userClassNum")
    private let userNum = UserDefaults.standard.integer(forKey: "userNum")
    private let userProfileURL = UserDefaults.standard.string(forKey: "userProfileURL")
    private let userIsBlackList = UserDefaults.standard.bool(forKey: "userIsBlackList")
    private let userIsOuting = UserDefaults.standard.bool(forKey: "userIsOuting")
    private var userNameList = [String]()
    private var userGradeList = [Int]()
    private var userClassNumList = [Int]()
    private var userNumList = [Int]()
    private var userProfile = [String]()
    private var outingCount:Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        checkRole()
    }
    
    override func viewDidLoad() {
        checkRole()
        super.viewDidLoad()
        viewModel.delegate = self
        self.navigationItem.rightBarButtonItem()
        self.navigationItem.leftLogoImage()
        refreshScrollView.frame = view.bounds
        refreshScrollView.alwaysBounceVertical = true
        refreshScrollView.refreshControl = refreshControl
        tardyCollectionView.collectionViewLayout = layout
        bindViewModel()
    }
    
    private func checkRole() {
        if userAuthority == "ROLE_STUDENT_COUNCIL" {
            profileImg.isHidden = true
            profileButton.isHidden = true
            profileNavigationButton.isHidden = true
            manageNavigationButton.isHidden = false
            userNameText.isHidden = true
            userNumText.isHidden = true
            useQRCodeButton.setTitle("QR 생성하기", for: .normal)
            useQRCodeButton.backgroundColor = .adminColor
            outingNavigationButton.tintColor = .adminColor
            manageNavigationButton.tintColor = .adminColor
            homeMainText.text = "간편하게\n수요외출제를\n관리해보세요"
            homeMainImage.image = UIImage(named: "adminHomeImage.svg")
            manageStudnetText.isHidden = false
            manageStudentButton.isHidden = false
            manageStudnetSubText.isHidden = false
        }
    }
    
    private func checkUserIsOuting() {
        if viewModel.userData?.isOuting == true {
            useQRCodeButton.setTitle("복귀하기", for: .normal)
        }
        else if viewModel.userData?.isOuting == false {
            useQRCodeButton.setTitle("외출하기", for: .normal)
        }
    }
    
    private func getData() {
        viewModel.getUserData { [weak self] in
            self?.checkUserIsOuting()
            self?.checkRole()
        }
        viewModel.getOutingCount{ [weak self] in
            self?.setOuting()
        }
        viewModel.getLateRank { [weak self] in
            self?.bindLateRank()
        }
    }
    
    private func setOuting() {
        let outingCount = viewModel.outingCount?.outingCount ?? 0
        outingStudentText.text = "\(outingCount) 명이 외출중이에요!"
        let fullText = outingStudentText.text ?? ""
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "\(outingCount)")
        attribtuedString.addAttribute(
            .foregroundColor,
            value: userAuthority == "ROLE_STUDENT_COUNCIL" ? UIColor.adminColor! : UIColor.mainColor!,
            range: range
        )
        outingStudentText.attributedText = attribtuedString
    }
    
    private func bindLateRank() {
        if viewModel.lateRank.isEmpty {
            print("empty")
        }
        else {
            for index in 0...viewModel.lateRank.endIndex - 1 {
                userNameList.insert(viewModel.lateRank[index].name, at: index)
                userGradeList.insert(viewModel.lateRank[index].studentNum.grade, at: index)
                userClassNumList.insert(viewModel.lateRank[index].studentNum.classNum, at: index)
                userNumList.insert(viewModel.lateRank[index].studentNum.number, at: index)
                userProfile.insert(viewModel.lateRank[index].profileUrl ?? "", at: index)
            }
            tardyCollectionView.dataSource = self
            tardyCollectionView.delegate = self
            tardyCollectionView.register(
                HomeCollectionViewCell.self,
                forCellWithReuseIdentifier: HomeCollectionViewCell.identifier
            )
        }
    }
    
    private func bindViewModel() {
        let input = HomeViewModel.Input(
            refreshAction: refreshControl.rx.controlEvent(.valueChanged).map { _ in }.asObservable(),
            navProfileButtonTap: navigationItem.rightBarButtonItem!.rx.tap.asObservable(),
            outingButtonTap: outingButton.rx.tap.asObservable(),
            profileButtonTap: profileButton.rx.tap.asObservable(),
            useQRCodeButtonTap: useQRCodeButton.rx.tap.asObservable(),
            manageStudentButtonTap: manageStudentButton.rx.tap.asObservable()
        )
        viewModel.transVC(input: input)
    }
    
    private func updateOutingStudentText() {
        let viewModel = HomeViewModel()
        viewModel.getOutingCount { [weak self] in
            DispatchQueue.main.async {
                let count = viewModel.outingCount?.outingCount
                self?.outingStudentText.text = "\(count ?? 0) 명이 외출중이에요!"
                let fullText = self?.outingStudentText.text ?? ""
                let attributedString = NSMutableAttributedString(string: fullText)
                let range = (fullText as NSString).range(of: "\(count ?? 0)")
                attributedString.addAttribute(.foregroundColor, value: self?.userAuthority == "ROLE_STUDENT_COUNCIL" ? UIColor.adminColor! : UIColor.mainColor!, range: range)
                self?.outingStudentText.attributedText = attributedString
            }
        }
    }
    
    func refreshMain() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl.endRefreshing()
            self.updateOutingStudentText()
        }
    }
    
    private let refreshScrollView = UIScrollView()
    
    private let refreshControl = UIRefreshControl()
    
    private let homeMainImage = UIImageView().then {
        $0.image = UIImage(named: "homeUndraw.svg")
    }
    
    private let homeMainText = UILabel().then {
        $0.text = "간편하게\n수요외출제를\n이용해보세요"
        $0.numberOfLines = 3
        $0.font = UIFont.GOMSFont(
            size: 24,
            family: .Bold
        )
        $0.textColor = .black
    }
    
    private lazy var useQRCodeButton = UIButton().then {
        var text = userIsBlackList == true ? "외출금지" : "외출하기"
        if userIsBlackList == true {
            text = "외출금지"
        }
        else if userIsOuting == true {
            text = "복귀하기"
        }
        else {
            text = "외출하기"
        }
        $0.setTitle(text, for: .normal)
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
    
    private lazy var outingStudentText = UILabel().then {
        $0.text = "0 명이 외출중이에요!"
        $0.textColor = UIColor.black
        $0.font = UIFont.GOMSFont(size: 16, family: .Medium)
        let fullText = $0.text ?? ""
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "0")
        attribtuedString.addAttribute(
            .foregroundColor,
            value: userAuthority == "ROLE_STUDENT_COUNCIL" ? UIColor.adminColor! : UIColor.mainColor!,
            range: range
        )
        $0.attributedText = attribtuedString
    }
    
    private let outingNavigationButton = UIImageView().then {
        $0.image = UIImage(named: "navigationButton.svg")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .mainColor
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
    
    private lazy var profileImg = UIImageView().then {
        let url = URL(string: userProfileURL ?? "")
        let imageCornerRadius = RoundCornerImageProcessor(cornerRadius: 20)
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.kf.setImage(
            with: url,
            placeholder:UIImage(named: "dummyImage.svg"),
            options: [.processor(imageCornerRadius)]
        )
    }
    
    private lazy var userNameText = UILabel().then {
        $0.text = UserDefaults.standard.string(forKey: "userName")
        $0.textColor = UIColor.black
        $0.font = UIFont.GOMSFont(size: 16, family: .Medium)
    }
    
    private let profileNavigationButton = UIImageView().then {
        $0.image = UIImage(named: "navigationButton.svg")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .mainColor
    }
    
    private lazy var userNumText = UILabel().then {
        $0.text = "\(self.userGrade)학년 \(self.userClassNum)반 \(self.userNum)번"
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
    
    private let manageNavigationButton = UIImageView().then {
        $0.isHidden = true
        $0.image = UIImage(named: "navigationButton.svg")?.withRenderingMode(.alwaysTemplate)
    }
    
    override func addView() {
        [refreshScrollView,homeMainImage, homeMainText, useQRCodeButton, outingButton, totalStudentText, outingStudentText, outingNavigationButton, tardyText, tardyCollectionView, profileButton, profileImg ,userNameText, userNumText, profileNavigationButton, manageStudentButton, manageStudnetSubText,manageStudnetText, manageNavigationButton].forEach {
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
        manageNavigationButton.snp.makeConstraints {
            $0.centerY.equalTo(manageStudentButton.snp.centerY).offset(0)
            $0.trailing.equalTo(manageStudentButton.snp.trailing).inset(23)
        }
    }
}

extension HomeViewController :
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userNameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
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
        cell.studentName.text = "\(userNameList[indexPath.row])"
        if userNumList[indexPath.row] < 10 {
            cell.studentNum.text = "\(userGradeList[indexPath.row])\(userClassNumList[indexPath.row])0\(userNumList[indexPath.row])"
        }
        else {
            cell.studentNum.text = "\(userGradeList[indexPath.row])\(userClassNumList[indexPath.row])\(userNumList[indexPath.row])"
        }
        let url = URL(string: userProfile[indexPath.row])
        let imageCornerRadius = RoundCornerImageProcessor(cornerRadius: 40)
        cell.userProfileImage.kf.setImage(
            with: url,
            placeholder:UIImage(named: "dummyImage.svg"),
            options: [.processor(imageCornerRadius)]
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((bounds.width) / 3.87), height: ((bounds.height) / 6.76))
    }
}
