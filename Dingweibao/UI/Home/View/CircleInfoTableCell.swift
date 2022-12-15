//
//  CircleInfoTableCell.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/1.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CircleInfoUserTableCell: TableViewCell {

    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#393946")
        lbl.font = .init(style: .regular, size: 16.uiX)
        return lbl
    }()
    let arrowImgView = UIImageView(image: UIImage(named: "icon_more"))
    let imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .random
        imgView.cornerRadius = 22.uiX
        return imgView
    }()
    let msgLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#CCCCCC")
        lbl.text = "群主"
        lbl.font = .init(style: .regular, size: 13.uiX)
        return lbl
    }()
    
    let lineView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        selectionStyle = .none
        
        let bgView = UIView()
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(66.uiX).priority(.high)
        }
        
        bgView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.width.equalTo(44.uiX)
            make.height.equalTo(44.uiX)
            make.centerY.equalToSuperview()
        }
        
        bgView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalTo(imgView.snp.right).offset(10.uiX)
            make.centerY.equalToSuperview()
        }
        
        bgView.addSubview(arrowImgView)
        arrowImgView.snp.makeConstraints { make in
            make.size.equalTo(arrowImgView.image!.snpSize)
            make.right.equalToSuperview().offset(-15.uiX)
            make.centerY.equalToSuperview()
        }
        
        bgView.addSubview(msgLbl)
        msgLbl.snp.makeConstraints { make in
            make.left.equalTo(titleLbl.snp.right).offset(5.uiX)
            make.centerY.equalToSuperview()
        }
        
        lineView.backgroundColor = .init(hex: "#EDEDED")
        bgView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(66.uiX)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bind
    
    func bind(to viewModel: CircleInfoType) {
        
        switch viewModel {
        case let .user(user):
            if user.isMe {
                titleLbl.text = "我"
            } else {
                titleLbl.text = user.nickname
            }
            if user.isCreater {
                msgLbl.isHidden = false
            } else {
                msgLbl.isHidden = true
            }
            imgView.kf.setImage(with: URL(string: user.avatar), placeholder: UIImage.create("my_pic_headportrait"))
            
        default:
            break
        }


    }

}

class CircleInfoAvatorTableCell: TableViewCell {

    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#393946")
        lbl.font = .init(style: .regular, size: 16.uiX)
        return lbl
    }()
    let arrowImgView = UIImageView(image: UIImage(named: "icon_more"))
    let imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .random
        imgView.cornerRadius = 22.uiX
        return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        selectionStyle = .none
        
        let bgView = UIView()
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(65.uiX).priority(.high)
        }
        
        bgView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.centerY.equalToSuperview()
        }
        
        let stack = UIStackView(arrangedSubviews: [imgView, arrowImgView], axis: .horizontal, spacing: 7.uiX, alignment: .center, distribution: .equalSpacing)
        bgView.addSubview(stack)
        
        arrowImgView.snp.makeConstraints { make in
            make.size.equalTo(arrowImgView.image!.snpSize)
        }
        
        imgView.snp.makeConstraints { make in
            make.width.equalTo(44.uiX)
            make.height.equalTo(44.uiX)
        }
        
        stack.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15.uiX)
            make.centerY.equalToSuperview()
        }
        
        let lineView = UIView()
        lineView.backgroundColor = .init(hex: "#EDEDED")
        bgView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(15.uiX)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bind
    
    func bind(to viewModel: CircleInfoType) {
        
        switch viewModel {
        case let .avator(title, info, isCreated):
            titleLbl.text = title
            imgView.kf.setImage(with: URL(string: info.avatar), placeholder: UIImage.create("my_pic_headportrait"))
            arrowImgView.isHidden = !isCreated
        default:
            break
        }
    }
    
    func bind(to viewModel: OtherUserType) {
        
        switch viewModel {
        case let .avator(title, info):
            titleLbl.text = title
            imgView.kf.setImage(with: URL(string: info.avatar), placeholder: UIImage.create("my_pic_headportrait"))
            arrowImgView.isHidden = true
        default:
            break
        }
    }
    
    func bind(to viewModel: MyCellType) {
        
        switch viewModel {
        case let .avator(title, info):
            titleLbl.text = title
            imgView.kf.setImage(with: URL(string: info.avatar), placeholder: UIImage.create("my_pic_headportrait"))
        default:
            break
        }
    }
    
}

