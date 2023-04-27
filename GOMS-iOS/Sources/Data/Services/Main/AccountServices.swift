import Foundation
import Moya

enum AccountServices {
    case account(authorization: String)
}


extension AccountServices: TargetType {
    public var baseURL: URL {
        return URL(string: BaseURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .account:
            return "/account/profile"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .account:
            return .get
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .account:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .account(let authorization):
            return["Content-Type" :"application/json","Authorization" : authorization]
        default:
            return["Content-Type" :"application/json"]
        }
    }
}
