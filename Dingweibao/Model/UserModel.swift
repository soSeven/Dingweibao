//
//  UserModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/15.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserModel: NSObject, Mapable, NSCoding {
    
    var area : String!
    var avatar : String!
    var constellation : String!
    var id : String!
    var isVip : Bool!
    var messageNum : Int!
    var mobile : String!
    var nickname : String!
    var qqOpenid : Bool!
    var sex : Int!
    var vipTime : Int! //vip到期时间,Unix时间戳.默认0表示未开通过vip.-1表示永久VIP
    var wxOpenid : Bool!
    var wxUnionid : Bool!
    var guardNum : Int!
    var regDays : Int!
    
    var token : String!
    
    required init(json: JSON) {
        
        area = json["area"].stringValue
        avatar = json["avatar"].stringValue
        constellation = json["constellation"].stringValue
        id = json["id"].stringValue
        isVip = json["is_vip"].boolValue
        messageNum = json["message_count"].intValue
        mobile = json["mobile"].stringValue
        nickname = json["nickname"].stringValue
        qqOpenid = json["qq_openid"].boolValue
        sex = json["sex"].intValue
        vipTime = json["vip_time"].intValue
        wxOpenid = json["wx_openid"].boolValue
        wxUnionid = json["wx_unionid"].boolValue
        
        token = json["token"].stringValue
        guardNum = json["guard_num"].intValue
        regDays = json["reg_days"].intValue
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(area, forKey: "area")
        coder.encode(avatar, forKey: "avatar")
        coder.encode(constellation, forKey: "constellation")
        coder.encode(id, forKey: "id")
        coder.encode(isVip, forKey: "is_vip")
        coder.encode(messageNum, forKey: "message_count")
        coder.encode(mobile, forKey: "mobile")
        coder.encode(nickname, forKey: "nickname")
        coder.encode(qqOpenid, forKey: "qq_openid")
        coder.encode(sex, forKey: "sex")
        coder.encode(vipTime, forKey: "vip_time")
        coder.encode(wxOpenid, forKey: "wx_openid")
        coder.encode(wxUnionid, forKey: "wx_unionid")
        coder.encode(token, forKey: "token")
        coder.encode(guardNum, forKey: "guard_num")
        coder.encode(regDays, forKey: "reg_days")
    }
    
    required init?(coder: NSCoder) {
        area = coder.decodeObject(forKey: "area") as? String ?? ""
        avatar = coder.decodeObject(forKey: "avatar") as? String ?? ""
        constellation = coder.decodeObject(forKey: "constellation") as? String ?? ""
        id = coder.decodeObject(forKey: "id") as? String ?? ""
        isVip = coder.decodeObject(forKey: "is_vip") as? Bool ?? false
        messageNum = coder.decodeObject(forKey: "message_count") as? Int ?? 0
        mobile = coder.decodeObject(forKey: "mobile") as? String ?? ""
        nickname = coder.decodeObject(forKey: "nickname") as? String ?? ""
        qqOpenid = coder.decodeObject(forKey: "qq_openid") as? Bool ?? false
        sex = coder.decodeObject(forKey: "sex") as? Int ?? 0
        vipTime = coder.decodeObject(forKey: "vip_time") as? Int ?? 0
        wxOpenid = coder.decodeObject(forKey: "wx_openid") as? Bool ?? false
        wxUnionid = coder.decodeObject(forKey: "wx_unionid") as? Bool ?? false
        token = coder.decodeObject(forKey: "token") as? String ?? ""
        guardNum = coder.decodeObject(forKey: "guard_num") as? Int ?? 0
        regDays = coder.decodeObject(forKey: "reg_days") as? Int ?? 0
    }
    
    
}


