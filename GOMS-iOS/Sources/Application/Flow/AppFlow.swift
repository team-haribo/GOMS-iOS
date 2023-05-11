//
//  AppFlow.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import RxFlow
import UIKit
import Moya
import RxSwift
import RxCocoa

struct AppStepper: Stepper {
    let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    let gomsRefreshToken = GOMSRefreshToken()
    private let statusCode = UserDefaults.standard.integer(forKey: "statusCode")

    init() {}
    
    var initialStep: Step {
        self.gomsRefreshToken.tokenReissuance()
        switch statusCode {
        case 200..<300:
            print(statusCode)
            UserDefaults.standard.removeObject(forKey: "statusCode")
            return GOMSStep.tabBarIsRequired
        default:
            print(statusCode)
            return GOMSStep.introIsRequired
        }
    }
}

final class AppFlow: Flow {
    
    var root: Presentable {
        return window
    }
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
        
    deinit{
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? GOMSStep else {return .none}
        
        switch step {
        case .introIsRequired:
            return coordinateToIntro()
        case .tabBarIsRequired:
            return coordinateToHome()
        default:
            return .none
        }
    }
    
    private func coordinateToIntro() -> FlowContributors {
        let flow = AuthFlow()
        Flows.use(flow, when: .created) { (root) in
            self.window.rootViewController = root
        }
        return .one(
            flowContributor: .contribute(
                withNextPresentable: flow,
                withNextStepper: OneStepper(withSingleStep: GOMSStep.introIsRequired)
        ))
    }

    private func coordinateToHome() -> FlowContributors {
        let flow = TabBarFlow()
        Flows.use(
            flow,
            when: .created
        ) { [unowned self] root in
            self.window.rootViewController = root
        }
        return .one(
            flowContributor: .contribute(
                withNextPresentable: flow,
                withNextStepper: OneStepper(
                    withSingleStep: GOMSStep.tabBarIsRequired
                )
        ))
    }
    
}
