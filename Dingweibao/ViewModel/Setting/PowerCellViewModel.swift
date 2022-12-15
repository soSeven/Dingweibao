//
//  PowerCellViewModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/13.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PowerCellViewModel {
    
    let avatar = BehaviorRelay<String>(value: "")
    let nickname = BehaviorRelay<String>(value: "")
    let id = BehaviorRelay<String>(value: "")
    let isRemind = BehaviorRelay<Bool>(value: false)
    let remindEvent = PublishRelay<Void>()
    
    init(model: PowerModel) {
        avatar.accept(model.avatar)
        nickname.accept(model.nickname)
        id.accept(model.id)
        isRemind.accept(model.isRemind)
    }
}
