import RxSwift
import RxCocoa
import UIKit
import Kingfisher

extension Reactive where Base: ProfileViewController {
    var cellDetail: Binder<AccountResponse?> {
        Binder(base) { base, userDetail in
            guard let detail = userDetail else {return}
            print(detail.name)
            base.cellDetail[0] = "\(detail.name)"
            base.cellDetail[1] = "\(detail.studentNum.grade)"
            base.cellDetail[2] = "\(detail.studentNum.classNum)"
            base.cellDetail[3] = "\(detail.studentNum.number)"
            base.cellDetail[4] = "\(detail.lateCount)"
            let url = URL(string: detail.profileUrl ?? "")
            base.profileImage.kf.setImage(with: url, placeholder: UIImage(named: "DummyImage.svg"))
            base.userNameText.text = "\(detail.name)"
            if detail.studentNum.number < 10 {
                base.userNumText.text = "\(detail.studentNum.grade)\(detail.studentNum.classNum)0\(detail.studentNum.number)"
            }
            else {
                base.userNumText.text = "\(detail.studentNum.grade)\(detail.studentNum.classNum)\(detail.studentNum.number)"
            }
            base.userInfoTableView.delegate = base
            base.userInfoTableView.dataSource = base
            base.userInfoTableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileTableViewCell")
        }
    }
}
