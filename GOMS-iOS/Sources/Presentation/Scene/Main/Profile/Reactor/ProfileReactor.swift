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
        self.steps.accept(GOMSStep.alert(
            title: "로그아웃",
            message: "정말 로그아웃 하시겠습니까?",
            style: .alert,
            actions: [
                .init(title: "확인", style: .default) {_ in
                    self.steps.accept(GOMSStep.introIsRequired)
                    self.deleteUserToken()
                },
                .init(title: "취소", style: .cancel)
            ]
        ))
    }
    
    private func deleteUserToken() {
        keychain.deleteItem(key: Const.KeychainKey.accessToken)
        keychain.deleteItem(key: Const.KeychainKey.refreshToken)
        keychain.deleteItem(key: Const.KeychainKey.authority)
    }
}