class CircleInfoTextTableCell: TableViewCell {

    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#393946")
        lbl.font = .init(style: .regular, size: 16.uiX)
        return lbl
    }()
    let arrowImgView = UIImageView(image: UIImage(named: "icon_more"))
    let msgLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#7C7C8E")
        lbl.font = .init(style: .regular, size: 16.uiX)
        return lbl
    }()
    let lineView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        selectionStyle = .none
        
        let bgView = UIView()
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(55.uiX).priority(.high)
        }
        
        bgView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.centerY.equalToSuperview()
        }
        
        let stack = UIStackView(arrangedSubviews: [msgLbl, arrowImgView], axis: .horizontal, spacing: 7.uiX, alignment: .center, distribution: .equalSpacing)
        bgView.addSubview(stack)
        
        arrowImgView.snp.makeConstraints { make in
            make.size.equalTo(arrowImgView.image!.snpSize)
//            make.right.equalToSuperview().offset(-15.uiX)
//            make.centerY.equalToSuperview()
        }
        
        stack.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15.uiX)
            make.centerY.equalToSuperview()
        }
        
        lineView.backgroundColor = .init(hex: "#EDEDED")
        bgView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(15.uiX)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bind
    
    func bind(to viewModel: CircleInfoType) {
        
        switch viewModel {
        case let .groupName(title, info, isCreated):
            titleLbl.text = title
            arrowImgView.isHidden = !isCreated
            msgLbl.text = info.name
        case let .groupAuth(title, info, isCreated):
            titleLbl.text = title
            arrowImgView.isHidden = !isCreated
            switch info.joinAuth {
            case 1:
                msgLbl.text = "仅群主验证通过"
            case 2:
                msgLbl.text = "无需验证"
            case 3:
                msgLbl.text = "拒绝所有人"
            default:
                msgLbl.text = "任意成员验证通过"
            }
            
        case let .groupNumber(title, info, _):
            titleLbl.text = title
            arrowImgView.isHidden = true
            msgLbl.text = String(info.id)
        default:
            break
        }
    }
    
    func bind(to viewModel: OtherUserType) {
        
        switch viewModel {
        case let .name(title, info):
            titleLbl.text = title
            arrowImgView.isHidden = true
            msgLbl.text = info.nickname
        case let .otherName(title, info):
            titleLbl.text = title
            arrowImgView.isHidden = false
            msgLbl.text = info.remarks
        case let .phone(title, info):
            titleLbl.text = title
            arrowImgView.isHidden = true
            if let mobile = info.mobile, !mobile.isEmpty {
                msgLbl.text = info.mobile
            } else {
                msgLbl.text = "未绑定"
            }
            
        default:
            break
        }
    }
    
    func bind(to viewModel: MyCellType) {
        
        switch viewModel {
        case let .name(title, info):
            titleLbl.text = title
            msgLbl.text = info.nickname
            arrowImgView.isHidden = false
        case let .phone(title, info):
            titleLbl.text = title
            if let m = info.mobile, !m.isEmpty {
                arrowImgView.isHidden = true
                msgLbl.text = info.mobile
            } else {
                arrowImgView.isHidden = false
                msgLbl.text = "未绑定"
            }
            
        default:
            break
        }
    }

}

class CircleInfoLocationTableCell: TableViewCell {

    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#393946")
        lbl.font = .init(style: .regular, size: 16.uiX)
        return lbl
    }()
    let switchView: UISwitch = {
        let s = UISwitch()
        s.onTintColor = .init(hex: "#27CBB3")
        return s
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        selectionStyle = .none
        
        let bgView = UIView()
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(55.uiX).priority(.high)
        }
        
        bgView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.centerY.equalToSuperview()
        }
        
        bgView.addSubview(switchView)
        switchView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15.uiX)
            make.centerY.equalToSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bind
    
    func bind(to viewModel: OtherUserType) {
        cellDisposeBag = DisposeBag()
        switch viewModel {
        case let .location(title, info):
            titleLbl.text = title
            info.isHide.bind(to: switchView.rx.isOn).disposed(by: cellDisposeBag)
            switchView.rx.isOn.changed.bind(to: info.hideEvent).disposed(by: cellDisposeBag)
        default:
            break
        }
    }

}


class CircleAuthTableCell: TableViewCell {

    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#393946")
        lbl.font = .init(style: .regular, size: 16.uiX)
        return lbl
    }()
    let arrowImgView = UIImageView(image: UIImage(named: "icon_hook"))
    let lineView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        selectionStyle = .none
        
        let bgView = UIView()
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(55.uiX).priority(.high)
        }
        
        bgView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.centerY.equalToSuperview()
        }
        
        bgView.addSubview(arrowImgView)
        arrowImgView.snp.makeConstraints { make in
            make.size.equalTo(arrowImgView.image!.snpSize)
            make.right.equalToSuperview().offset(-15.uiX)
            make.centerY.equalToSuperview()
        }
        
        lineView.backgroundColor = .init(hex: "#EDEDED")
        bgView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(15.uiX)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bind

    func bind(to viewModel: CircleAuthType, needCheck: Bool) {
        
        titleLbl.text = viewModel.text
        if needCheck {
            titleLbl.textColor = .init(hex: "#1AAB97")
            arrowImgView.isHidden = false
        } else {
            titleLbl.textColor = .init(hex: "#393946")
            arrowImgView.isHidden = true
        }
    }

}
