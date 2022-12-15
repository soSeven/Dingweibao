//
//  UserCellViewModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/5/28.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum UserCellType: String {
    
    case pro = "专业版"
    case phone = "伪装来电"
    case message = "消息"
    case power = "电量提醒"
    case setting = "设置"
    
    var imgName: String {
        switch self {
        case .pro:
            return "icon_vip"
        case .phone:
            return "icon_call"
        case .message:
            return "icon_message"
        case .power:
            return "icon_dltx"
        case .setting:
            return "icon_setup"
        }
    }
}

class UserCellViewModel {
    
    var title = ""
    var imgName = ""
    var dot = BehaviorRelay<Bool>(value: false)
    var type: UserCellType = .pro
    
    init(type: UserCellType) {
        title = type.rawValue
        self.type = type
        imgName = type.imgName
    }

}
