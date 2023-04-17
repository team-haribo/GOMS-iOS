//
//  BaseViewModel.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/17.
//

import UIKit
import RxSwift
import RxCocoa
import RxFlow

class BaseViewModel{
    var disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
}
