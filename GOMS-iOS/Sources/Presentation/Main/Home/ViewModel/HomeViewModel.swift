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
        lateProvider.request(.lateRank(authorization: accessToken)) { response in
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
        outingProvider.request(.outingCount(authorization: accessToken)) { response in
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
        UserDefaults.standard.set(self.userData.name, forKey: "userName")
        UserDefaults.standard.set(self.userData.studentNum.classNum, forKey: "userClassNum")
        UserDefaults.standard.set(self.userData.studentNum.grade, forKey: "userGrade")
        UserDefaults.standard.set(self.userData.studentNum.number, forKey: "userNum")
        UserDefaults.standard.set(self.userData.lateCount, forKey: "userLateCount")
        UserDefaults.standard.set(self.userData.profileUrl, forKey: "userProfileURL")
    }
}
