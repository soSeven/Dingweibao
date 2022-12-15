//
//  CircleAvatarCell.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class CircleAvatarCell: CollectionViewCell {
    
    let imgView = UIImageView()
    let checkView = UIImageView(image: UIImage.create("Headportrait_selected"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imgView)
        imgView.cornerRadius = 30.uiX
        imgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(60.uiX)
            make.height.equalTo(60.uiX)
        }
        
        contentView.addSubview(checkView)
        checkView.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.size.equalTo(checkView.image!.snpSize)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to model: CircleAvatarModel) {
        imgView.kf.setImage(with: URL(string: model.avatar))
    }
    
}
