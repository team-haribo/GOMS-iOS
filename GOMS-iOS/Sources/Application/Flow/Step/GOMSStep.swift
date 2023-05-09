//
//  GOMSStep.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import RxFlow

enum GOMSStep: Step {
    
    // MARK: Auth
    case introIsRequired
    
    // MARK: TabBar
    case tabBarIsRequired
    
    // MARK: Home
    case qrocdeIsRequired
    case outingIsRequired
    case homeIsRequired
    case profileIsRequired
    
    //MARK: Alert
    case alert
}
