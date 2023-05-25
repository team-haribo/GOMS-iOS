import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya

class EditUserModalViewModel: BaseViewModel, Stepper{
    
    let accountIdx: UUID
    
    init(accountIdx: UUID) {
        self.accountIdx = accountIdx
    }
        
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transVC(input: Input) {
        
    }
}

extension EditUserModalViewModel {
    func editAuthority(authority: String) {
        let param = EditAuthorityRequest(accountIdx: accountIdx, authority: authority)
        studentCouncilProvider.request(.editAuthority(authorization: accessToken, param: param)){ response in
            switch response {
            case let .success(result):
                let statusCode = result.statusCode
                switch statusCode{
                case 200..<300:
                    print("success")
                case 401:
                    self.gomsRefreshToken.tokenReissuance()
                case 403:
                    self.steps.accept(GOMSStep.failureAlert(title: "오류", message: "학생회 계정이 아닙니다."))
                    self.steps.accept(GOMSStep.introIsRequired)
                case 404:
                    self.steps.accept(GOMSStep.failureAlert(title: "오류", message: "계정을 찾을 수 없습니다."))
                    self.steps.accept(GOMSStep.introIsRequired)
                default:
                    print("ERROR")
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }
    
    func isBlackList() {
        studentCouncilProvider.request(.isBlackList(authorization: accessToken, accountIdx: accountIdx)){ response in
            switch response {
            case let .success(result):
                let statusCode = result.statusCode
                print(self.accessToken)
                switch statusCode{
                case 200..<300:
                    print("success")
                case 401:
                    self.gomsRefreshToken.tokenReissuance()
                case 403:
                    self.steps.accept(GOMSStep.failureAlert(title: "오류", message: "학생회 계정이 아닙니다."))
                    self.steps.accept(GOMSStep.introIsRequired)
                case 404:
                    self.steps.accept(GOMSStep.failureAlert(title: "오류", message: "계정을 찾을 수 없습니다."))
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
