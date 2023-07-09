import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import Kingfisher

class StudentInfoViewController: BaseViewController<StudentInfoViewModel> {
    private let searchModalViewModal = SearchModalViewModal.shared

    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "학생 정보 수정"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        super.viewDidLoad()
        bindViewModel()
        studentInfoCollectionView.collectionViewLayout = layout
    }
    
    private func bindViewModel() {
        let viewWillApeearObservable = self.rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in }
            .asObservable()
        
        let searchModalDismiss = NotificationCenter.default.rx.notification(.searchModalDismiss)
            .map { _ in }
            .asObservable()
        
        let output = viewModel.transform(
            .init(
                searchBarButton: searchBarButton.rx.tap.asObservable(),
                viewWillAppear: viewWillApeearObservable,
                searchModalDismiss: searchModalDismiss
            )
        )
        
        output.studentList
            .bind(
                to: studentInfoCollectionView.rx.items(
                    cellIdentifier: "studentInfoCell",
                    cellType: StudentInfoCell.self
                )
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
                cell.userProfile.kf.setImage(with: url, placeholder: UIImage(named: "dummyImage.svg"))
                cell.userName.text = item.name
                if item.studentNum.number < 10 {
                    cell.userNum.text = "\(item.studentNum.grade)\(item.studentNum.classNum)0\(item.studentNum.number)"
                }
                else {
                    cell.userNum.text = "\(item.studentNum.grade)\(item.studentNum.classNum)\(item.studentNum.number)"
                }
                if item.isBlackList == true {
                    cell.roleView.isHidden = false
                    cell.roleText.isHidden = false
                    cell.deleteBlackListButton.isHidden = false
                    cell.editUserAuthorityButton.isHidden = true
                    cell.roleText.text = "외출금지"
                    cell.roleText.textColor = .blackListColor
                    cell.roleView.layer.borderColor = UIColor.blackListColor?.cgColor
                }
                else if item.authority == "ROLE_STUDENT_COUNCIL" {
                    cell.roleView.isHidden = false
                    cell.roleText.isHidden = false
                    cell.deleteBlackListButton.isHidden = true
                    cell.editUserAuthorityButton.isHidden = false
                }
                else {
                    cell.roleView.isHidden = true
                    cell.roleText.isHidden = true
                    cell.deleteBlackListButton.isHidden = true
                    cell.editUserAuthorityButton.isHidden = false

                }
            }
            .disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private let noResultImage = UIImageView().then {
        $0.image = UIImage(named: "noResultImage")
        $0.isHidden = true
    }
    
    private let noResultText = UILabel().then {
        $0.text = "검색 결과를 찾을 수 없어요!"
        $0.textColor = .subColor
        $0.font = UIFont.GOMSFont(size: 16,family: .Medium)
        $0.isHidden = true
    }
    
    private var searchBarButton = UIButton().then {
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
    
    private let studentInfoCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        $0.isScrollEnabled = true
        $0.backgroundColor = .background
        $0.register(StudentInfoCell.self, forCellWithReuseIdentifier: "studentInfoCell")
    }
    
    private let searchBarText = UILabel().then {
        $0.text = "찾으시는 학생이 있으신가요?"
        $0.textColor = UIColor.subColor
        $0.font = UIFont.GOMSFont(size: 14, family: .Regular)
    }
    
    private let searchIcon = UIImageView().then {
        $0.image = UIImage(named: "searchIcon")
    }
    
    override func addView() {
        [searchBarButton, studentInfoCollectionView, searchBarText, searchIcon, noResultImage, noResultText].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        searchBarButton.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(121)
            $0.height.equalTo(52)
            $0.trailing.leading.equalToSuperview().inset(26)
        }
        studentInfoCollectionView.snp.makeConstraints{
            $0.top.equalTo(searchBarButton.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        searchBarText.snp.makeConstraints {
            $0.centerY.equalTo(searchBarButton.snp.centerY).offset(0)
            $0.leading.equalTo(searchBarButton.snp.leading).offset(20)
        }
        searchIcon.snp.makeConstraints {
            $0.centerY.equalTo(searchBarButton.snp.centerY).offset(0)
            $0.trailing.equalTo(searchBarButton.snp.trailing).inset(20)
        }
        noResultImage.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        noResultText.snp.makeConstraints {
            $0.top.equalTo(noResultImage.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }

}
