import Foundation
import UIKit
import RxFlow
import RxCocoa
import RxSwift
import Moya

class StudentInfoViewModel: BaseViewModel, Stepper{
    let provider = MoyaProvider<StudentCouncilServices>(plugins: [NetworkLoggerPlugin()])
    var studentUserInfo: [StudentInfoResponse] = []
    var searchResult: [SearchResponse] = []
    
    let grade: Int?
    let classNum: Int?
    let name: String?
    let isBlackList: Bool
    let authority: String?
    
    init(grade: Int?,classNum: Int?,name: String?,isBlackList: Bool,authority: String?) {
        self.grade = grade
        self.classNum = classNum
        self.name = name
        self.isBlackList = isBlackList
        self.authority = authority
    }
    
    struct Input {
        let searchBarButton: Observable<Void>
        var viewWillAppear: Observable<Void>
        var searchModalDismiss: Observable<Void>
    }
    
    struct Output {
        var studentList: Observable<[StudentInfoResponse]>
        var searchResult: Observable<[SearchResponse]>
    }
    
    func transform(_ input: Input) -> Output {
        let studentListRelay = BehaviorRelay<[StudentInfoResponse]>(value: [])
        let searchResultRelay = BehaviorRelay<[SearchResponse]>(value: [])
        
        input.searchBarButton.subscribe(
            onNext: pushSearchModal
        ) .disposed(by: disposeBag)
        
        input.viewWillAppear
            .flatMap {
                Observable<[StudentInfoResponse]>.create { observer in
                    self.provider.request(.studentInfo(authorization: self.accessToken)) { response in
                        switch response {
                        case let .success(result):
                            let responseData = result.data
                            let statusCode = result.statusCode
                            do {
                                self.studentUserInfo = try JSONDecoder().decode([StudentInfoResponse].self, from:responseData)
                                observer.onNext(self.studentUserInfo)
                                
                            }catch(let err) {
                                print(String(describing: err))
                            }
                            switch statusCode{
                            case 200..<300:
                                print("success")
                            case 401:
                                self.gomsRefreshToken.tokenReissuance()
                            case 404: break
                            default:
                                print("ERROR")
                            }
                        case let .failure(err):
                            observer.onError(err)
                        }
                    }
                    return Disposables.create()
                }
            }
            .bind(to: studentListRelay)
            .disposed(by: disposeBag)
        
        input.searchModalDismiss
            .flatMap {
                Observable<[SearchResponse]>.create { [self] observer in
                    self.provider.request(.search(authorization: self.accessToken, grade: grade, classNum: classNum,name: name, isBlackList: isBlackList, authority: authority)) { response in
                        switch response {
                        case let .success(result):
                            let responseData = result.data
                            let statusCode = result.statusCode
                            do {
                                self.searchResult = try JSONDecoder().decode([SearchResponse].self, from: responseData)
                                observer.onNext(self.searchResult)
                                
                            }catch(let err) {
                                print(String(describing: err))
                            }
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
                                            self.steps.accept(GOMSStep.introIsRequired)
                                        }]
                                    )
                                )
                            default:
                                print("ERROR")
                            }
                        case let .failure(err):
                            observer.onError(err)
                        }
                    }
                    return Disposables.create()
                }
            }
            .bind(to: searchResultRelay)
            .disposed(by: disposeBag)
        
        return Output(
            studentList: studentListRelay.asObservable(),
            searchResult: searchResultRelay.asObservable()
        )
    }
    
    func pushSearchModal() {
        self.steps.accept(GOMSStep.searchModalIsRequired)
    }
}

extension StudentInfoViewModel {
    func blackListDelete(accountIdx: UUID,completion: @escaping () -> Void) {
        provider.request(.blackListDelete(authorization: accessToken, accountIdx: accountIdx)){ response in
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
                                self.steps.accept(GOMSStep.introIsRequired)
                            }]
                        )
                    )
                case 404:
                    self.steps.accept(
                        GOMSStep.failureAlert(
                            title: "오류",
                            message: "계정을 찾을 수 없습니다.",
                            action: [.init(title: "확인",style: .default) { _ in
                                self.steps.accept(GOMSStep.introIsRequired)
                            }]
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
