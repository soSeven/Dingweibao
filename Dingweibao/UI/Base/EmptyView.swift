//
//  EmptyView.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/28.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import SnapKit

class EmptyView: UIView {
    
    let imgView = UIImageView(image: UIImage(named: "no_content"))
    let label: UILabel = {
        let l = UILabel()
        l.text = "呜呜，没有相关内容"
        l.textColor = .init(hex: "#343434")
        l.font = .init(style: .regular, size: 16.uiX)
        return l
    }()
    let btn: UIButton = {
        let b = UIButton()
        b.contentEdgeInsets = .init(top: 0, left: 30.uiX, bottom: 0, right: 30.uiX)
//        b.backgroundColor = .init(hex: "#343434")
        b.titleLabel?.font = .init(style: .regular, size: Float(15.5).uiX)
        b.setTitleColor(.init(hex: "#343434"), for: .normal)
//        b.cornerRadius = 24.uiX
        return b
    }()
    
    var imgTop: ConstraintMakerEditable!
    var labelTop: ConstraintMakerEditable!
    var btnTop: ConstraintMakerEditable!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(imgView)
        addSubview(label)
        addSubview(btn)
        
        imgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            imgTop = make.top.equalToSuperview().offset(60.uiX)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            labelTop = make.top.equalTo(imgView.snp.bottom).offset(10.uiX)
        }
        
        btn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(48.uiX)
            btnTop = make.top.equalTo(label.snp.bottom).offset(48.uiX)
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
