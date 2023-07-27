//
//  GOMSStep.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import RxFlow
import UIKit

enum GOMSStep: Step {
    
    // MARK: Auth
    case introIsRequired
    case loginWithNumberIsRequired
    
    // MARK: TabBar
    case tabBarIsRequired
    
    // MARK: Home
    case qrocdeIsRequired
    case outingIsRequired
    case homeIsRequired
    case profileIsRequired
    
    //MARK: Alert
    case alert(title: String?, message: String?, style: UIAlertController.Style, actions: [UIAlertAction])
    case failureAlert(title: String?, message: String?, action: [UIAlertAction] = [])
}
