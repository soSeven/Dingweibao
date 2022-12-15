//
//  AuthLoginViewModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/5.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import AuthenticationServices

class AuthLoginViewModel: ViewModel, ViewModelType {
    
    var window: UIWindow?
    
    var isCheck = true
    
    struct Input {
        let weChat: Observable<Void>
        let apple: Observable<Void>
    }
    
    struct Output {
        let loginSuccess: PublishRelay<String>
    }
    
    func transform(input: Input) -> Output {
        
        let loginSuccess = PublishRelay<String>()
        
        input.weChat.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if !self.isCheck {
                self.parsedError.onNext(.error(code: -1000, msg: "请先同意相关协议"))
                return
            }
            self.weChatLogin().subscribe(onNext: { _ in
                loginSuccess.accept("登录成功")
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        input.apple.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if !self.isCheck {
                self.parsedError.onNext(.error(code: -1000, msg: "请先同意相关协议"))
                return
            }
            if #available(iOS 13.0, *) {
                self.appleLogin().subscribe(onNext: { _ in
                    loginSuccess.accept("登录成功")
                }).disposed(by: self.rx.disposeBag)
            }
        }).disposed(by: rx.disposeBag)

        return Output(loginSuccess: loginSuccess)
    }
    
    /// MARK: - weChat
    
    private func weChatLogin() -> Observable<Void> {
        
        return Single<UMSocialUserInfoResponse>.create { ob in
            
            UMSocialManager.default()?.getUserInfo(with: .wechatSession, currentViewController: nil, completion: { (result, error) in
                if let r = result as? UMSocialUserInfoResponse, error == nil {
                    ob(.success(r))
                } else {
                    ob(.error(NetError.error(code: -1000, msg: "授权失败")))
                }
            })
            return Disposables.create()
        }.flatMap { r in
            let openid = r.openid ?? ""
            let nickName = r.name ?? ""
            let avator = r.iconurl ?? ""
            var sex = 3
            if let gender = r.unionGender, gender.hasSuffix("男") {
                sex = 1
            } else if let gender = r.unionGender, gender.hasSuffix("女") {
                sex = 2
            }
            return UserManager.shared.login(with: .wechat(openId: openid, nickName: nickName, avatar: avator, sex: sex))
        }
        .timeout(.seconds(30), scheduler: MainScheduler.instance).trackError(error).trackActivity(loading).asObservable()
        
    }
    
    // MARK: - Apple
    
    @available(iOS 13.0, *)
    private func appleLogin() -> Observable<Void> {
        
        return Single<ASAuthorizationAppleIDCredential>.create { [weak self] single -> Disposable in
            guard let self = self else {
                single(.error(NetError.error(code: -1000, msg: "授权失败")))
                return Disposables.create()
            }
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let vc = ASAuthorizationController(authorizationRequests: [request])
            vc.presentationContextProvider = self
            vc.performRequests()
            vc.rx.didCompleteWithAuthorization.subscribe(onNext: { authorization in
                if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
                    single(.success(credential))
                } else {
                    single(.error(NetError.error(code: -1000, msg: "授权失败")))
                }
            }).disposed(by: self.rx.disposeBag)
            vc.rx.didCompleteWithError.subscribe(onNext: { error in
                print(error)
                single(.error(NetError.error(code: -1000, msg: "授权失败")))
            }).disposed(by: self.rx.disposeBag)
            
            return Disposables.create()
        }.flatMap { credential -> Single<Void> in
            let userId = credential.user
            var name = ""
            if let f = credential.fullName?.familyName, let g = credential.fullName?.givenName {
                name = f + g
            }
            return UserManager.shared.login(with: .apple(openId: userId, nickName: name))
        }.trackError(error).trackActivity(loading).asObservable()
        
    }
    
}

//extension AuthLoginViewModel: ASAuthorizationControllerDelegate {
//
//    @available(iOS 13.0, *)
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
//            let userId = credential.user
//            var name = ""
//            if let f = credential.fullName?.familyName, let g = credential.fullName?.givenName {
//                name = f + g
//            }
//            UserManager.shared.login(with: .apple(openId: userId, nickName: name)).subscribe(onSuccess: { _ in
//                print("成功")
//            })
//        }
//    }
//
//    @available(iOS 13.0, *)
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//
//    }
//
//}

extension AuthLoginViewModel: ASAuthorizationControllerPresentationContextProviding {
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window ?? UIWindow()
    }
    
}
