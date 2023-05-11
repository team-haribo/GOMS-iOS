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
    private let keychain = Keychain()
    private lazy var userAuthority = keychain.read(key: Const.KeychainKey.authority)
    
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
            
        case .introIsRequired:
            return .end(forwardToParentFlowWithStep: GOMSStep.introIsRequired)
            
        case let .alert(title, message, style, actions):
            return presentToAlert(title: title, message: message, style: style, actions: actions)
            
        case let .failureAlert(title, message, action):
            return presentToFailureAlert(title: title, message: message, action: action)
            
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
                title: userAuthority == "ROLE_STUDENT_COUNCIL" ? "생성하기" : "외출하기",
                image: userAuthority == "ROLE_STUDENT_COUNCIL" ?
                UIImage(named: "unSelectedAdminQRCode.svg") : UIImage(named: "unQRCode.svg"),
                selectedImage: userAuthority == "ROLE_STUDENT_COUNCIL" ?
                UIImage(named: "selectedAdminQRCode.svg") : UIImage(named: "selectedQRcode.svg")
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
    
    func presentToAlert(title: String?, message: String?, style: UIAlertController.Style, actions: [UIAlertAction]) -> FlowContributors {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { alert.addAction($0) }
        self.rootViewController.topViewController?.present(alert, animated: true)
        return .none
    }
    
    func presentToFailureAlert(title: String?, message: String?, action: [UIAlertAction]) -> FlowContributors {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if !action.isEmpty {
            action.forEach(alert.addAction(_:))
        } else {
            alert.addAction(.init(title: "확인", style: .default))
        }
        self.rootViewController.topViewController?.present(alert, animated: true)
        return .none
    }
}
