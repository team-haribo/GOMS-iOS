import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class EditUserModalViewController: BaseViewController<EditUserModalViewModel> {
    
    private var editedUserAuthority: String? = ""
    private var editedUserIsBlackList: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editUserData()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = EditUserModalViewModel.Input(
            editButtonDidTap: editButton.rx.tap.asObservable()
        )
        viewModel.transVC(input: input)
    }
    
    private func editUserData() {
        editButton.rx.tap
            .bind { [self] in
                if editedUserIsBlackList == false {
                    viewModel.editAuthority(authority: self.editedUserAuthority ?? "")
                }
                else if editedUserIsBlackList == true {
                    viewModel.isBlackList()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private let roleText = UILabel().then {
        $0.text = "역할"
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
    
    @objc func roleSegconChanged(segcon: UISegmentedControl) {
        switch segcon.selectedSegmentIndex {
        case 0:
            editedUserAuthority = "ROLE_STUDENT"
        case 1:
            editedUserAuthority = "ROLE_STUDENT_COUNCIL"
        case 2:
            editedUserIsBlackList = true
        default: break
            editedUserAuthority = ""
            editedUserIsBlackList = false
        }
    }
    
    private var editButton = UIButton().then {
        $0.backgroundColor = .adminColor
        $0.setTitle("수정하기", for: .normal)
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
    
    override func addView() {
        [roleText,roleSeg,editButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        roleText.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(26)
        }
        roleSeg.snp.makeConstraints {
            $0.top.equalTo(roleText.snp.bottom).offset(56)
            $0.leading.equalTo(view.snp.leading).offset(26)
            $0.trailing.equalTo(view.snp.trailing).inset(26)
            $0.height.equalTo(100)
        }
        editButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(52)
        }
    }
}
