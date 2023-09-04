import Foundation
import Moya

enum NotificationServices {
    case postDeviceToken(baseURL: String, authorization: String, deviceToken: String)
}


extension NotificationServices: TargetType {
    public var baseURL: URL {
        return URL(string: BaseURL.baseURL)!
    }

    var path: String {
        switch self {
        case let .postDeviceToken(baseURL,_,_):
            return "\(baseURL)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postDeviceToken:
            return .post
        }
    }

    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }

    var task: Task {
        switch self {
        case .postDeviceToken:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        switch self {
        case let .postDeviceToken(_,authorization, _):
            return["Content-Type" :"application/json","Authorization" : authorization]
        }
    }
}
