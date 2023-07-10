//
//  OutingViewController.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import UIKit
import Then
import SnapKit
import RxSwift
import Kingfisher

class OutingViewController: BaseViewController<OutingViewModel> {
    private var userNameList = [String]()
    private var userGradeList = [Int]()
    private var userClassNumList = [Int]()
    private var userNumList = [Int]()
    private var userProfile = [String]()
    private var createTime = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await getData()
        }
        self.navigationItem.rightBarButtonItem()
        self.navigationItem.leftLogoImage()
        outingCollectionView.collectionViewLayout = layout
        bindViewModel()
        bindOutingList()
    }
    
    private func getData() async {
        viewModel.outingList { [weak self] in
            self?.bindOutingList()
        }
    }
    
    private func bindOutingList() {
        if viewModel.outingList.isEmpty {
            outingCollectionView.isHidden = true
            outingIsNilImage.isHidden = false
            outingIsNilText.isHidden = false
        }
        else {
            outingCollectionView.isHidden = false
            outingIsNilImage.isHidden = true
            outingIsNilText.isHidden = true
            for index in 0...viewModel.outingList.endIndex - 1 {
                userNameList.insert(viewModel.outingList[index].name, at: index)
                userGradeList.insert(viewModel.outingList[index].studentNum.grade, at: index)
                userClassNumList.insert(viewModel.outingList[index].studentNum.classNum, at: index)
                userNumList.insert(viewModel.outingList[index].studentNum.number, at: index)
                userProfile.insert(viewModel.outingList[index].profileUrl ?? "", at: index)
                createTime.insert(viewModel.outingList[index].createdTime, at: index)
            }
            outingCollectionView.dataSource = self
            outingCollectionView.delegate = self
            outingCollectionView.register(
                OutingCollectionViewCell.self,
                forCellWithReuseIdentifier: OutingCollectionViewCell.identifier
            )
        }
    }
    
    private func bindViewModel() {
        let input = OutingViewModel.Input(
            profileButtonTap: navigationItem.rightBarButtonItem!.rx.tap.asObservable()
        )
        viewModel.transVC(input: input)
    }
    
    private let outingMainText = UILabel().then {
        $0.text = "외출현황"
        $0.numberOfLines = 3
        $0.font = UIFont.GOMSFont(
            size: 24,
            family: .Bold
        )
        $0.textColor = .black
    }
    
    private let layout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(
            width: (
                (UIScreen.main.bounds.width) - 52
            ),
            height: (
                90
            )
        )
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0) //아이템 상하좌우 사이값 초기화
    }
    
    private let outingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.isScrollEnabled = true
        $0.backgroundColor = .background
    }
    
    private lazy var outingIsNilImage = UIImageView().then {
        $0.image = userAuthority == "ROLE_STUDENT_COUNCIL" ?
        UIImage(named: "adminOutingIsNil.svg") : UIImage(named: "outingIsNilImage.svg")
        $0.isHidden = true
    }
    
    private let outingIsNilText = UILabel().then {
        $0.text = "다들 바쁜가봐요..!"
        $0.font = UIFont.GOMSFont(
            size: 16,
            family: .Medium
        )
        $0.textColor = UIColor(
            red: 150/255,
            green: 150/255,
            blue: 150/255,
            alpha: 1
        )
        $0.isHidden = true
    }
    
    override func addView() {
        [outingMainText, outingCollectionView, outingIsNilImage, outingIsNilText].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        outingMainText.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset((bounds.height) / 7.73)
            $0.leading.equalToSuperview().offset(26)
        }
        outingCollectionView.snp.makeConstraints {
            $0.top.equalTo(outingMainText.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.bottom.equalToSuperview()
        }
        outingIsNilImage.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        outingIsNilText.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(outingIsNilImage.snp.bottom).offset(20)
        }
    }

}

extension OutingViewController:
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userNameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OutingCollectionViewCell.identifier, for: indexPath) as? OutingCollectionViewCell else {
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
        cell.userName.text = "\(userNameList[indexPath.row])"
        if userNumList[indexPath.row] < 10 {
            cell.userNum.text = "\(userGradeList[indexPath.row])\(userClassNumList[indexPath.row])0\(userNumList[indexPath.row])"
        }
        else {
            cell.userNum.text = "\(userGradeList[indexPath.row])\(userClassNumList[indexPath.row])\(userNumList[indexPath.row])"
        }
        let url = URL(string: userProfile[indexPath.row])
        let imageCornerRadius = RoundCornerImageProcessor(cornerRadius: 20)
        cell.userProfile.kf.setImage(
            with: url,
            placeholder:UIImage(named: "dummyImage.svg"),
            options: [.processor(imageCornerRadius)]
        )
        cell.createTime.text = "\(createTime[indexPath.row])"
        cell.deleteUserButtonAction = { [unowned self] in
            viewModel.steps.accept(GOMSStep.alert(
                title: "외출자 삭제",
                message: "정말 이 외출자를 삭제할까요?",
                style: .alert,
                actions: [
                    .init(title: "확인", style: .default) { _ in
                        self.viewModel.outingUserDelete(
                            accountIdx: self.viewModel.outingList[indexPath.row].accountIdx, completion: {
                                [unowned self] in
                                userNameList = [String]()
                                userGradeList = [Int]()
                                userClassNumList = [Int]()
                                userNumList = [Int]()
                                userProfile = [String]()
                                createTime = [String]()
                                viewModel.outingList { [unowned self] in
                                    outingCollectionView.reloadData()
                                    bindOutingList()
                                }
                            }
                        )
                    },
                    .init(title: "취소", style: .cancel)
                ]
            ))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (
                (UIScreen.main.bounds.width) - 52
            ),
            height: (
                90
            )
        )
    }
}
