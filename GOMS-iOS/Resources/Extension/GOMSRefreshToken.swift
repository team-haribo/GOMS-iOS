import Foundation
import Moya
import UIKit

class GOMSRefreshToken {
    private let authProvider = MoyaProvider<AuthServices>()
    private var reissuanceData: RefreshTokenesponse!
    private let keychain = Keychain()

    func tokenReissuance() {
        authProvider.request(
            .refreshToken(
                refreshToken: keychain.read(
                    key: Const.KeychainKey.refreshToken
                )!
            )
        ) { response in
            switch response {
            case .success(let result):
                do {
                    self.reissuanceData = try result.map(RefreshTokenesponse.self)
                }catch(let err) {
                    print(String(describing: err))
                }
                let statusCode = result.statusCode
                switch statusCode{
                case 200..<300:
                    self.deleteKeychainToken()
                    print("Alert 띄우기")
                case 400:
                    print("No Token")
                case 401:
                    print("만료")
                case 404:
                    print("Not Founds")
                default:
                    print("ERROR")
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

