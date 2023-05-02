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
    
    private let authProvider = MoyaProvider<AuthServices>()
    private var userData: SignInResponse!
    let keychain = Keychain()
    
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
                    self.userData = try result.map(SignInResponse.self)
                    self.addKeychainToken()
                }catch(let err) {
                    print(String(describing: err))
                }
                let statusCode = result.statusCode
                switch statusCode{
                case 200..<300:
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
            token: self.userData.accessToken
        )
        self.keychain.create(
            key: Const.KeychainKey.accessTokenExp,
            token: self.userData.accessTokenExp
        )
        self.keychain.create(
            key: Const.KeychainKey.refreshToken,
            token: self.userData.refreshToken
        )
        self.keychain.create(
            key: Const.KeychainKey.refreshTokenExp,
            token: self.userData.refreshTokenExp
        )
        self.keychain.create(
            key: Const.KeychainKey.authority,
            token: self.userData.authority
        )
    }
}
