//
//  UserPointAnnotation.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/11.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class UserPointAnnotation: MAPointAnnotation {
    
    let user: HomeUserItemCellViewModel
    
    init(user: HomeUserItemCellViewModel) {
        self.user = user
        super.init()
    }

}
