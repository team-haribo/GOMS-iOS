//
//  UINavigation.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import Foundation
import UIKit
import Then

extension UINavigationItem {
    func rightBarButtonItems() {
        let qrCodeButton = UIBarButtonItem().then {
            $0.image = UIImage(named: "qrCode.svg")
            $0.image?.withRenderingMode(.alwaysOriginal)
            $0.tintColor = .mainColor
        }
        
        let noticeButton = UIBarButtonItem().then {
            $0.image = UIImage(named: "notice.svg")
            $0.image?.withRenderingMode(.alwaysOriginal)
            $0.tintColor = .mainColor
        }
        self.setRightBarButtonItems([noticeButton,qrCodeButton], animated: true)
    }
}
