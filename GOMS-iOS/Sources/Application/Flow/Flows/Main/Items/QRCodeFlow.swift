//
//  RequestFlow.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import RxFlow
import UIKit
import RxSwift
import RxCocoa

struct QRCodeStepper: Stepper{
    var steps = PublishRelay<Step>()

    var initialStep: Step{
        return GOMSStep.qrocdeIsRequired
    }
}

class QRCodeFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }
    
    var stepper = QRCodeStepper()
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()

    init(){}
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? GOMSStep else { return .none }
        switch step {
            
        case .qrocdeIsRequired:
            return coordinateToQRCode()
            
        case .homeIsRequired:
            return .one(flowContributor: .forwardToParentFlow(withStep: GOMSStep.homeIsRequired))
            
        case .introIsRequired:
            return .end(forwardToParentFlowWithStep: GOMSStep.introIsRequired)
            
        case .profileIsRequired:
            return coordinateToProfile()
            
        case let .alert(title, message, style, actions):
            return presentToAlert(title: title, message: message, style: style, actions: actions)
            
        case let .failureAlert(title, message, action):
            return presentToFailureAlert(title: title, message: message, action: action)
            
        default:
            return .none
        }
    }
    
    private func coordinateToQRCode() -> FlowContributors {
        let vm = QRCodeViewModel()
        let vc = QRCodeViewController(vm)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
    }
    
    private func coordinateToProfile() -> FlowContributors {
        let vm = ProfileViewModel()
        let vc = ProfileViewController(vm)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
    }
    
    private func presentToAlert(title: String?, message: String?, style: UIAlertController.Style, actions: [UIAlertAction]) -> FlowContributors {
        print("asndjansojdankjdaijdaskj")
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { alert.addAction($0) }
        self.rootViewController.topViewController?.present(alert, animated: true)
        return .none
    }
    
    private func presentToFailureAlert(title: String?, message: String?, action: [UIAlertAction]) -> FlowContributors {
        print("======================================")
        print("asndjansojdankjdaijdaskj")
        print("======================================")
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
