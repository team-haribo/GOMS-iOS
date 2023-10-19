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
        tabBar.tintColor = userAuthority == "ROLE_STUDENT_COUNCIL" ? UIColor.p20 : UIColor.p10
        tabBar.unselectedItemTintColor = UIColor.n20
        tabBar.backgroundColor = .gomsWhite
    }
}
