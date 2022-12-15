//
//  CheckManager.swift
//  Dingweibao
//
//  Created by LiQi on 2020/7/2.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CheckManager {
    
    static let shared = CheckManager()
    
    var isCheck = true
    private let disposeBag = DisposeBag()
    
    init() {
        ReachabilityManager.shared.relay.subscribe(onNext: {[weak self] status in
            guard let self = self else { return }
            self.activeApp()
            if !self.isCheck { return }
            NetManager.requestResponseObj(.isCheck).subscribe(onSuccess: { resp in
                if let isCheck = resp.data?["is_examine"].bool, !isCheck {
                    self.isCheck = false
                } else {
                    self.isCheck = true
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }
    
    private func activeApp() {
        let key = "active_app_install_key_2"
        if let _ = UserDefaults.standard.value(forKey: key) {
            return
        }
        NetManager.requestResponseObj(.active).subscribe(onSuccess: { resp in
            UserDefaults.standard.set(key, forKey: key)
        }).disposed(by: self.disposeBag)
    }
}
