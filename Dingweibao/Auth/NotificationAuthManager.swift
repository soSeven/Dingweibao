//
//  NotificationAuthManager.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/3.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import Permission
import RxSwift
import RxCocoa

class NotificationAuthManager: NSObject {
    
    static let shared = NotificationAuthManager()
    
    let permission = Permission.notifications
    let authRelay: BehaviorRelay<PermissionStatus>
    
    override init() {
        
        authRelay = BehaviorRelay<PermissionStatus>(value: permission.status)
        
        super.init()
        
        request()
        
        authRelay.subscribe(onNext: { status in
            print(status)
        }).disposed(by: rx.disposeBag)
        
        permission.presentDisabledAlert = false
        permission.presentDeniedAlert = false
        permission.presentPrePermissionAlert = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifily(no:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func notifily(no: NSNotification) {
        authRelay.accept(permission.status)
    }
    
    func request() {
        permission.request {[weak self] status in
            guard let self = self else { return }
            self.authRelay.accept(status)
        }
    }
}
