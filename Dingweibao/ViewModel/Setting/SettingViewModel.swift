//
//  SettingViewModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/8.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum SettingType {
    case about(title: String)
    case userProtocol(title: String)
    case userPrivacy(title: String)
}

class SettingViewModel: ViewModel, ViewModelType {
    
    struct Input {
        var request: Observable<Void>
    }
    
    struct Output {
        var items: BehaviorRelay<[SettingType]>
    }
    
    func transform(input: Input) -> Output {
        
        let items = BehaviorRelay<[SettingType]>(value: [
            .about(title: "关于我们"),
            .userProtocol(title: "用户协议"),
            .userPrivacy(title: "隐私政策")
        ])

        return Output(items: items)
    }
    
    
}
