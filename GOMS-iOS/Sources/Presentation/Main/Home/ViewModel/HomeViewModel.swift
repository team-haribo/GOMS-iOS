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
    weak var delegate: HomeViewModelDelegate?
    
    let outingProvider = MoyaProvider<OutingServices>(plugins: [NetworkLoggerPlugin()])
    let lateProvider = MoyaProvider<LateServices>(plugins: [NetworkLoggerPlugin()])
    let accountProvider = MoyaProvider<AccountServices>(plugins: [NetworkLoggerPlugin()])
    
    var outingCount: OutingCountResponse?
    var userData: AccountResponse?
    var lateRank: [LateRankResponse] = []
    
    struct Input {
        let refreshAction: Observable<Void>
        let navProfileButtonTap: Observable<Void>
        let outingButtonTap: Observable<Void>
        let profileButtonTap: Observable<Void>
        let useQRCodeButtonTap: Observable<Void>
        let manageStudentButtonTap: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transVC(input: Input) {
        input.refreshAction.subscribe(
            onNext: { [weak self] _ in
                self?.delegate?.refreshMain()
            }
        ).disposed(by: disposeBag)
        
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
        
        input.manageStudentButtonTap.subscribe(
            onNext: pushStudentInfoVC
        ) .disposed(by: disposeBag)
    }
    
    private func pushProfileVC() {
        self.steps.accept(GOMSStep.profileIsRequired)
    }
    
    private func pushOutingVC() {
        self.steps.accept(GOMSStep.outingIsRequired)
    }
    
    private func pushQRCodeVC() {
        if self.userData?.isBlackList == true {
            self.steps.accept(GOMSStep.failureAlert(title: "" , message: "외출이 금지된 상태입니다."))
        }
        else {
            self.steps.accept(GOMSStep.qrocdeIsRequired)
        }
    }
    
    private func pushStudentInfoVC() {
        self.steps.accept(GOMSStep.studentInfoIsRequired)
    }
}

protocol HomeViewModelDelegate: AnyObject {
    func refreshMain()
}

extension HomeViewModel {
    func getLateRank(completion: @escaping () -> Void) {
        lateProvider.request(.lateRank(authorization: accessToken)) { response in
            switch response {
            case let .success(result):
                let responseData = result.data
                do {
                    self.lateRank = try JSONDecoder().decode([LateRankResponse].self, from: responseData)
                    completion()
                    print("----------------------")
                    print(self.lateRank)
                    print("----------------------")
                }catch(let err) {
                    print(String(describing: err))
                }
                let statusCode = result.statusCode
                switch statusCode{
                case 200..<300:
                    self.steps.accept(GOMSStep.tabBarIsRequired)
                case 401:
                    self.gomsRefreshToken.tokenReissuance()
                    self.steps.accept(GOMSStep.failureAlert(
                        title: "오류",
                        message: "다시 한 번 작업을 실행해주세요"
                    ))
                case 404:
                    self.steps.accept(
                        GOMSStep.failureAlert(
                            title: "오류",
                            message: "알 수 없는 오류가 발생했습니다.",
                            action: [.init(title: "확인",style: .default) { _ in
                                self.steps.accept(GOMSStep.introIsRequired)}
                            ]
                        )
                    )
                default:
                    print("ERROR")
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }
    
    func getOutingCount(completion: @escaping () -> Void) {
        outingProvider.request(.outingCount(authorization: accessToken)) { response in
            switch response {
            case let .success(result):
                let responseData = result.data
                do {
                    self.outingCount = try JSONDecoder().decode(OutingCountResponse.self, from: responseData)
                    print(self.outingCount?.outingCount ?? 0)
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
                completion()
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }
    
    func getUserData() {
            accountProvider.request(.account(authorization: accessToken)) { response in
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
                    self.saveUserData()
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
    
    func saveUserData() {
        UserDefaults.standard.set(self.userData?.name, forKey: "userName")
        UserDefaults.standard.set(self.userData?.studentNum.classNum, forKey: "userClassNum")
        UserDefaults.standard.set(self.userData?.studentNum.grade, forKey: "userGrade")
        UserDefaults.standard.set(self.userData?.studentNum.number, forKey: "userNum")
        UserDefaults.standard.set(self.userData?.lateCount, forKey: "userLateCount")
        UserDefaults.standard.set(self.userData?.profileUrl, forKey: "userProfileURL")
        UserDefaults.standard.set(self.userData?.isBlackList, forKey: "userIsBlackList")
        UserDefaults.standard.set(self.userData?.isOuting, forKey: "userIsOuting")
    }
}
