//
//  EditNameService.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/2.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol EditNameService: AnyObject {
    
    func requestEditName(value: String) -> Observable<Void>
    
}

class EditNameCircleNameService: EditNameService {
    
    private var id: String
    
    init(id: String) {
        self.id = id
    }
    
    func requestEditName(value: String) -> Observable<Void> {
        return NetManager.requestResponse(.circleEdit(id: id, type: .name, value: value)).asObservable()
    }
    
}

class EditNameCircleUserNameService: EditNameService {
    
    private var id: String
    private var userId: String
    
    init(id: String, userId: String) {
        self.id = id
        self.userId = userId
    }
    
    func requestEditName(value: String) -> Observable<Void> {
        
        return NetManager.requestResponse(.circleOtherName(id: id, userId: userId, value: value)).asObservable()
        
    }
    
}

class EditNameUserNameService: EditNameService {
    
    func requestEditName(value: String) -> Observable<Void> {
        
        return NetManager.requestResponse(.changeUserInfo(type: .nickname, value: value)).asObservable()
    }
    
}
