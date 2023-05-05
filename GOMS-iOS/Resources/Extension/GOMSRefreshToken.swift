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
                    self.addKeychainToken()
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
    
    func deleteKeychainToken() {
        self.keychain.deleteItem(key: Const.KeychainKey.accessToken)
        self.keychain.deleteItem(key: Const.KeychainKey.authority)
        self.keychain.deleteItem(key: Const.KeychainKey.refreshToken)
    }
    
    func addKeychainToken() {
        self.keychain.create(
            key: Const.KeychainKey.accessToken,
            token: self.reissuanceData.accessToken
        )
        self.keychain.create(
            key: Const.KeychainKey.refreshToken,
            token: self.reissuanceData.refreshToken
        )
        self.keychain.create(
            key: Const.KeychainKey.authority,
            token: self.reissuanceData.authority
        )
    }
}

