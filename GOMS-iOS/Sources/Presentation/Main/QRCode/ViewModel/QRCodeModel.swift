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
    func userOutingData(outingUUID:UUID) {
        outingProvider.request(.outing(authorization: accessToken, outingUUID: outingUUID)) { response in
            switch response {
            case let .success(result):
                let statusCode = result.statusCode
                switch statusCode{
                case 200..<300:
                    self.steps.accept(GOMSStep.tabBarIsRequired)
                case 400:
                    break;
                case 401:
                    break;
                default:
                    print("ERROR")
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
    }
}
