//
//  UserManager.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/15.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum UserLoginType {
    case phone(mobile: String, code: String)
    case aliAu(token: String)
    case wechat(openId: String, nickName: String, avatar: String, sex: Int)
    case apple(openId: String, nickName: String)
}

enum LoginStatus: Int {
    case notLogin
    case login
    case change
    case loginOut
}

class UserManager: NSObject {
    
    static let shared = UserManager()
    
    let login = BehaviorRelay<(UserModel?, LoginStatus)>(value: (nil, .loginOut))
    
    private let loading = ActivityIndicator()
    
    private let parsedError = PublishSubject<NetError>()
    private let error = ErrorTracker()
    
    private let onView = UIApplication.shared.keyWindow
    
    private let userPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? "") + "/userinfo"
    
    var isLogin: Bool {
        let s = login.value
        return s.1 != .loginOut && s.1 != .notLogin
    }
    
    override init() {
        super.init()
        setupBinding()
    }
    
    private func setupBinding() {
        
        if let view = onView {
            error.asObservable().map { (error) -> NetError? in
                print(error)
                if let e = error as? NetError {
                    return e
                }
                return NetError.error(code: -1111, msg: error.localizedDescription)
            }.filterNil().bind(to: view.rx.toastError).disposed(by: rx.disposeBag)

            loading.asObservable().bind(to: view.rx.mbHudLoaing).disposed(by: rx.disposeBag)
        }
        let user = NSKeyedUnarchiver.unarchiveObject(withFile: userPath) as? UserModel
        if user != nil {
            login.accept((user, .login))
        }
        login.subscribe(onNext: {[weak self] user in
            guard let self = self else { return }
            if let u = user.0 {
                NSKeyedArchiver.archiveRootObject(u, toFile: self.userPath)
            } else {
                try? FileManager.default.removeItem(atPath: self.userPath)
            }
        }).disposed(by: rx.disposeBag)
    }
    
    
    // MARK: - Login
    
    func updateUser() {
        if isLogin {
            let update = NetManager.requestObj(.updateUser(token: nil), type: UserModel.self)
            update.asObservable().trackError(error).subscribe(onNext: {[weak self] newUser in
                guard let self = self else { return }
                newUser?.token = self.login.value.0?.token
                self.login.accept((newUser, .change))
            }, onError: { error in
//                self.login.accept(nil)
            }).disposed(by: rx.disposeBag)
        }
    }
    
    func login(with type: UserLoginType) -> Single<Void> {
        switch type {
        case let .aliAu(token: token):
            return login(api: .aliAuth(token: token))
        case let .wechat(openId, nickName, avatar, sex):
            return login(api: .thirdLogin(type: .weChat, openId: openId, nickName: nickName, avatar: avatar, sex: sex, deviceToken: LibsManager.shared.deviceToken))
        case let .apple(openId, nickName):
            return login(api: .thirdLogin(type: .apple, openId: openId, nickName: nickName, avatar: "", sex: 3, deviceToken: LibsManager.shared.deviceToken))
        default:
            return login(api: .aliAuth(token: ""))
        }
    }
    
    // MARK: - Login
    
    private func login(api: NetAPI) -> Single<Void> {
        
        return Single<Void>.create { single in
            
            let login = NetManager.requestObj(api, type: UserModel.self)
            login.asObservable().trackActivity(self.loading).trackError(self.error).subscribe(onNext: { user in
                guard let user = user else { return }
                let update = NetManager.requestObj(.updateUser(token: user.token), type: UserModel.self)
                update.asObservable().debug().trackActivity(self.loading).trackError(self.error).subscribe(onNext: { updateUser in
                    guard let updateUser = updateUser else { return }
                    updateUser.token = user.token
                    self.login.accept((updateUser, .login))
                    single(.success(()))
                }, onError: { error in
                    single(.error(error))
                }).disposed(by: self.rx.disposeBag)
            }, onError: { error in
                single(.error(error))
            }).disposed(by: self.rx.disposeBag)
            
            return Disposables.create()
        }
    }
    
}

