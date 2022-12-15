//
//  PowerTableCell.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/8.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PowerTableCell: TableViewCell {

    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#393946")
        lbl.font = .init(style: .regular, size: 16.uiX)
        return lbl
    }()
    let imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.cornerRadius = 22.uiX
        return imgView
    }()
    
    let switchView: UISwitch = {
        let s = UISwitch()
        s.onTintColor = .init(hex: "#27CBB3")
        return s
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
        
        bgView.addSubview(switchView)
        switchView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15.uiX)
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
    
    func bind(to viewModel: PowerCellViewModel) {
        
        cellDisposeBag = DisposeBag()
        
        viewModel.avatar.bind {[weak self] avatar in
            guard let self = self else { return }
            self.imgView.kf.setImage(with: URL(string: avatar), placeholder: UIImage.create("my_pic_headportrait"))
        }.disposed(by: rx.disposeBag)
        viewModel.nickname.bind(to: titleLbl.rx.text).disposed(by: cellDisposeBag)
        viewModel.isRemind.bind(to: switchView.rx.isOn).disposed(by: cellDisposeBag)
        switchView.rx.controlEvent(.valueChanged).bind(to: viewModel.remindEvent).disposed(by: cellDisposeBag)
    }

}
