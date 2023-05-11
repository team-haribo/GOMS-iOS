//
//  UINavigation.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import UIKit
import Then

extension UINavigationItem {
    func rightBarButtonItem() {
        let keychain = Keychain()
        lazy var userAuthority = keychain.read(key: Const.KeychainKey.authority)
        let profileButton = UIBarButtonItem().then {
            $0.image = UIImage(named: "profileIcon.svg")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = userAuthority == "ROLE_STUDENT_COUNCIL" ? .adminColor : .mainColor
        }
        self.setRightBarButton(profileButton, animated: true)
    }
    
    func leftLogoImage() {
        let keychain = Keychain()
        lazy var userAuthority = keychain.read(key: Const.KeychainKey.authority)
        let customFont = UIFont.GOMSFont(size: 20,family: .Bold)
        self.leftBarButtonItem = UIBarButtonItem(
            title: "GOMS",
            style: .plain,
            target: nil,
            action: nil
        ).then {
            $0.tintColor = userAuthority == "ROLE_STUDENT_COUNCIL" ? .adminColor : .mainColor
            $0.setTitleTextAttributes(
                [NSAttributedString.Key.font: customFont],
                for: .normal
            )
        }
    }
}
