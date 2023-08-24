import Foundation
import UIKit
import RxFlow
import RxCocoa
import RxSwift
import Moya

class StudentInfoViewModel: BaseViewModel, Stepper{
    let studentCouncilProvider = MoyaProvider<StudentCouncilServices>(plugins: [NetworkLoggerPlugin()])
    var studentUserInfo: [StudentInfoResponse] = []

    struct Input {
        let searchBarButton: Observable<Void>
    }

    struct Output {

    }

    func transVC(input: Input) {
        input.searchBarButton.subscribe(
            onNext: pushSearchModal
        ) .disposed(by: disposeBag)
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

    func blackListDelete(accountIdx: UUID,completion: @escaping () -> Void) {
        studentCouncilProvider.request(.blackListDelete(authorization: accessToken, accountIdx: accountIdx)){ response in
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
                    self.steps.accept(
                        GOMSStep.failureAlert(
                            title: "오류",
                            message: "학생회 계정이 아닙니다.",
                            action: [.init(title: "확인",style: .default) { _ in
                                self.steps.accept(GOMSStep.introIsRequired)}
                            ]
                        )
                    )
                case 404:
                    self.steps.accept(
                        GOMSStep.failureAlert(
                            title: "오류",
                            message: "계정을 찾을 수 없습니다.",
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
