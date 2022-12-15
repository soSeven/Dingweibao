//
//  SettingModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/8.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftyJSON

class PowerModel: Mapable {
    
    var avatar : String!
    var nickname : String!
    var id : String!
    var isRemind : Bool!
    
    required init(json: JSON) {
        
        nickname = json["nickname"].stringValue
        avatar = json["avatar"].stringValue
        id = json["id"].stringValue
        isRemind = json["low_electric_remind"].boolValue
       
    }
    
}


class MessageListModel: Mapable {
    
    var content : String!
    var createTime : String!
    var id : Int!
    var status : Int!
    var title : String!

    required init(json: JSON) {
        content = json["content"].stringValue
        createTime = json["create_time"].stringValue
        id = json["id"].intValue
        status = json["status"].intValue
        title = json["title"].stringValue
    }
    
}
