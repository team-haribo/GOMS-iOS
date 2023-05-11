import Foundation
import Moya

enum StudentCouncilServices {
    case makeQRCode(authorization: String)
    case studentInfo(authorization: String)
}


extension StudentCouncilServices: TargetType {
    public var baseURL: URL {
        return URL(string: BaseURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .makeQRCode:
            return "/student-council/outing"
        case .studentInfo:
            return "/student-council/account"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .makeQRCode:
            return .post
        case .studentInfo:
            return .get
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .makeQRCode, .studentInfo:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .makeQRCode(let authorization), .studentInfo(let authorization):
            return["Content-Type" :"application/json","Authorization" : authorization]
        default:
            return["Content-Type" :"application/json"]
        }
    }
}
