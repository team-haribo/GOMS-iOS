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
import Moya

class BaseViewModel{
    var disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    let keychain = Keychain()
    let gomsRefreshToken = GOMSRefreshToken.shared
    lazy var accessToken = "Bearer " + (keychain.read(key: Const.KeychainKey.accessToken) ?? "")
}
