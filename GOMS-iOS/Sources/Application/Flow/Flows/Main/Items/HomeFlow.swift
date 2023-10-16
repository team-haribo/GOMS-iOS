//
//  HomeFlow.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import RxFlow
import UIKit
import RxCocoa
import RxSwift

struct HomeStepper: Stepper{
    var steps = PublishRelay<Step>()

    var initialStep: Step{
        return GOMSStep.homeIsRequired
    }
}

class HomeFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }
    
    var stepper = HomeStepper()
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()

    init(){}
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? GOMSStep else { return .none }
        switch step {
        case .outingIsRequired:
            return .one(flowContributor: .forwardToParentFlow(withStep: GOMSStep.outingIsRequired))

        case .qrocdeIsRequired:
            return .one(flowContributor: .forwardToParentFlow(withStep: GOMSStep.qrocdeIsRequired))

        case .homeIsRequired:
            return coordinateToHome()
            
        case .profileIsRequired:
            return coordinateToProfile()
            
        case .introIsRequired:
            return .end(forwardToParentFlowWithStep: GOMSStep.introIsRequired)
            
        case .studentInfoIsRequired:
            return coordinateToStudentInfo()
            
        case .searchModalIsRequired:
            return coordinateToSearchModal()
            
        case let .editUserModalIsRequired(accountIdx):
            return coordinateToEditUserModal(accountIdx: accountIdx)
            
        case .searchModalDismiss:
            return dismissSearchModal()
            
        case .editModalDismiss:
            return dismissEditModal()
            
        case let .alert(title, message, style, actions):
            return presentToAlert(title: title, message: message, style: style, actions: actions)
            
        case let .failureAlert(title, message, action):
            return presentToFailureAlert(title: title, message: message, action: action)
            
        default:
            return .none
        }
    }
    
    private func coordinateToHome() -> FlowContributors {
        let reactor = HomeReactor()
        let vc = HomeViewController(reactor)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
    
    private func coordinateToProfile() -> FlowContributors {
        let reactor = ProfileReactor()
        let vc = ProfileViewController(reactor)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
    
    private func coordinateToStudentInfo() -> FlowContributors{
        let vm = StudentInfoViewModel()
        let vc = StudentInfoViewController(vm)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
    }
    
    private func presentToAlert(title: String?, message: String?, style: UIAlertController.Style, actions: [UIAlertAction]) -> FlowContributors {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { alert.addAction($0) }
        self.rootViewController.topViewController?.present(alert, animated: true)
        return .none
    }
    
    private func presentToFailureAlert(title: String?, message: String?, action: [UIAlertAction]) -> FlowContributors {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if !action.isEmpty {
            action.forEach(alert.addAction(_:))
        } else {
            alert.addAction(.init(title: "확인", style: .default))
        }
        self.rootViewController.topViewController?.present(alert, animated: true)
        return .none
    }
    
    private func coordinateToSearchModal() -> FlowContributors{
        let vm = SearchModalViewModal.shared
        let vc = SearchModalViewController(vm)
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 20
        }
        self.rootViewController.topViewController?.present(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
    }
    
    private func dismissSearchModal() -> FlowContributors {
        let vm = StudentInfoViewModel()
        let vc = StudentInfoViewController(vm)
        self.rootViewController.dismiss(animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
    }
    
    private func dismissEditModal() -> FlowContributors {
        let vm = StudentInfoViewModel()
        let vc = StudentInfoViewController(vm)
        self.rootViewController.dismiss(animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
    }
    
    private func coordinateToEditUserModal(accountIdx: UUID) -> FlowContributors{
        let vm = EditUserModalViewModel(accountIdx: accountIdx)
        let vc = EditUserModalViewController(vm)
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 20
        }
        self.rootViewController.present(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
    }
}
