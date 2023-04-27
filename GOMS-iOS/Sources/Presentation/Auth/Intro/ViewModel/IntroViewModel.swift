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
    
    private let authProvider = MoyaProvider<AuthServices>(plugins: [NetworkLoggerPlugin()])
    private var userData: SignInResponse!
    
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
            case let .success(result):
                do {
                    self.userData = try result.map(SignInResponse.self)
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
}
