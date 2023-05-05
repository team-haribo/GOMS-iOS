//
//  ProfileViewModel.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/21.
//

import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya

class ProfileViewModel: BaseViewModel, Stepper{
    
    struct Input {
        let logoutButtonDidTap: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transVC(input: Input) {
        input.logoutButtonDidTap.subscribe(
            onNext: logout
        ) .disposed(by: disposeBag)
    }
}

extension ProfileViewModel {
    private func logout() {
        self.steps.accept(GOMSStep.introIsRequired)
        deleteUserToken()
    }
    
    private func deleteUserToken() {
        keychain.deleteItem(key: Const.KeychainKey.accessToken)
        keychain.deleteItem(key: Const.KeychainKey.refreshToken)
        keychain.deleteItem(key: Const.KeychainKey.authority)
    }
}
