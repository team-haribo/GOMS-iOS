import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya
import ReactorKit

class ProfileReactor: Reactor, Stepper{
    // MARK: - Properties
    var initialState: State
    
    let provider = MoyaProvider<AccountServices>(plugins: [NetworkLoggerPlugin()])
    
    var userData: AccountResponse?
    
    var steps: PublishRelay<Step> = .init()
    
    let keychain = Keychain()
    
    let gomsAdminRefreshToken = GOMSRefreshToken.shared
    
    lazy var accessToken = "Bearer " + (keychain.read(key: Const.KeychainKey.accessToken) ?? "")
    
    // MARK: - Reactor
    
    enum Action {
        case viewWillAppear
        case logoutButtonDidTap
    }
    
    enum Mutation {
        case fetchUserData(userData: AccountResponse)
    }
    
    struct State {
        var userData: AccountResponse?
    }
    
    // MARK: - Init
    init() {
        self.initialState = State()
    }
}

// MARK: - Mutate
extension ProfileReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return viewWillAppear()
        case .logoutButtonDidTap:
            return logoutButtonDidtap()
        }
    }
}

extension ProfileReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .fetchUserData(userData):
            newState.userData = userData
        }
        return newState
    }
}

// MARK: - Method
private extension ProfileReactor {
    func viewWillAppear() -> Observable<Mutation> {
        return Observable.create { observer in
            self.provider.request(.account(authorization: self.accessToken)) { result in
                switch result {
                case let .success(res):
                    do {
                        self.userData = try res.map(AccountResponse.self)
                    }catch(let err) {
                        print(String(describing: err))
                    }
                    let statusCode = res.statusCode
                    switch statusCode{
                    case 200..<300:
                        guard let data = self.userData else {return}
                        print(data)
                        observer.onNext(Mutation.fetchUserData(userData: data))
                    case 401:
                        self.gomsAdminRefreshToken.tokenReissuance()
                        self.steps.accept(GOMSStep.failureAlert(
                            title: "오류",
                            message: "작업을 한 번 더 시도해주세요"
                        ))
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
    
    func logoutButtonDidtap() -> Observable<Mutation> {
        self.steps.accept(GOMSStep.alert(
            title: "로그아웃",
            message: "정말 로그아웃 하시겠습니까?",
            style: .alert,
            actions: [
                .init(title: "확인", style: .default) {_ in
                    self.steps.accept(GOMSStep.introIsRequired)
                    self.deleteUserToken()
                },
                .init(title: "취소", style: .cancel)
            ]
        ))
        return .empty()
    }
    
    private func deleteUserToken() {
        keychain.deleteItem(key: Const.KeychainKey.accessToken)
        keychain.deleteItem(key: Const.KeychainKey.refreshToken)
        keychain.deleteItem(key: Const.KeychainKey.authority)
    }
}
