//
//  LocationModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/12.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import DeviceKit

class LocationModel {
    
    let disposeBag = DisposeBag()
    
    var lng: String = "0"
    var lat: String = "0"
    var position: String = "未知"
    
    init() {
        
        Observable<Int>.interval(.seconds(10), scheduler: MainScheduler.instance).startWith(0).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if UserManager.shared.isLogin {
                NetManager.requestResponse(.uploadData(lng: self.lng, lat: self.lat, position: self.position, electric: Device.current.batteryLevel ?? 100)).subscribe(onSuccess: { _ in
                    
                }).disposed(by: self.disposeBag)
            }
        }).disposed(by: disposeBag)
        
    }
    
}
