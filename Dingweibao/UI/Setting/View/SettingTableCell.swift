//
//  SettingTableCell.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/8.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SettingTableCell: TableViewCell {
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#393946")
        lbl.font = .init(style: .regular, size: 16.uiX)
        return lbl
    }()
    
    let arrowImgView = UIImageView(image: UIImage(named: "icon_more"))
    let lineView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        selectionStyle = .none
        
        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(arrowImgView)
        arrowImgView.snp.makeConstraints { make in
            make.size.equalTo(arrowImgView.snp.size)
            make.right.equalToSuperview().offset(-15.uiX)
            make.centerY.equalToSuperview()
        }
        
        lineView.backgroundColor = .init(hex: "#EDEDED")
        contentView.addSubview(lineView)
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
    
    func bind(to viewModel: SettingType) {
        
        switch viewModel {
        case let .about(title):
            titleLbl.text = title
        case let .userProtocol(title):
            titleLbl.text = title
        case let .userPrivacy(title):
            titleLbl.text = title
        }
        
    }
    
}
