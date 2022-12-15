//
//  CircleAvatarHeaderView.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import Reusable

class CircleAvatarHeaderView: UICollectionReusableView, Reusable {
    
    lazy var lbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#222222")
        lbl.font = .init(style: .regular, size: 15.uiX)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15.uiX)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
