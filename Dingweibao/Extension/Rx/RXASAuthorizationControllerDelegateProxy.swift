//
//  RXASAuthorizationControllerDelegateProxy.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/5.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import AuthenticationServices

@available(iOS 13.0, *)
extension ASAuthorizationController: HasDelegate {
    public typealias Delegate = ASAuthorizationControllerDelegate
}

@available(iOS 13.0, *)
class RXASAuthorizationControllerDelegateProxy:
DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>,
DelegateProxyType, ASAuthorizationControllerDelegate {
    
    weak private(set) var authorizationController: ASAuthorizationController?
    
    init(authorizationController: ASAuthorizationController) {
        self.authorizationController = authorizationController
        super.init(parentObject: authorizationController, delegateProxy: RXASAuthorizationControllerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { parent -> RXASAuthorizationControllerDelegateProxy in
            RXASAuthorizationControllerDelegateProxy(authorizationController: parent)
        }
    }
    
}

@available(iOS 13.0, *)
extension Reactive where Base: ASAuthorizationController {
    
    var delegate: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate> {
        return RXASAuthorizationControllerDelegateProxy.proxy(for: base)
    }
    
    var didCompleteWithAuthorization: Observable<ASAuthorization> {
        return delegate.methodInvoked(#selector(ASAuthorizationControllerDelegate.authorizationController(controller:didCompleteWithAuthorization:))).map { parameters in
            return parameters[1] as! ASAuthorization
        }
    }
    
    var didCompleteWithError: Observable<Error> {
        return delegate.methodInvoked(#selector(ASAuthorizationControllerDelegate.authorizationController(controller:didCompleteWithError:))).map { parameters in
            return parameters[1] as! Error
        }
    }
    
}
