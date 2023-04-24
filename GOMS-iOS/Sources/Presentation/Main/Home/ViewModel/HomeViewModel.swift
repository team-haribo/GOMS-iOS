//
//  HomeViewModel.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import Foundation
import RxFlow
import RxSwift
import RxCocoa

class HomeViewModel: BaseViewModel, Stepper{
    
    struct Input {
        let navProfileButtonTap: Observable<Void>
        let outingButtonTap: Observable<Void>
        let profileButtonTap: Observable<Void>
        let useQRCodeButtonTap: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transVC(input: Input) {
        input.navProfileButtonTap.subscribe(
            onNext: pushProfileVC
        ) .disposed(by: disposeBag)
        
        input.profileButtonTap.subscribe(
            onNext: pushProfileVC
        ) .disposed(by: disposeBag)
        
        input.outingButtonTap.subscribe(
            onNext: pushOutingVC
        ) .disposed(by: disposeBag)
        
        input.useQRCodeButtonTap.subscribe(
            onNext: pushQRCodeVC
        ) .disposed(by: disposeBag)
    }
    
    private func pushProfileVC() {
        self.steps.accept(GOMSStep.profileIsRequired)
    }
    
    private func pushOutingVC() {
        self.steps.accept(GOMSStep.outingIsRequired)
    }
    
    private func pushQRCodeVC() {
        self.steps.accept(GOMSStep.qrocdeIsRequired)
    }
}
