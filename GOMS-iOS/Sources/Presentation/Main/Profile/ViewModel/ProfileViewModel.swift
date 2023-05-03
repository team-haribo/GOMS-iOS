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

    private let accountProvider = MoyaProvider<AccountServices>(plugins: [NetworkLoggerPlugin()])
    private var userData: AccountResponse!

    struct Input {

    }

    struct Output {

    }

    func transVC(input: Input) {
    }

}

extension ProfileViewModel {
    func getUserData() {
        accountProvider.request(
            .account(
                authorization: keychain.read(
                    key: Const.KeychainKey.accessToken
                )!
            )
        ) { response in
            switch response {
            case let .success(result):
                let responseData = result.data
                do {
                    self.userData = try JSONDecoder().decode(AccountResponse.self, from: responseData)
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
