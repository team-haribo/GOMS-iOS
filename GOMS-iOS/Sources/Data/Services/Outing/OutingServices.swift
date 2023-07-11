import Foundation
import Moya

enum OutingServices {
    case outing(authorization: String, qrCodeURL: String)
    case outingList(authorization: String)
    case outingCount(authorization: String)
    case outingSearch(authorization: String, name: String)
}


extension OutingServices: TargetType {
    public var baseURL: URL {
        switch self {
        case .outing(_,let qrCodeURL):
            return URL(string: qrCodeURL) ?? URL(string: BaseURL.baseURL)!
        default:
            return URL(string: BaseURL.baseURL)!
        }
    }
    
    var path: String {
        switch self {
        case .outing:
            return "/"
        case .outingList:
            return "/outing/"
        case .outingCount:
            return "/outing/count"
        case .outingSearch:
            return "/outing/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .outing:
            return .post
        case .outingList, .outingCount, .outingSearch:
            return .get
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .outing, .outingList, .outingCount, .outingSearch:
            return .requestPlain
        case let .outingSearch(_, name):
            return .requestParameters(parameters: ["name" : name ?? ""], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .outing(let authorization, _), .outingList(let authorization), .outingCount(let authorization), .outingSearch(let authorization, _):
            return["Content-Type" :"application/json","Authorization" : authorization]
        default:
            return["Content-Type" :"application/json"]
        }
    }
}
