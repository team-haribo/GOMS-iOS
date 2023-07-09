import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya

class SearchModalViewModal: BaseViewModel, Stepper{
    static let shared = SearchModalViewModal()
    let provider = MoyaProvider<StudentCouncilServices>(plugins: [NetworkLoggerPlugin()])

    var searchResult: [SearchResponse] = []
    
    private override init() { }

    struct Input {
    }
    
    struct Output {
    }
}
extension SearchModalViewModal {
    func searchStudent(grade: Int?, classNum: Int?, name: String?, isBlackList: Bool?, authority: String?,completion: @escaping () -> Void) {
        provider.request(.search(authorization: accessToken, grade: grade, classNum: classNum, name: name, isBlackList: isBlackList, authority: authority)){ response in
            switch response {
            case let .success(result):
                let responseData = result.data
                print(String(data: responseData, encoding: .utf8))
                do {
                    self.searchResult = try JSONDecoder().decode([SearchResponse].self, from: responseData)
                }catch(let err) {
                    print(String(describing: err))
                }
                let statusCode = result.statusCode
                switch statusCode{
                case 200..<300:
                    print("success")
                case 401:
                    self.gomsRefreshToken.tokenReissuance()
                case 404:
                    self.steps.accept(
                        GOMSStep.failureAlert(
                            title: "오류",
                            message: "학생회 계정이 아닙니다.",
                            action: [.init(title: "확인",style: .default) { _ in
                                self.steps.accept(GOMSStep.introIsRequired)}
                            ]
                        )
                    )
                default:
                    print("ERROR")
                }
                completion()
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }

}
