import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya

class SearchModalViewModal: BaseViewModel, Stepper{
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transVC(input: Input) {
        
    }
}
extension SearchModalViewModal {
    func searchStudent(completion: @escaping () -> Void, grade: Int?, classNum: Int?, name: String?, isBlackList: Bool?, authority: String?) {
        studentCouncilProvider.request(.search(authorization: accessToken, grade: grade, classNum: classNum, name: name, isBlackList: isBlackList, authority: authority)){ response in
            switch response {
            case let .success(result):
                let responseData = result.data
                print(String(data: responseData, encoding: .utf8))
                do {
                    self.searchResult = try JSONDecoder().decode([SearchResponse].self, from: responseData)
                    completion()
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
                    self.steps.accept(GOMSStep.failureAlert(title: "오류", message: "학생회 계정이 아닙니다."))
                    self.steps.accept(GOMSStep.introIsRequired)
                default:
                    print("ERROR")
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }

}
