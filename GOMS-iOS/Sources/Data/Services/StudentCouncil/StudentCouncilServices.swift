import Foundation
import Moya

enum StudentCouncilServices {
    case makeQRCode(authorization: String)
    case studentInfo(authorization: String)
    case search(authorization: String, grade: Int?, classNum: Int?, name: String?, isBlackList: Bool?, authority: String?)
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
        case .search:
            return "/student-council/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .makeQRCode:
            return .post
        case .studentInfo, .search:
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
        case .search(_, let grade, let classNum, let name, let isBlackList, let authority):
            return .requestParameters(
                parameters: ["grade" : grade ?? "", "classNum" : classNum ?? "", "name" : name ?? "", "isBlackList" : isBlackList ?? "", "authority" : authority ?? ""],
                encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .makeQRCode(let authorization), .studentInfo(let authorization), .search(let authorization, _, _, _, _, _):
            return["Content-Type" :"application/json","Authorization" : authorization]
        default:
            return["Content-Type" :"application/json"]
        }
    }
}
