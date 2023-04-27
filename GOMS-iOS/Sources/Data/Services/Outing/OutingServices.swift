import Foundation
import Moya

enum OutingServices {
    case outing(param: OutingRequest)
}


extension OutingServices: TargetType {
    public var baseURL: URL {
        return URL(string: BaseURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .outing:
            return "/outing/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .outing:
            return .get
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .outing(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return["Content-Type" :"application/json"]
        }
    }
}
