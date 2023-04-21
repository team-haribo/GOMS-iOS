//
//  ProfileFlow.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/21.
//

import RxFlow
import UIKit
import RxCocoa
import RxSwift

struct ProfileStepper: Stepper{
    var steps = PublishRelay<Step>()

    var initialStep: Step{
        return GOMSStep.profileIsRequired
    }
}

class ProfileFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }
    
    var stepper = ProfileStepper()
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()

    init(){}
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? GOMSStep else { return .none }
        switch step {
        case .tabBarIsRequired:
            return .end(forwardToParentFlowWithStep: GOMSStep.tabBarIsRequired)
            
        case .introIsRequired:
            return .end(forwardToParentFlowWithStep: GOMSStep.introIsRequired)
            
        case .homeIsRequired:
            return .end(forwardToParentFlowWithStep: GOMSStep.homeIsRequired)
            
        case .profileIsRequired:
            return coordinateToProfile()
            
        default:
            return .none
        }
    }
    
    private func coordinateToProfile() -> FlowContributors {
        let vm = ProfileViewModel()
        let vc = ProfileViewController(vm)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
    }
}
