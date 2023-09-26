//
//  GOMSTabBar.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import UIKit

final class GOMSTabBarViewController: UITabBarController {
    private let keychain = Keychain()
    private lazy var userAuthority = keychain.read(key: Const.KeychainKey.authority)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureVC()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension GOMSTabBarViewController {
    func configureVC() {
        tabBar.tintColor = userAuthority == "ROLE_STUDENT_COUNCIL" ? UIColor.adminColor : UIColor.mainColor
        tabBar.unselectedItemTintColor = UIColor.subColor
        tabBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.98)
    }
}
