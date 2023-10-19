import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UILabel {
    var outingCount: Binder<Int> {
        Binder(base) { label, outingCount in
            let keychain = Keychain()
            lazy var userAuthority = keychain.read(key: Const.KeychainKey.authority)
            label.text = "\(outingCount) 명이 외출중이에요!"
            label.textColor = UIColor.gomsBlack
            label.font = UIFont.GOMSFont(size: 16,family: .Medium)
            let fullText = label.text ?? ""
            let attribtuedString = NSMutableAttributedString(string: fullText)
            let range = (fullText as NSString).range(of: "\(outingCount)")
            attribtuedString.addAttribute(
                .foregroundColor,
                value: userAuthority == "ROLE_STUDENT" ? UIColor.p10?.cgColor: UIColor.p20?.cgColor,
                range: range
            )
            label.attributedText = attribtuedString
        }
    }
}
