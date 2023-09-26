//
//  RequestViewModel.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import Foundation
import RxFlow
import RxCocoa
import RxSwift
import UIKit
import Moya


class QRCodeViewModel: BaseViewModel, Stepper{
    let outingProvider = MoyaProvider<OutingServices>(plugins: [NetworkLoggerPlugin()])
    
    let studentCouncilProvider = MoyaProvider<StudentCouncilServices>(plugins: [NetworkLoggerPlugin()])

    var uuidData: MakeQRCodeResponse?

    struct Input {
        let logoDidTap: Observable<Void>
        let backButtonDidTap: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transVC(input: Input) {
        input.logoDidTap.subscribe(
            onNext: coordinateToHome
        ).disposed(by: disposeBag)
        input.backButtonDidTap.subscribe(
            onNext: coordinateToHome
        ).disposed(by: disposeBag)
    }
    
    private func pushProfileVC() {
        self.steps.accept(GOMSStep.profileIsRequired)
    }
     
    private func coordinateToHome() {
        self.steps.accept(GOMSStep.homeIsRequired)
    }
}

extension QRCodeViewModel {
    func userOutingData(qrCodeURL: String) {
        outingProvider.request(.outing(authorization: accessToken, qrCodeURL: qrCodeURL)) { response in
            switch response {
            case let .success(result):
                let statusCode = result.response?.statusCode ?? 500
                switch statusCode{
                case 200..<300:
                    self.steps.accept(GOMSStep.alert(
                        title: "스캔 완료",
                        message: "QR코드 스캔이 완료되었습니다",
                        style: .alert,
                        actions: [
                            .init(title: "확인", style: .default) {_ in
                                self.steps.accept(GOMSStep.homeIsRequired)
                            }
                        ]
                    ))
                case 400:
                    self.steps.accept(GOMSStep.alert(
                        title: "오류",
                        message: "블랙리스트이거나 올바르지 않은 QRCode입니다.",
                        style: .alert,
                        actions: [
                            .init(title: "확인", style: .default) {_ in
                                self.steps.accept(GOMSStep.homeIsRequired)
                            }
                        ]
                    ))
                case 401:
                    self.gomsRefreshToken.tokenReissuance()
                    self.steps.accept(GOMSStep.alert(
                        title: "오류",
                        message: "다시 한 번 작업을 실행해주세요",
                        style: .alert,
                        actions: [
                            .init(title: "확인", style: .default) {_ in
                                self.steps.accept(GOMSStep.homeIsRequired)
                            }
                        ]
                    ))
                default:
                    self.steps.accept(GOMSStep.alert(
                        title: "오류",
                        message: "올바르지 않은 QRCode입니다.",
                        style: .alert,
                        actions: [
                            .init(title: "확인", style: .default) {_ in
                                self.steps.accept(GOMSStep.homeIsRequired)
                            }
                        ]
                    ))
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }
    func makeQRCode(completion: @escaping () -> Void) {
        studentCouncilProvider.request(.makeQRCode(authorization: accessToken)){ response in
            switch response {
            case let .success(result):
                let responseData = result.data
                print(String(data: responseData, encoding: .utf8))
                do {
                    self.uuidData = try JSONDecoder().decode(MakeQRCodeResponse.self, from: responseData)
                }catch(let err) {
                    print(String(describing: err))
                }
                let statusCode = result.statusCode
                switch statusCode{
                case 200..<300:
                    print("success")
                case 401:
                    self.gomsRefreshToken.tokenReissuance()
                    self.steps.accept(GOMSStep.failureAlert(
                        title: "오류",
                        message: "다시 한 번 작업을 실행해주세요"
                    ))
                default:
                    self.steps.accept(GOMSStep.failureAlert(
                        title: "오류",
                        message: "알 수 없는 오류가 발생하였습니다.",
                        action: [
                            .init(title: "확인", style: .default) {_ in
                                self.steps.accept(GOMSStep.introIsRequired)
                            }
                        ]))
                }
                completion()
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }
}
