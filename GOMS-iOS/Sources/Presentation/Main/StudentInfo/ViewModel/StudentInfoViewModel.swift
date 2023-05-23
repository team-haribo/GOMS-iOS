import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya

class StudentInfoViewModel: BaseViewModel, Stepper{
    
    struct Input {
        let searchBarButton: Observable<Void>
        let editUserButtonDidTap: Observable<UUID>
    }
    
    struct Output {
        
    }
    
    func transVC(input: Input) {
        input.searchBarButton.subscribe(
            onNext: pushSearchModal
        ) .disposed(by: disposeBag)
        
        input.editUserButtonDidTap
            .bind(with: self) { owner, accountIdx in
                print(accountIdx)
                self.steps.accept(GOMSStep.editUserModalIsRequired(accountIdx: accountIdx))
            }
            .disposed(by: disposeBag)
    }
    
    private func pushSearchModal() {
        self.steps.accept(GOMSStep.searchModalIsRequired)
    }
}

extension StudentInfoViewModel {
    func studentInfo(completion: @escaping () -> Void) {
        studentCouncilProvider.request(.studentInfo(authorization: accessToken)){ response in
            switch response {
            case let .success(result):
                let responseData = result.data
                print(String(data: responseData, encoding: .utf8))
                do {
                    self.studentUserInfo = try JSONDecoder().decode([StudentInfoResponse].self, from: responseData)
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
                case 404: break
                default:
                    print("ERROR")
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }
    
}
