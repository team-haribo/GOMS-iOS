//
//  OutingFlow.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import RxFlow
import UIKit
import RxCocoa
import RxSwift

struct OutingStepper: Stepper{
    var steps = PublishRelay<Step>()

    var initialStep: Step{
        return GOMSStep.outingIsRequired
    }
}

class OutingFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }
    
    var stepper = OutingStepper()
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()

    init(){}
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? GOMSStep else { return .none }
        switch step {
            
        case .outingIsRequired:
            return coordinateToOuting()
            
        case .profileIsRequired:
            return coordinateToProfile()
            
        case .introIsRequired:
            return .end(forwardToParentFlowWithStep: GOMSStep.introIsRequired)
            
        default:
            return .none
        }
    }
    
    private func coordinateToOuting() -> FlowContributors {
        let vm = OutingViewModel()
        let vc = OutingViewController(vm)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
    }
    
    private func coordinateToProfile() -> FlowContributors {
        let vm = ProfileViewModel()
        let vc = ProfileViewController(vm)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
    }
}
