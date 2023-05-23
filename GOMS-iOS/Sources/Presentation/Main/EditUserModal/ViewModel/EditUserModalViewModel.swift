import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya

class EditUserModalViewModel: BaseViewModel, Stepper{
    
    let accountIdx: UUID
    
    init(accountIdx: UUID) {
        self.accountIdx = accountIdx
    }
        
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transVC(input: Input) {
        
    }
}
