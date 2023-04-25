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
}
