//
//  CircleListCellViewModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/2.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CircleListCellViewModel {
    
    var avatar = BehaviorRelay<String>(value: "")
    var encodeId : String!
    var name = BehaviorRelay<String>(value: "")
    var id : Int!
    var joinAuth : Int!
    var userCount = BehaviorRelay<Int>(value: 0)
    var isChecked = BehaviorRelay<Bool>(value: false)
    
    init(model: CircleListModel) {
        avatar.accept(model.avatar)
        encodeId = model.encodeId
        name.accept(model.name)
        id = model.id
        joinAuth = model.joinAuth
        userCount.accept(model.userCount)
        isChecked.accept(model.isChecked)
    }

}
