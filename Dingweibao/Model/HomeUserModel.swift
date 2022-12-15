//
//  HomeUserModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/5/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftyJSON

class HomeUserModel: NSObject, Mapable {
    
    var circle : CircleListModel!
    var users : [HomeUserListModel]!
    
    required init(json: JSON) {
        
        circle = CircleListModel(json: json["circle"])
        users = json["users"].arrayValue.map{ HomeUserListModel(json: $0) }
       
    }
    
}

/*
 "id": "c0d9OsqFbfZiH4pCp4pyxH1xW6dDonZR6D6/ZlE2",
 "avatar": "https://o.vgaoshou.com/avatar/default.png",
 "nickname": "我",
 "last_electric": 0,
 "last_lng": null,
 "last_lat": null,
 "last_position": null,
 "last_time": "1970-01-01 08:00",
 "last_position_auth": 1,
 "is_me": true,
 "distance": 0
 */

class HomeUserListModel: NSObject, Mapable {
    
    var avatar : String!
    var distance : Float!
    var id : String!
    var uniqueId : String!
    var isMe : Bool!
    var isHidden : Bool!
    var lastElectric : Int!
    var lastLat : String!
    var lastLng : String!
    var lastPosition : String!
    var lastPositionAuth : Int!
    var lastTime : String!
    var nickname : String!
    
    required init(json: JSON) {
        
        avatar = json["avatar"].stringValue
        distance = json["distance"].floatValue
        id = json["id"].stringValue
        uniqueId = json["unique_id"].stringValue
        isMe = json["is_me"].boolValue
        isHidden = json["is_hide"].boolValue
        lastElectric = json["last_electric"].intValue
        lastLat = json["last_lat"].stringValue
        lastLng = json["last_lng"].stringValue
        lastPosition = json["last_position"].stringValue
        lastPositionAuth = json["last_position_auth"].intValue
        lastTime = json["last_time"].stringValue
        nickname = json["nickname"].stringValue
       
    }
    
}
