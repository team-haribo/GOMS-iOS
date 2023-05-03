//
//  HomeViewModel.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import Foundation
import RxFlow
import RxSwift
import RxCocoa
import Moya

class HomeViewModel: BaseViewModel, Stepper{
    private let lateProvider = MoyaProvider<LateServices>(plugins: [NetworkLoggerPlugin()])
    private let outingProvider = MoyaProvider<OutingServices>(plugins: [NetworkLoggerPlugin()])
    private let accountProvider = MoyaProvider<AccountServices>(plugins: [NetworkLoggerPlugin()])
    private var userData: AccountResponse!
    private var lateRank: [LateRankResponse]!
    private var outingCount: OutingCountResponse!
    
    struct Input {
        let navProfileButtonTap: Observable<Void>
        let outingButtonTap: Observable<Void>
        let profileButtonTap: Observable<Void>
        let useQRCodeButtonTap: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transVC(input: Input) {
        input.navProfileButtonTap.subscribe(
            onNext: pushProfileVC
        ) .disposed(by: disposeBag)
        
        input.profileButtonTap.subscribe(
            onNext: pushProfileVC
        ) .disposed(by: disposeBag)
        
        input.outingButtonTap.subscribe(
            onNext: pushOutingVC
        ) .disposed(by: disposeBag)
        
        input.useQRCodeButtonTap.subscribe(
            onNext: pushQRCodeVC
        ) .disposed(by: disposeBag)
    }
    
    private func pushProfileVC() {
        self.steps.accept(GOMSStep.profileIsRequired)
    }
    
    private func pushOutingVC() {
        self.steps.accept(GOMSStep.outingIsRequired)
    }
    
    private func pushQRCodeVC() {
        self.steps.accept(GOMSStep.qrocdeIsRequired)
    }
}
extension HomeViewModel {
    func getLateRank() {
        lateProvider.request(
            .lateRank(
                authorization: keychain.read(
                    key: Const.KeychainKey.accessToken
                )!
            )
        ) { response in
            switch response {
            case let .success(result):
                let responseData = result.data
                do {
                    self.lateRank = try JSONDecoder().decode([LateRankResponse].self, from: responseData)
                }catch(let err) {
                    print(String(describing: err))
                }
                let statusCode = result.statusCode
                switch statusCode{
                case 200..<300:
                    self.steps.accept(GOMSStep.tabBarIsRequired)
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
    
    func getOutingCount() {
        outingProvider.request(
            .outingCount(
                authorization: keychain.read(
                    key: Const.KeychainKey.accessToken
                )!
            )
        ) { response in
            switch response {
            case let .success(result):
                let responseData = result.data
                do {
                    self.outingCount = try JSONDecoder().decode(OutingCountResponse.self, from: responseData)
                }catch(let err) {
                    print(String(describing: err))
                }
                let statusCode = result.statusCode
                switch statusCode{
                case 200..<300:
                    self.steps.accept(GOMSStep.tabBarIsRequired)
                case 401:
                    self.gomsRefreshToken.tokenReissuance()
                default:
                    print("ERROR")
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }
    
    func getUserData() {
        accountProvider.request(
            .account(
                authorization: keychain.read(
                    key: Const.KeychainKey.accessToken
                )!
            )
        ) { response in
            switch response {
            case let .success(result):
                let responseData = result.data
                do {
                    self.userData = try JSONDecoder().decode(AccountResponse.self, from: responseData)
                }catch(let err) {
                    print(String(describing: err))
                }
                let statusCode = result.statusCode
                switch statusCode{
                case 200..<300:
                    self.steps.accept(GOMSStep.tabBarIsRequired)
                case 401:
                    self.gomsRefreshToken.tokenReissuance()
                default:
                    print("ERROR")
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }
}
