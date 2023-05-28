import UIKit
import RxFlow
import Kingfisher
import SnapKit
import Then
import RxSwift
import RxCocoa

class StudentInfoViewController: BaseViewController<StudentInfoViewModel> {
    private var userNameList = [String]()
    private var userGradeList = [Int]()
    private var userClassNumList = [Int]()
    private var userNumList = [Int]()
    private var userRole = [String]()
    private var userIsBlackList = [Bool]()
    private let searchModalViewModal = SearchModalViewModal.shared


    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "학생 정보 수정"
        super.viewDidLoad()
        Task {
            await getData()
        }
        studentInfoCollectionView.collectionViewLayout = layout
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didDismissSearchNotification(_:)),
            name: NSNotification.Name("DismissSearchView"),
            object: nil
        )
    }
    
    @objc func didDismissSearchNotification(_ notification: Notification) {
        DispatchQueue.main.async { [self] in
            userNameList = [String]()
            userGradeList = [Int]()
            userClassNumList = [Int]()
            userNumList = [Int]()
            userRole = [String]()
            userIsBlackList = [Bool]()
            bindSearchData()
            print("---------------------------")
            print(searchModalViewModal.searchResult)
            print(userRole)
            print("---------------------------")
          }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = StudentInfoViewModel.Input(
            searchBarButton: searchBarButton.rx.tap.asObservable()
        )
        viewModel.transVC(input: input)
    }
    
    private func getData() async {
        viewModel.studentInfo { [weak self] in
            self?.bindStudentInfo()
        }
    }
    
    private func bindSearchData() {
        if searchModalViewModal.searchResult.isEmpty {
            self.studentInfoCollectionView.isHidden = true
            self.noResultText.isHidden = false
            self.noResultImage.isHidden = false
        }
        else {
            for index in 0...searchModalViewModal.searchResult.endIndex - 1 {
                self.studentInfoCollectionView.isHidden = false
                self.noResultText.isHidden = false
                self.noResultImage.isHidden = false
                userNameList.insert(searchModalViewModal.searchResult[index].name, at: index)
                userGradeList.insert(searchModalViewModal.searchResult[index].studentNum.grade, at: index)
                userClassNumList.insert(searchModalViewModal.searchResult[index].studentNum.classNum, at: index)
                userNumList.insert(searchModalViewModal.searchResult[index].studentNum.number, at: index)
                userRole.insert(searchModalViewModal.searchResult[index].authority, at: index)
                userIsBlackList.insert(searchModalViewModal.searchResult[index].isBlackList, at: index)
            }
            studentInfoCollectionView.dataSource = self
            studentInfoCollectionView.delegate = self
            studentInfoCollectionView.register(
                StudentInfoCell.self,
                forCellWithReuseIdentifier: StudentInfoCell.identifier
            )
        }
    }
    
    private func bindStudentInfo() {
        if viewModel.studentUserInfo.isEmpty {
            print("empty")
        }
        else {
            for index in 0...viewModel.studentUserInfo.endIndex - 1 {
                userNameList.insert(viewModel.studentUserInfo[index].name, at: index)
                userGradeList.insert(viewModel.studentUserInfo[index].studentNum.grade, at: index)
                userClassNumList.insert(viewModel.studentUserInfo[index].studentNum.classNum, at: index)
                userNumList.insert(viewModel.studentUserInfo[index].studentNum.number, at: index)
                userRole.insert(viewModel.studentUserInfo[index].authority, at: index)
                userIsBlackList.insert(viewModel.studentUserInfo[index].isBlackList, at: index)
            }
            studentInfoCollectionView.dataSource = self
            studentInfoCollectionView.delegate = self
            studentInfoCollectionView.register(
                StudentInfoCell.self,
                forCellWithReuseIdentifier: StudentInfoCell.identifier
            )
        }
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
extension StudentInfoViewController:
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userNameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudentInfoCell.identifier, for: indexPath) as? StudentInfoCell else {
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
        cell.roleText.isHidden = true
        cell.roleView.isHidden = true
        if userRole[indexPath.row] == "ROLE_STUDENT_COUNCIL" {
            cell.roleView.isHidden = false
            cell.roleText.isHidden = false
        }
        else if userIsBlackList[indexPath.row] == true {
            cell.roleView.isHidden = false
            cell.roleText.isHidden = false
            cell.roleText.text = "외출금지"
            cell.roleText.textColor = .blackListColor
            cell.roleView.layer.borderColor = UIColor.blackListColor?.cgColor
        }
        cell.editUserAuthorityButtonAction = { [unowned self] in
            viewModel.steps.accept(GOMSStep.editUserModalIsRequired(
                accountIdx: viewModel.studentUserInfo[indexPath.row].accountIdx))
            print(viewModel.studentUserInfo[indexPath.row].accountIdx)
        }
        cell.userName.text = "\(userNameList[indexPath.row])"
        if userNumList[indexPath.row] < 10 {
            cell.userNum.text = "\(userGradeList[indexPath.row])\(userClassNumList[indexPath.row])0\(userNumList[indexPath.row])"
        }
        else {
            cell.userNum.text = "\(userGradeList[indexPath.row])\(userClassNumList[indexPath.row])\(userNumList[indexPath.row])"
        }
        for index in 0 ... userNameList.count - 1 {
            let url = URL(string: viewModel.studentUserInfo[index].profileUrl ?? "")
            let imageCornerRadius = RoundCornerImageProcessor(cornerRadius: 40)
            cell.userProfile.kf.setImage(
                with: url,
                placeholder:UIImage(named: "dummyImage.svg"),
                options: [.processor(imageCornerRadius)]
            )
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
