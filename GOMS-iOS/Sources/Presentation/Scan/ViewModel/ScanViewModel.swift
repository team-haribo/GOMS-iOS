import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya

class ScanViewModel: BaseViewModel, Stepper{
    struct Input {
        let nextButtonDidTap: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transVC(input: Input) {
        input.nextButtonDidTap.subscribe(
            onNext: pushHome
        ) .disposed(by: disposeBag)
    }
    
    private func pushHome() {
        self.steps.accept(GOMSStep.homeIsRequired)
    }
}
