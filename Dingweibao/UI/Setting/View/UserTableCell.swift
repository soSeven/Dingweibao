//
//  UserTableCell.swift
//  Dingweibao
//
//  Created by LiQi on 2020/5/28.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UserTableCell: TableViewCell {
    
    let imgView = UIImageView()
    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#393946")
        lbl.font = .init(style: .regular, size: 16.uiX)
        return lbl
    }()
    
    let dotView: UIView = {
        let v = UIView()
        v.backgroundColor = .init(hex: "#F73030")
        v.layer.cornerRadius = Float(3.5).uiX
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 24.uiX, height: 24.uiX))
            make.left.equalToSuperview().offset(30.uiX)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalTo(self.imgView.snp.right).offset(Float(12.5).uiX)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(dotView)
        dotView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 7.uiX, height: 7.uiX))
            make.centerY.equalTo(imgView.snp.top)
            make.centerX.equalTo(imgView.snp.right)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bind
    
    func bind(to viewModel: UserCellViewModel) {
        
        cellDisposeBag = DisposeBag()
        
        imgView.image = UIImage(named: viewModel.imgName)
        titleLbl.text = viewModel.title
        viewModel.dot.map{ !$0 }.bind(to: dotView.rx.isHidden).disposed(by: cellDisposeBag)
        
    }
    
}
