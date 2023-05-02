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
                print(String(data: result.data, encoding: .utf8))
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
        self.keychain.delete(key: Const.KeychainKey.accessToken)
        self.keychain.delete(key: Const.KeychainKey.accessTokenExp)
        self.keychain.delete(key: Const.KeychainKey.authority)
        self.keychain.delete(key: Const.KeychainKey.refreshToken)
        self.keychain.delete(key: Const.KeychainKey.refreshTokenExp)
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

