//
//  PayCurrentView.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/4.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class PayCurrentView: UIView {

    lazy var goBtn: UIButton = {
        let b = UIButton()
        b.backgroundColor = .init(hex: "#27CBB3")
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#FFFFFF"),
        ]
        b.setAttributedTitle(.init(string: "继续", attributes: att), for: .normal)
        b.cornerRadius = 6.uiX
        return b
    }()
    
    lazy var retryBtn: UIButton = {
        let b = UIButton()
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 14.uiX),
            .foregroundColor: UIColor(hex: "#7F7F99"),
        ]
        b.setAttributedTitle(.init(string: "恢复购买", attributes: att), for: .normal)
        return b
    }()
    
    lazy var changeBtn: UIButton = {
        let b = UIButton()
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 14.uiX),
            .foregroundColor: UIColor(hex: "#7F7F99"),
        ]
        b.setAttributedTitle(.init(string: "显示更多方案", attributes: att), for: .normal)
        return b
    }()
    
    lazy var lbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.text = ""
        lbl.textColor = .init(hex: "#393946")
        lbl.font = .init(style: .regular, size: 14.uiX)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(lbl)
        addSubview(goBtn)
        addSubview(retryBtn)
        addSubview(changeBtn)
        
        goBtn.snp.makeConstraints { make in
            make.width.equalTo(320.uiX)
            make.height.equalTo(44.uiX)
            make.center.equalToSuperview()
        }
        
        lbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(goBtn.snp.top).offset(-14.uiX)
            make.width.equalTo(300.uiX)
        }
        
        retryBtn.snp.makeConstraints { make in
            make.left.equalTo(goBtn.snp.left)
            make.top.equalTo(goBtn.snp.bottom).offset(14.uiX)
        }
        
        changeBtn.snp.makeConstraints { make in
            make.right.equalTo(goBtn.snp.right)
            make.top.equalTo(goBtn.snp.bottom).offset(14.uiX)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
