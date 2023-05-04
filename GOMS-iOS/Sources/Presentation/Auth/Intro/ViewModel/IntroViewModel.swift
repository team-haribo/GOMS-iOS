//
//  IntroViewModel.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/17.
//

import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya

class IntroViewModel: BaseViewModel, Stepper{    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transVC(input: Input) {
    }

}

extension IntroViewModel {
    func gauthSignInCompleted(code: String) {
        let param = SignInRequest(code: code)
        authProvider.request(.signIn(param: param)) { response in
            switch response {
            case .success(let result):
                print(String(data: result.data, encoding: .utf8))
                do {
                    self.authData = try result.map(SignInResponse.self)
                }catch(let err) {
                    print(String(describing: err))
                }
                let statusCode = result.statusCode
                switch statusCode{
                case 200..<300:
                    self.addKeychainToken()
                    self.steps.accept(GOMSStep.tabBarIsRequired)
                default:
                    print("ERROR")
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }
    
    func addKeychainToken() {
        self.keychain.create(
            key: Const.KeychainKey.accessToken,
            token: self.authData.accessToken
        )
        self.keychain.create(
            key: Const.KeychainKey.refreshToken,
            token: self.authData.refreshToken
        )
        self.keychain.create(
            key: Const.KeychainKey.authority,
            token: self.authData.authority
        )
    }
}
