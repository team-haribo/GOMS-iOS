//
//  GOMSFont.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import UIKit

extension UIFont {
    
    enum Family: String {
        case SemiBold
        case Medium
        case Regular
    }
    
    static func GOMSFont(size: CGFloat = 10, family: Family = .Regular) -> UIFont {
        return UIFont(name: "SFProText-\(family)", size: size) ?? systemFont(ofSize: 20, weight: .thin)
    }
}
