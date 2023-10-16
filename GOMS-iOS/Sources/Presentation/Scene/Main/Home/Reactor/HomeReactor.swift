import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya
import ReactorKit

class HomeReactor: Reactor, Stepper{
    // MARK: - Properties
    var initialState: State
    
    var steps: PublishRelay<Step> = .init()
    
    let outingProvider = MoyaProvider<OutingServices>(plugins: [NetworkLoggerPlugin()])
    
    let lateProvider = MoyaProvider<LateServices>(plugins: [NetworkLoggerPlugin()])
    
    let profileProvider = MoyaProvider<AccountServices>(plugins: [NetworkLoggerPlugin()])
    
    var userData: AccountResponse?
    
    var lateRank: [LateRankResponse] = []
    
    var outingCount: OutingCountResponse = .init(outingCount: 0)
        
    let keychain = Keychain()
    
    let gomsAdminRefreshToken = GOMSRefreshToken.shared
    
    lazy var accessToken = "Bearer " + (keychain.read(key: Const.KeychainKey.accessToken) ?? "")
    
    // MARK: - Reactor
    
    enum Action {
        case profileButtonDidTap
        case createQRCodeButtonDidTap
        case outingButtonDidTap
        case fetchOutingCount
        case fetchLateRank
        case fetchProfile
        case manageButtonDidTap
    }
    
    enum Mutation {
        case fetchOutingCount(count: Int)
        case fetchLateRank(lateRank: [LateRankResponse])
        case fetchProfile(userData: AccountResponse)
    }
    
    struct State {
        var count: Int = 0
        var lateRank: [LateRankResponse] = []
        var userData: AccountResponse?
    }
    
    // MARK: - Init
    init() {
        self.initialState = State()
    }
}

// MARK: - Mutate
extension HomeReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .profileButtonDidTap:
            return profileButtonDidTap()
        case .createQRCodeButtonDidTap:
            return createQRCodeButtonDidTap()
        case .outingButtonDidTap:
            return outingButtonDidTap()
        case .fetchOutingCount:
            return fetchOutingCount()
        case .fetchLateRank:
            return fetchLateRank()
        case .fetchProfile:
            return fetchProfile()
        case .manageButtonDidTap:
            return manageButtonDidTap()
        }
    }
}

extension HomeReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .fetchProfile(userData):
            newState.userData = userData
        case let .fetchOutingCount(count):
            newState.count = count
        case let .fetchLateRank(lateRank):
            newState.lateRank = lateRank
        }
        return newState
    }
}

// MARK: - Method
private extension HomeReactor {
    func profileButtonDidTap() -> Observable<Mutation> {
        self.steps.accept(GOMSStep.profileIsRequired)
        return .empty()
    }
    
    func createQRCodeButtonDidTap() -> Observable<Mutation> {
        self.steps.accept(GOMSStep.qrocdeIsRequired)
        return .empty()
    }
    
    func outingButtonDidTap() -> Observable<Mutation> {
        self.steps.accept(GOMSStep.outingIsRequired)
        return .empty()
    }
    
    func manageButtonDidTap() -> Observable<Mutation> {
        self.steps.accept(GOMSStep.studentInfoIsRequired)
        return .empty()
    }
    
    func fetchOutingCount() -> Observable<Mutation> {
        return Observable.create { observer in
            self.outingProvider.request(.outingCount(authorization: self.accessToken)) { result in
                switch result {
                case let .success(res):
                    do {
                        self.outingCount = try res.map(OutingCountResponse.self)
                    }catch(let err) {
                        print(String(describing: err))
                    }
                    let statusCode = res.statusCode
                    switch statusCode{
                    case 200..<300:
                        observer.onNext(Mutation.fetchOutingCount(
                            count: self.outingCount.outingCount
                        ))
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
    
    func fetchLateRank() -> Observable<Mutation> {
        return Observable.create { observer in
            self.lateProvider.request(.lateRank(authorization: self.accessToken)) { result in
                switch result {
                case let .success(res):
                    do {
                        self.lateRank = try res.map([LateRankResponse].self)
                    }catch(let err) {
                        print(String(describing: err))
                    }
                    let statusCode = res.statusCode
                    switch statusCode{
                    case 200..<300:
                        observer.onNext(Mutation.fetchLateRank(lateRank: self.lateRank))
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
    
    func fetchProfile() -> Observable<Mutation> {
        return Observable.create { observer in
            self.profileProvider.request(.account(authorization: self.accessToken)) { result in
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
                        guard let userData = self.userData else {return}
                        observer.onNext(Mutation.fetchProfile(userData: userData))
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
}
