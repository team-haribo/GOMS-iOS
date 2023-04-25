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
        case qrCode = 1
        case outing = 2
    }
    
    var root: Presentable {
        return self.rootVC
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()
    
    private let rootVC = GOMSTabBarViewController()
    
    private var homeFlow = HomeFlow()
    private var qrCodeFlow = QRCodeFlow()
    private var outingFlow = OutingFlow()
    
    init() {}
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? GOMSStep else {return .none}
        
        switch step {
        case .tabBarIsRequired:
            return coordinateToTabbar(index: 0)
        case .qrocdeIsRequired:
            return coordinateToTabbar(index: 1)
        case .outingIsRequired:
            return coordinateToTabbar(index: 2)
        default:
            return .none
        }
    }
    
}

private extension TabBarFlow {
    func coordinateToTabbar(index: Int) -> FlowContributors {
        Flows.use(
            homeFlow, qrCodeFlow, outingFlow,
            when: .ready
        ) { [unowned self] (root1: UINavigationController,
                            root2: UINavigationController,
                            root3: UINavigationController) in
            let homeItem = UITabBarItem(
                title: "홈",
                image: UIImage(named: "unHome.svg"),
                selectedImage: UIImage(named: "selectedHome.svg")
            )
            
            let qrCodeItem = UITabBarItem(
                title: "외출하기",
                image: UIImage(named: "unQRCode.svg"),
                selectedImage: UIImage(named: "selectedQRcode.svg")
            )
            
            let outingItem = UITabBarItem(
                title: "외출현황",
                image: UIImage(named: "unOuting.svg"),
                selectedImage: UIImage(named: "selectedOuting.svg")
            )
            root1.tabBarItem = homeItem
            root2.tabBarItem = qrCodeItem
            root3.tabBarItem = outingItem
            
            self.rootVC.setViewControllers([root1,root2,root3], animated: true)
            self.rootVC.selectedIndex = index

        }
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: homeFlow, withNextStepper: homeFlow.stepper),
            .contribute(withNextPresentable: qrCodeFlow, withNextStepper: qrCodeFlow.stepper),
            .contribute(withNextPresentable: outingFlow, withNextStepper: outingFlow.stepper)
        ])
    }
}
