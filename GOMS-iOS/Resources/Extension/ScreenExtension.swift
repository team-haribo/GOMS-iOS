//
//  ScreenExtension.swift
//  GOMS-iOS
//
//  Created by 김주은 on 2023/07/03.
//

import UIKit

extension UIDevice {
    public var isiPhoneSE: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone && (UIScreen.main.bounds.size.height == 568 || UIScreen.main.bounds.size.width == 320) {
            return true
        }
        return false
    }
}
