import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: HomeViewController {
    var fetchUserData: Binder<AccountResponse?> {
        Binder(base) { base, userData in
            guard let data = userData else {return}
            print(data)
            let url = URL(string: data.profileUrl ?? "")
            base.profileImg.kf.setImage(
                with: url,
                placeholder: UIImage(named: "dummyImage.svg")
            )
            base.userNameText.text = data.name
            base.userNumText.text = "\(data.studentNum.grade)학년 \(data.studentNum.classNum)반 \(data.studentNum.number)번"
            if data.isOuting == true {
                base.useQRCodeButton.setTitle(
                    "복귀하기", 
                    for: .normal
                )
            }
        }
    }
}
