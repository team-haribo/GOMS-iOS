//
//  GOMSStep.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import RxFlow

enum GOMSStep: Step {
    
    // MARK: Intro
    case introIsRequired
    
    // MARK: TabBar
    case tabBarIsRequired
    
    // MARK: QRCode
    case qrocdeIsRequired
    
    // MARK: Outing
    case outingIsRequired
    
    // MARK: Home
    case homeIsRequired
    
    // MARK: Profile
    case profileIsRequired
}
