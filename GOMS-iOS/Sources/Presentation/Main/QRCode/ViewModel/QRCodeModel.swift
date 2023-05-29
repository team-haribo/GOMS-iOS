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


class QRCodeViewModel: BaseViewModel, Stepper{
    struct Input {
        let useQRCodeButtonTap: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transVC(input: Input) {
        input.useQRCodeButtonTap.subscribe(
            onNext: pushQRCodeVC
        ) .disposed(by: disposeBag)
    }
    
    private func pushQRCodeVC() {
        let vm = QRCodeViewModel()
        let vc = QRCodeViewController(vm)
        vc.callQrScanStart()
    }
}

extension QRCodeViewModel {
    func userOutingData(qrCodeURL: String) {
        outingProvider.request(.outing(authorization: accessToken, qrCodeURL: qrCodeURL)) { response in
            switch response {
            case let .success(result):
                let statusCode = result.statusCode
                switch statusCode{
                case 200..<300:
                    self.steps.accept(GOMSStep.alert(
                        title: "오류",
                        message: "블랙리스트이거나 올바르지 않은 QRCode입니다.",
                        style: .alert,
                        actions: [
                            .init(title: "확인", style: .default) {_ in
                                self.steps.accept(GOMSStep.tabBarIsRequired)
                            },
                        ]
                    ))
                case 400:
                    self.steps.accept(GOMSStep.failureAlert(
                        title: "오류",
                        message: "블랙리스트이거나 올바르지 않은 QRCode입니다."
                    ))
                case 401:
                    self.gomsRefreshToken.tokenReissuance()
                    self.steps.accept(GOMSStep.failureAlert(
                        title: "오류",
                        message: "다시 한 번 작업을 실행해주세요"
                    ))
                default:
                    print("ERROR")
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }
    func makeQRCode() {
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
                case 404:
                    print("----------------------")
                    print(self.uuidData)
                    print("----------------------")
                default:
                    print("ERROR")
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }
}
