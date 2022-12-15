//
//  PayModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/4.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftyJSON

class PayProductModel: Mapable {
    
    var name : String!
    var price : String!
    var description : String!
    var id : String!
    var isRecommend : Bool!
    var recommendDes : String!
    
    required init(json: JSON) {
        
        name = json["name"].stringValue
        price = json["price"].stringValue
        description = json["description"].stringValue
        id = json["apple_product_id"].stringValue
        isRecommend = json["is_recommend"].boolValue
        recommendDes = json["recommend_des"].stringValue

       
    }
    
}
