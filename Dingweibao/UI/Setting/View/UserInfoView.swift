//
//  UserInfoView.swift
//  Dingweibao
//
//  Created by LiQi on 2020/5/28.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UserInfoView: UIView {
    
    let imgView = UIImageView(image: UIImage(named: "mine_img_user_default"))
    
    let namelbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#222222")
        l.font = .init(style: .regular, size: 19.uiX)
        l.text = ""
        return l
    }()
    
    fileprivate let msglbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#CCCCCC")
        l.font = .init(style: .regular, size: 12.uiX)
        l.text = "累计守护亲友"
        return l
    }()
    
    fileprivate let daylbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#1AAB97")
        l.font = .init(style: .medium, size: 27.uiX)
        l.text = "0"
        return l
    }()
    
    fileprivate let numberlbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#1AAB97")
        l.font = .init(style: .medium, size: 27.uiX)
        l.text = "0"
        return l
    }()
    
    fileprivate let contentView: UIView = {
        let l = UIView()
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentView)
        setupContentView()
        contentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-35.uiX)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContentView() {
        
        contentView.addSubview(imgView)
        contentView.addSubview(namelbl)
        contentView.addSubview(msglbl)
        contentView.addSubview(daylbl)
        contentView.addSubview(numberlbl)
        
        imgView.cornerRadius = 30.uiX
        imgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(25.uiX)
            make.width.equalTo(60.uiX)
            make.height.equalTo(60.uiX)
        }
        
        namelbl.snp.makeConstraints { make in
            make.centerY.equalTo(imgView.snp.centerY)
            make.left.equalTo(imgView.snp.right).offset(18.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
        }
        
        msglbl.snp.makeConstraints { make in
            make.top.equalTo(imgView.snp.bottom).offset(38.uiX)
            make.left.equalToSuperview().offset(25.uiX)
        }
        
        daylbl.snp.makeConstraints { make in
            make.top.equalTo(msglbl.snp.bottom).offset(8.uiX)
            make.left.equalToSuperview().offset(25.uiX)
            make.bottom.equalToSuperview()
        }
        
        let l = UILabel()
        l.textColor = .init(hex: "#353540")
        l.font = .init(style: .regular, size: 14.uiX)
        l.text = "天"
        contentView.addSubview(l)
        
        l.snp.makeConstraints { make in
            make.bottom.equalTo(daylbl.snp.lastBaseline).offset(3.uiX)
            make.left.equalTo(daylbl.snp.right).offset(4.uiX)
        }
        
        numberlbl.snp.makeConstraints { make in
            make.centerY.equalTo(daylbl.snp.centerY)
            make.left.equalTo(l.snp.right).offset(18.uiX)
        }
        
        let l2 = UILabel()
        l2.textColor = .init(hex: "#353540")
        l2.font = .init(style: .regular, size: 14.uiX)
        l2.text = "次"
        contentView.addSubview(l2)
        
        l2.snp.makeConstraints { make in
            make.bottom.equalTo(numberlbl.snp.lastBaseline).offset(3.uiX)
            make.left.equalTo(numberlbl.snp.right).offset(4.uiX)
        }
        
    }
    
}

extension Reactive where Base: UserInfoView {
    
    var model: Binder<UserModel?> {
        return Binder(self.base) { view, model in
            if let model = model {
                view.imgView.kf.setImage(with: URL(string: model.avatar), placeholder: UIImage(named: "my_pic_headportrait"))
                view.namelbl.text = model.nickname
                view.daylbl.text = model.regDays.string
                view.numberlbl.text = model.guardNum.string
            } else {
                view.imgView.image = UIImage(named: "my_pic_headportrait")
                view.namelbl.text = nil
                view.daylbl.text = "0"
                view.numberlbl.text = "0"
            }
        }
    }
}
