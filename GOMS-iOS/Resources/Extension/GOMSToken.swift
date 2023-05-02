import UIKit
import Security

struct Const {
    struct KeychainKey {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
        static let accessTokenExp = "accessTokenExp"
        static let refreshTokenExp = "refreshTokenExp"
        static let authority = "authority"
    }
}

class Keychain {
    func create(key: String, token: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: token.data(using: .utf8, allowLossyConversion: false) as Any
        ]
        SecItemDelete(query) // MARK: Keychain은 key 중복 값이 생기면 저장이 안되니 먼저 삭제를 해준다.
        
        let status = SecItemAdd(query, nil)
        assert(status == noErr, "failed to save Token")
    }
    
    func read(key: String) -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue as Any,  //MARK: CFData 타입으로 불러오라는 의미
            kSecMatchLimit: kSecMatchLimitOne       //MARK: 중복되는 경우, 하나의 값만 불러오라는 의미
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == errSecSuccess {
            if let retrievedData: Data = dataTypeRef as? Data {
                let value = String(data: retrievedData, encoding: String.Encoding.utf8)
                return value
            } else { return nil }
        } else {
            print("failed to loading, status code = \(status)")
            return nil
        }
    }
    
    func delete(key: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        let status = SecItemDelete(query)
        assert(status == noErr, "failed to delete the value, status code = \(status)")
    }
}
