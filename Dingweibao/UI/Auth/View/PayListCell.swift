//
//  PayListCell.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/4.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class PayListCell: CollectionViewCell {
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "季度会员"
        lbl.textAlignment = .center
        lbl.textColor = .init(hex: "#222222")
        lbl.font = .init(style: .medium, size: 15.uiX)
        return lbl
    }()
    
    lazy var priceLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "￥38.00"
        lbl.textAlignment = .center
        lbl.textColor = .init(hex: "#B38C59")
        lbl.font = UIFont(name: "Bahnschrift", size: 26.uiX)
        return lbl
    }()
    
    lazy var msgLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "38元/月"
        lbl.textAlignment = .center
        lbl.textColor = .init(hex: "#B3B3B3")
        lbl.font = .init(style: .regular, size: 12.uiX)
        return lbl
    }()
    
    lazy var bgView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.cornerRadius = 5.uiX
        return v
    }()
    
    lazy var markImgView: UIImageView = {
        let v = UIImageView(image: UIImage.create("pay_label_recommended"))
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(130.uiX)
        }
        
        bgView.addSubview(titleLbl)
        bgView.addSubview(priceLbl)
        bgView.addSubview(msgLbl)
        
        priceLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(10.uiX)
            make.right.equalToSuperview().offset(-10.uiX)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10.uiX)
            make.right.equalToSuperview().offset(-10.uiX)
            make.bottom.equalTo(priceLbl.snp.top).offset(-5.uiX)
        }
        
        msgLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10.uiX)
            make.right.equalToSuperview().offset(-10.uiX)
            make.top.equalTo(priceLbl.snp.bottom).offset(5.uiX)
        }
        
        addSubview(markImgView)
        markImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(-4.uiX)
            make.centerY.equalTo(bgView.snp.top).offset(4.uiX)
            make.size.equalTo(markImgView.image!.snpSize)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to model: PayProductModel) {
        titleLbl.text = model.name
        priceLbl.text = model.price
        msgLbl.text = model.description
        markImgView.isHidden = !model.isRecommend
    }
    
}
