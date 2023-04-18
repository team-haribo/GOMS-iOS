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

struct RequestStepper: Stepper{
    var steps = PublishRelay<Step>()

    var initialStep: Step{
        return GOMSStep.requestIsRequired
    }
}

class RequestFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }
    
    var stepper = RequestStepper()
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()

    init(){}
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? GOMSStep else { return .none }
        switch step {
        case .requestIsRequired:
            return coordinateToRequset()
        default:
            return .none
        }
    }
    
    private func coordinateToRequset() -> FlowContributors {
        let vm = RequsetViewModel()
        let vc = RequestViewController(vm)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
    }
}
