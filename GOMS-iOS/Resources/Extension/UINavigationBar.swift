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
        let profileButton = UIBarButtonItem().then {
            $0.image = UIImage(named: "profileIcon.svg")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .mainColor
        }
        self.setRightBarButton(profileButton, animated: true)
    }
    
    func leftLogoImage() {
        let customFont = UIFont.LogoFont(size: 20,family: .Black)
        self.leftBarButtonItem = UIBarButtonItem(
            title: "GOMS",
            style: .plain,
            target: nil,
            action: nil
        ).then {
            $0.tintColor = .mainColor
            $0.setTitleTextAttributes(
                [NSAttributedString.Key.font: customFont],
                for: .normal
            )
        }
    }
    
    func backButton(title:String = "취소") {
        let backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = UIColor.black
        self.backBarButtonItem = backBarButtonItem
    }
}
