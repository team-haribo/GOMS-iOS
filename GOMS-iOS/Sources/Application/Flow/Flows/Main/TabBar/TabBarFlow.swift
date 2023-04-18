//
//  TabBarFlow.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import RxFlow
import UIKit

final class TabBarFlow: Flow {
    
    enum TabIndex: Int {
        case home = 0
        case request = 1
        case outing = 2
    }
    
    var root: Presentable {
        return self.rootVC
    }
    
    
    private let rootVC = GOMSTabBarViewController()
    
    private var homeFlow = HomeFlow()
    private var requestFlow = RequestFlow()
    private var outingFlow = OutingFlow()
    
    init() {}
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? GOMSStep else {return .none}
        
        switch step {
        case .tabBarIsRequired:
            return coordinateToTabbar()
        default:
            return .none
        }
    }
    
}

private extension TabBarFlow {
    func coordinateToTabbar() -> FlowContributors {
        Flows.use(
            homeFlow, requestFlow, outingFlow,
            when: .ready
        ) { [unowned self] (root1: UINavigationController,
                            root2: UINavigationController,
                            root3: UINavigationController) in
            let homeItem = UITabBarItem(
                title: "홈",
                image: UIImage(named: "unHome.svg"),
                selectedImage: UIImage(named: "selectedHome.svg")
            )
            
            let requestItem = UITabBarItem(
                title: "의뢰하기",
                image: UIImage(named: "unRequest.svg"),
                selectedImage: UIImage(named: "selectedRequest.svg")
            )
            
            let outingItem = UITabBarItem(
                title: "외출현황",
                image: UIImage(named: "unOuting.svg"),
                selectedImage: UIImage(named: "selectedOuting.svg")
            )
            root1.tabBarItem = homeItem
            root2.tabBarItem = requestItem
            root3.tabBarItem = outingItem
            
            self.rootVC.setViewControllers([root1,root2,root3], animated: true)

        }
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: homeFlow, withNextStepper: homeFlow.stepper),
            .contribute(withNextPresentable: requestFlow, withNextStepper: requestFlow.stepper),
            .contribute(withNextPresentable: outingFlow, withNextStepper: outingFlow.stepper)
        ])
    }
}
