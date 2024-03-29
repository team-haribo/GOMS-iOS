import UIKit
import SnapKit
import Then
import RxCocoa
import RxFlow

class LoginWithNumberViewController: BaseViewController<LoginWithNumberViewModel>{

    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    private let loginWithNumberText = UILabel().then {
        $0.text = "로그인"
        $0.font = UIFont.GOMSFont(
            size: 32,
            family: .Bold
        )
        $0.textColor = UIColor.gomsBlack
    }
    
    private let subText = UILabel().then {
        $0.text = "이메일로 인증번호가 발송됩니다."
        $0.font = UIFont.GOMSFont(
            size: 16,
            family: .Regular
        )
        $0.textColor = UIColor.n20
    }
    
    private var emailTextField = LoginWithNumberTextField(
        placeholder: "s21031",
        width: 16
    )
    
    private var confirmationButton = UIButton().then {
        $0.setTitle("인증", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont.GOMSFont(size: 14, family: .Medium)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .p10
        $0.layer.applySketchShadow(
            color: UIColor.gomsBlack ?? .black,
            alpha: 0.1,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0
        )
    }
    
    private var numberTextField = LoginWithNumberTextField(
        placeholder: "인증번호를 입력하세요",
        width: 16
    ).then {
        $0.isHidden = true
    }
    
    private var completeButton = UIButton().then {
        $0.setTitle(
            "인증하기",
            for: .normal
        )
        $0.setTitleColor(
            UIColor.white,
            for: .normal
        )
        $0.titleLabel?.font = UIFont.GOMSFont(
            size: 16,
            family: .Bold
        )
        $0.layer.cornerRadius = 10
        $0.backgroundColor = UIColor(
            red: 1,
            green: 139,
            blue: 67,
            alpha: 0.5
        )
        $0.isHidden = true
    }

    override func addView() {
        [
            loginWithNumberText,
            subText,
            confirmationButton,
            emailTextField,
            numberTextField,
            completeButton
        ].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        loginWithNumberText.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset((bounds.height) / 6.10)
            $0.leading.equalTo(view.snp.leading).offset(26)
        }
        subText.snp.makeConstraints {
            $0.top.equalTo(loginWithNumberText.snp.bottom).offset(8)
            $0.leading.equalTo(view.snp.leading).offset(26)
        }
        confirmationButton.snp.makeConstraints {
            $0.top.equalTo(subText.snp.bottom).offset(50)
            $0.height.equalTo(52)
            $0.trailing.equalToSuperview().inset(26)
            $0.width.equalTo((bounds.width) / 4.8)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(subText.snp.bottom).offset(50)
            $0.height.equalTo(52)
            $0.leading.equalToSuperview().offset(26)
            $0.width.equalTo((bounds.width) / 1.6)
        }
        numberTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(30)
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).inset(50)
            $0.height.equalTo(60)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
    }
    
}
