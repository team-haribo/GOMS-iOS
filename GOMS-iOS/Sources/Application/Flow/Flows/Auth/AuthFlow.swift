//
//  AuthFlow.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import RxFlow
import UIKit

class AuthFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()
    
    init(){}
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? GOMSStep else { return .none }
        switch step {
        case .introIsRequired:
            return coordinateToIntro()
            
        case .tabBarIsRequired:
            return .end(forwardToParentFlowWithStep: GOMSStep.tabBarIsRequired)
            
        case .loginWithNumberIsRequired:
            return coordinateToLoginWithNumber()
            
        case let .alert(title, message, style, actions):
            return presentToAlert(title: title, message: message, style: style, actions: actions)
            
        case let .failureAlert(title, message, action):
            return presentToFailureAlert(title: title, message: message, action: action)
            
        default:
            return .none
        }
    }
}

private extension AuthFlow {
    func coordinateToIntro() -> FlowContributors {
        let vm = IntroViewModel()
        let vc = IntroViewController(vm)
        self.rootViewController.setViewControllers([vc], animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
    }
    
    func coordinateToLoginWithNumber() -> FlowContributors {
        let vm = LoginWithNumberViewModel()
        let vc = LoginWithNumberViewController(vm)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
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
