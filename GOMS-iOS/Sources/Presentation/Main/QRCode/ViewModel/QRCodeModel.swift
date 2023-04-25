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
