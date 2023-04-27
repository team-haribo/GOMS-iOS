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
    private var userData: SignInModel!
    
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
                    self.userData = try result.map(SignInModel.self)
                    print(self.userData ?? "error")
                    self.steps.accept(GOMSStep.tabBarIsRequired)
                }catch(let err) {
                    print(err.localizedDescription)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
