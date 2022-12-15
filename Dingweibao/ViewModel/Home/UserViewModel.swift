//
//  UserViewModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/5/28.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class UserViewModel: ViewModel, ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        var items: BehaviorRelay<[UserCellViewModel]>
        var login: BehaviorRelay<UserModel?>
    }
    
    func transform(input: Input) -> Output {
        
        let items = BehaviorRelay<[UserCellViewModel]>(value: [])
        let login = BehaviorRelay<UserModel?>(value: nil)
        
        let pro = UserCellViewModel(type: .pro)
        let message = UserCellViewModel(type: .message)
        let phone = UserCellViewModel(type: .phone)
        let power = UserCellViewModel(type: .power)
        let setting = UserCellViewModel(type: .setting)
        
        UserManager.shared.login.subscribe(onNext: { user in
            login.accept(user.0)
            if let user = user.0 {
                message.dot.accept(user.messageNum > 0)
            }
        }).disposed(by: rx.disposeBag)
        
        items.accept([pro, message, phone, power, setting])
        
        return Output(items: items, login: login)
    }
    
    
}
