//
//  HomeUserItemCellViewModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/5/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import DeviceKit

class HomeUserItemCellViewModel {
    
    let disposeBag = DisposeBag()
    
    enum UserListModelType {
        case normal
        case all
        case add
    }
    
    enum UserListEventType {
        case sharePosition
        case shareDistance
        case goSetting
    }
    
    var type: UserListModelType = .normal
    let avatar = BehaviorRelay<String>(value: "")
    let distance = BehaviorRelay<Float>(value: 0)
    let id = BehaviorRelay<String>(value: "")
    let uniqueId = BehaviorRelay<String>(value: "")
    let isMe = BehaviorRelay<Bool>(value: false)
    let isHidden = BehaviorRelay<Bool>(value: false)
    let lastElectric = BehaviorRelay<Int>(value: 0)
    let lastLat = BehaviorRelay<String>(value: "")
    let lastLng = BehaviorRelay<String>(value: "")
    let lastPosition  = BehaviorRelay<String>(value: "")
    let lastPositionAuth = BehaviorRelay<Int>(value: 0)
    let lastTime = BehaviorRelay<String>(value: "")
    let nickname = BehaviorRelay<String>(value: "")
    let isSelected = BehaviorRelay<Bool>(value: false)
    
    // 事件
    let eventRelay = PublishRelay<UserListEventType>()
    
    init(model: HomeUserListModel?, type: UserListModelType = .normal) {
        self.type = type
        if let m = model {
            avatar.accept(m.avatar)
            distance.accept(m.distance)
            id.accept(m.id)
            uniqueId.accept(m.uniqueId)
            isMe.accept(m.isMe)
            isHidden.accept(m.isHidden)
            
//            let la: Double = (m.lastLat.double() ?? 0.0) + Double.random(in: 0...10)
//            let long: Double = (m.lastLng.double() ?? 0.0) + Double.random(in: 0...10)
//            lastLat.accept(String(la))
//            lastLng.accept(String(long))
            lastLat.accept(m.lastLat)
            lastLng.accept(m.lastLng)
            lastPosition.accept(m.lastPosition)
            
            lastTime.accept(m.lastTime)
            nickname.accept(m.nickname)
            
            if m.isMe {
                lastElectric.accept(Device.current.batteryLevel ?? 100)
                LocationAuthManager.shared.authRelay.subscribe(onNext: { [weak self] status in
                    guard let self = self else { return }
                    switch status {
                    case .authorized:
                        self.lastPositionAuth.accept(1)
                    default:
                        self.lastPositionAuth.accept(2)
                    }
                    
                }).disposed(by: disposeBag)
            } else {
                lastElectric.accept(m.lastElectric)
                lastPositionAuth.accept(m.lastPositionAuth)
            }
        }
        
    }

}
