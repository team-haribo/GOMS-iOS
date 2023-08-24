import Foundation
import Moya

enum StudentCouncilServices {
    case makeQRCode(authorization: String)
    case studentInfo(authorization: String)
    case search(authorization: String, grade: Int?, classNum: Int?, name: String?, isBlackList: Bool?, authority: String?)
    case editAuthority(authorization: String, param: EditAuthorityRequest)
    case isBlackList(authorization: String, accountIdx: UUID)
    case blackListDelete(authorization: String, accountIdx: UUID)
    case deleteOutUser(authorization: String, accountIdx: UUID)
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
        case .editAuthority:
            return "/student-council/authority"
        case let .isBlackList(_,accountIdx),let .blackListDelete(_,accountIdx):
            return "/student-council/black-list/\(accountIdx)"
        case let .deleteOutUser(_, accountIdx):
            return "/student-council/outing/\(accountIdx)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .makeQRCode, .isBlackList:
            return .post
        case .studentInfo, .search:
            return .get
        case .editAuthority:
            return .patch
        case .blackListDelete, .deleteOutUser:
            return .delete
        }
    }

    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }

    var task: Task {
        switch self {
        case .makeQRCode, .studentInfo, .isBlackList, .blackListDelete, .deleteOutUser:
            return .requestPlain
        case let .editAuthority(_, param):
            return .requestJSONEncodable(param)
        case let .search(_, grade, classNum, name, isBlackList, authority):
            return .requestParameters(
                parameters: ["grade" : grade ?? "", "classNum" : classNum ?? "", "name" : name ?? "", "isBlackList" : isBlackList ?? "", "authority" : authority ?? ""],
                encoding: URLEncoding.queryString)
        }
    }

    var headers: [String : String]? {
        switch self {
        case let .makeQRCode(authorization), let .studentInfo(authorization), let .search(authorization, _, _, _, _, _), let .editAuthority(authorization,_), let .blackListDelete(authorization,_), let .deleteOutUser(authorization,_):
            return["Content-Type" :"application/json","Authorization" : authorization]
        default:
            return["Content-Type" :"application/json"]
        }
    }
}
