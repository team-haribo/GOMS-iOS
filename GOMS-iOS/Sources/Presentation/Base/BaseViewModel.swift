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
    let gomsRefreshToken = GOMSRefreshToken()
    lazy var accessToken = "Bearer " + (keychain.read(key: Const.KeychainKey.accessToken) ?? "")
    let authProvider = MoyaProvider<AuthServices>()
    let lateProvider = MoyaProvider<LateServices>(plugins: [NetworkLoggerPlugin()])
    let outingProvider = MoyaProvider<OutingServices>(plugins: [NetworkLoggerPlugin()])
    let accountProvider = MoyaProvider<AccountServices>(plugins: [NetworkLoggerPlugin()])
    let studentCouncilProvider = MoyaProvider<StudentCouncilServices>(plugins: [NetworkLoggerPlugin()])
    var userData: AccountResponse!
    var lateRank: [LateRankResponse] = []
    var outingCount: OutingCountResponse?
    var outingList: [OutingListResponse] = []
    var studentUserInfo: [StudentInfoResponse] = []
    var authData: SignInResponse!
    var uuidData: MakeQRCodeResponse?
}
