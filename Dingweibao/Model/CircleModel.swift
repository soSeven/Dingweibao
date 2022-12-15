//
//  CircleModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/5/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import RxCocoa

class CircleListModel: NSObject, Mapable {
    
    var avatar : String!
    var encodeId : String!
    var name : String!
    var id : Int!
    var userCount : Int!
    var isChecked: Bool!
    var joinAuth : Int!
    var isInvited: Bool!
    
    required init(json: JSON) {
        
        avatar = json["avatar"].stringValue
        encodeId = json["encode_id"].stringValue
        name = json["name"].stringValue
        id = json["id"].intValue
        joinAuth = json["join_auth"].intValue
        userCount = json["user_count"].intValue
        isChecked = json["is_checked"].boolValue
        isInvited = json["is_invited"].boolValue
    }
    
}

class CircleDataModel: NSObject, Mapable {

    var info : CircleInfoModel!
    var isCreater : Bool!
    var users : [CircleUserModel]!

    required init(json: JSON) {

        info = CircleInfoModel(json: json["info"])
        isCreater = json["is_creater"].boolValue
        users = json["users"].arrayValue.map{CircleUserModel(json: $0)}
    }
    
}

class CircleUserModel: NSObject, Mapable {

    var avatar : String!
    var id : String!
    var isCreater : Bool!
    var isMe : Bool!
    var nickname : String!
    
    required init(json: JSON) {
        avatar = json["avatar"].stringValue
        id = json["id"].stringValue
        isCreater = json["is_creater"].boolValue
        isMe = json["is_me"].boolValue
        nickname = json["nickname"].stringValue
    }

}

class CircleInfoModel: NSObject, Mapable {

    var avatar : String!
    var id : Int!
    var joinAuth : Int!  // 加群权限.1=群主验证通过,2=无需验证,3=拒绝所有人
    var name : String!

    required init(json: JSON) {
        avatar = json["avatar"].stringValue
        id = json["id"].intValue
        joinAuth = json["join_auth"].intValue
        name = json["name"].stringValue
    }

}

class CircleOtherModel: NSObject, Mapable {

    var avatar : String!
    var id : String!
    var isCreater : Bool!
    var isHide = BehaviorRelay<Bool>(value: false)
    var hideEvent = PublishSubject<Bool>()
    var nickname : String!
    var remarks : String!
    var mobile : String!
    
    required init(json: JSON) {
        avatar = json["avatar"].stringValue
        id = json["id"].stringValue
        isCreater = json["is_creater"].boolValue
        isHide.accept(json["is_hide"].boolValue)
        nickname = json["nickname"].stringValue
        mobile = json["mobile"].stringValue
        remarks = json["remarks"].stringValue
    }

}

class CircleAvatarSectionModel: NSObject, Mapable {
    
    var avatars : [CircleAvatarModel]!
    var name : String!
    
    required init(json: JSON) {
        avatars = [CircleAvatarModel]()
        let avatarsArray = json["avatars"].arrayValue
        for avatarsJson in avatarsArray{
            let value = CircleAvatarModel(json: avatarsJson)
            avatars.append(value)
        }
        name = json["name"].stringValue
    }
    
}

class CircleAvatarModel: NSObject, Mapable {

    var avatar : String!
    var id : Int!

    required init(json: JSON) {
        avatar = json["avatar"].stringValue
        id = json["id"].intValue
    }

}
