import Foundation
import Moya

enum LateServices {
    case lateRank(authorization: String)
}


extension LateServices: TargetType {
    public var baseURL: URL {
        return URL(string: BaseURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .lateRank:
            return "/late/rank"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .lateRank:
            return .get
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .lateRank:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .lateRank(let authorization):
            return["Content-Type" :"application/json","Authorization" : authorization]
        default:
            return["Content-Type" :"application/json"]
        }
    }
}
