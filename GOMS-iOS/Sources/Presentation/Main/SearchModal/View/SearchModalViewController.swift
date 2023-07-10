import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class SearchModalViewController: BaseViewController<SearchModalViewModal> {
    
    private var searchGrade: Int?
    private var searchClassNum: Int?
    private var searchBlackList: Bool?
    private var searchAuthority: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postData()
        deselectRoleButtonDidTap()
        deselectGradeButtonDidTap()
        deselectClassNumButtonDidTap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: .searchModalDismiss, object: nil)
    }
    
    private func postData() {
        searchButton.rx.tap
            .debug()
            .subscribe(onNext:{ [unowned self] in
                self.viewModel.steps.accept(
                    GOMSStep.searchModalDismiss(
                        grade: searchGrade,
                        classNum: searchClassNum,
                        name: searchBar.text ?? "",
                        isBlackList: searchBlackList,
                        authority: searchAuthority
                    )
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func deselectRoleButtonDidTap() {
        deselectRoleButton.rx.tap
            .bind {
                self.roleSeg.selectedSegmentIndex = UISegmentedControl.noSegment
            }.disposed(by: disposeBag)
    }
    
    private func deselectGradeButtonDidTap() {
        deselectGradeButton.rx.tap
            .bind {
                self.gradeSeg.selectedSegmentIndex = UISegmentedControl.noSegment
            }.disposed(by: disposeBag)
    }
    
    private func deselectClassNumButtonDidTap() {
        deselectClassNumButton.rx.tap
            .bind {
                self.classNumSeg.selectedSegmentIndex = UISegmentedControl.noSegment
            }.disposed(by: disposeBag)
    }
    
    private var searchBar = UITextField().then {
        $0.backgroundColor = .white
        $0.layer.applySketchShadow(
            color: UIColor.black,
            alpha: 0.1,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0
        )
        $0.font = UIFont.GOMSFont(size: 14, family: .Regular)
        $0.layer.cornerRadius = 10
        $0.placeholder = "찾으시는 학생이 있으신가요?"
        $0.addLeftPadding()
    }
    
    private let roleText = UILabel().then {
        $0.text = "역할"
        $0.font = UIFont.GOMSFont(size: 16, family: .Regular)
        $0.textColor = .black
    }
    
    private let gradeText = UILabel().then {
        $0.text = "학년"
        $0.font = UIFont.GOMSFont(size: 16, family: .Regular)
        $0.textColor = .black
    }
    
    private let classNumText = UILabel().then {
        $0.text = "반"
        $0.font = UIFont.GOMSFont(size: 16, family: .Regular)
        $0.textColor = .black
    }
    
    private var roleSeg = UISegmentedControl(items: ["학생","학생회","외출금지"]).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.white
        $0.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.subColor as Any],
            for: .normal
        )
        $0.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.black as Any],
            for: .selected
        )
        $0.selectedSegmentTintColor = .white
        $0.layer.applySketchShadow(
            color: UIColor.black,
            alpha: 0.1,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0
        )
        $0.addTarget(
            self,
            action: #selector(roleSegconChanged(segcon:)),
            for: UIControl.Event.valueChanged
        )
    }
    private var deselectRoleButton = UIButton().then {
        $0.backgroundColor = UIColor(
            red: 1,
            green: 1,
            blue: 1,
            alpha: 0
        )
        $0.setTitle("선택해제", for: .normal)
        $0.setTitleColor(UIColor.subColor, for: .normal)
        $0.titleLabel?.font = UIFont.GOMSFont(size: 14, family: .Regular)
    }
    
    private var gradeSeg = UISegmentedControl(items: ["1","2","3"]).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.white
        $0.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.subColor as Any],
            for: .normal
        )
        $0.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.black as Any],
            for: .selected
        )
        $0.selectedSegmentTintColor = .white
        $0.layer.applySketchShadow(
            color: UIColor.black,
            alpha: 0.1,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0
        )
        $0.addTarget(
            self,
            action: #selector(gradeSegconChanged(segcon:)),
            for: UIControl.Event.valueChanged
        )
    }
    private var deselectGradeButton = UIButton().then {
        $0.backgroundColor = UIColor(
            red: 1,
            green: 1,
            blue: 1,
            alpha: 0
        )
        $0.setTitle("선택해제", for: .normal)
        $0.setTitleColor(UIColor.subColor, for: .normal)
        $0.titleLabel?.font = UIFont.GOMSFont(size: 14, family: .Regular)
    }
    
    private var classNumSeg = UISegmentedControl(items: ["1","2","3","4"]).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.white
        $0.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.subColor as Any],
            for: .normal
        )
        $0.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.black as Any],
            for: .selected
        )
        $0.selectedSegmentTintColor = .white
        $0.layer.applySketchShadow(
            color: UIColor.black,
            alpha: 0.1,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0
        )
        $0.addTarget(
            self,
            action: #selector(classNumSegconChanged(segcon:)),
            for: UIControl.Event.valueChanged
        )
    }
    
    private var deselectClassNumButton = UIButton().then {
        $0.backgroundColor = UIColor(
            red: 1,
            green: 1,
            blue: 1,
            alpha: 0
        )
        $0.setTitle("선택해제", for: .normal)
        $0.setTitleColor(UIColor.subColor, for: .normal)
        $0.titleLabel?.font = UIFont.GOMSFont(size: 14, family: .Regular)
    }
    
    private var searchButton = UIButton().then {
        $0.backgroundColor = .adminColor
        $0.setTitle("검색하기", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont.GOMSFont(size: 14, family: .Bold)
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
    
    @objc func roleSegconChanged(segcon: UISegmentedControl) {
        switch segcon.selectedSegmentIndex {
        case 0:
            searchAuthority = "ROLE_STUDENT"
        case 1:
            searchAuthority = "ROLE_STUDENT_COUNCIL"
        case 2:
            searchBlackList = true
        default: break
            searchAuthority = ""
        }
    }
    
    @objc func gradeSegconChanged(segcon: UISegmentedControl) {
        switch segcon.selectedSegmentIndex {
        case 0:
            searchGrade = 1
        case 1:
            searchGrade = 2
        case 2:
            searchGrade = 3
        default: break
        }
    }
    
    @objc func classNumSegconChanged(segcon: UISegmentedControl) {
        switch segcon.selectedSegmentIndex {
        case 0:
            searchClassNum = 1
        case 1:
            searchClassNum = 2
        case 2:
            searchClassNum = 3
        case 3:
            searchClassNum = 4
        default: break
//            searchClassNum = nil
        }
    }
    
    override func addView() {
        [searchBar,roleText,gradeText,classNumText, roleSeg, gradeSeg, classNumSeg, searchButton, deselectRoleButton, deselectGradeButton, deselectClassNumButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.trailing.leading.equalToSuperview().inset(26)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(52)
        }
        
        roleText.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(26)
        }
        
        gradeText.snp.makeConstraints {
            $0.top.equalTo(roleText.snp.bottom).offset(65)
            $0.leading.equalToSuperview().offset(26)
        }
        
        classNumText.snp.makeConstraints {
            $0.top.equalTo(gradeText.snp.bottom).offset(65)
            $0.leading.equalToSuperview().offset(26)
        }
        
        roleSeg.snp.makeConstraints {
            $0.top.equalTo(roleText.snp.bottom).offset(6)
            $0.leading.equalTo(view.snp.leading).offset(26)
            $0.trailing.equalTo(view.snp.trailing).inset(26)
            $0.height.equalTo(46)
        }
        
        gradeSeg.snp.makeConstraints {
            $0.top.equalTo(gradeText.snp.bottom).offset(6)
            $0.leading.equalTo(view.snp.leading).offset(26)
            $0.trailing.equalTo(view.snp.trailing).inset(26)
            $0.height.equalTo(46)
        }
        
        classNumSeg.snp.makeConstraints {
            $0.top.equalTo(classNumText.snp.bottom).offset(6)
            $0.leading.equalTo(view.snp.leading).offset(26)
            $0.trailing.equalTo(view.snp.trailing).inset(26)
            $0.height.equalTo(46)
        }
        searchButton.snp.makeConstraints {
            $0.top.equalTo(classNumSeg.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(52)
        }
        
        deselectRoleButton.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().inset(26)
        }
        
        deselectGradeButton.snp.makeConstraints {
            $0.top.equalTo(roleSeg.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(26)
        }
        
        deselectClassNumButton.snp.makeConstraints {
            $0.top.equalTo(gradeSeg.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(26)
        }
    }
}
