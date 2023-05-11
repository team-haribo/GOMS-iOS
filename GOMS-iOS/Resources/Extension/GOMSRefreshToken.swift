import Foundation
import Moya
import UIKit
import RxFlow
import RxCocoa

class GOMSRefreshToken {
    var steps = PublishRelay<Step>()
    var statusCode: Int = 0
    private let authProvider = MoyaProvider<AuthServices>()
    private var reissuanceData: SignInResponse!
    private let keychain = Keychain()
    private lazy var refreshToken = "Bearer " + (keychain.read(key: Const.KeychainKey.refreshToken) ?? "")

    func tokenReissuance() {
        authProvider.request(.refreshToken(refreshToken: refreshToken)) { response in
            switch response {
            case .success(let result):
                do {
                    self.reissuanceData = try result.map(SignInResponse.self)
                }catch(let err) {
                    print(String(describing: err))
                }
                self.statusCode = result.statusCode
                switch self.statusCode {
                case 200..<300:
                    self.updateKeychainToken()
                    UserDefaults.standard.set(self.statusCode, forKey: "statusCode")
                case 400, 401, 404:
                    self.steps.accept(GOMSStep.introIsRequired)
                default:
                    self.steps.accept(GOMSStep.introIsRequired)
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }
    
    func updateKeychainToken() {
        self.keychain.updateItem(
            token: self.reissuanceData.accessToken,
            key: Const.KeychainKey.accessToken
        )
        self.keychain.updateItem(
            token: self.reissuanceData.refreshToken,
            key: Const.KeychainKey.refreshToken
        )
        self.keychain.updateItem(
            token: self.reissuanceData.authority,
            key: Const.KeychainKey.authority
        )
    }
}

