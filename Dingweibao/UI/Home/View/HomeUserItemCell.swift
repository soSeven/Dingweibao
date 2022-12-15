//
//  HomeUserItemCell.swift
//  Dingweibao
//
//  Created by LiQi on 2020/5/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeUserItemCell: CollectionViewCell {
    
    let lbl = UILabel()
    let imgView = UIImageView(image: UIImage.create("icon_all"))
    lazy var powerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 6.uiX
        v.shadowRadius = 2.uiX
        v.shadowOffset = .init(width: Float(1.5).uiX, height: 0)
        v.shadowColor = .init(hex: "#424242")
        v.shadowOpacity = 0.15
        return v
    }()
    let powerImgView = UIImageView(image: UIImage.create("battery1"))
    lazy var powerlbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "100%"
        lbl.textColor = .init(hex: "#9E9E9E")
        lbl.font = .init(style: .regular, size: 8.uiX)
        return lbl
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        lbl.textColor = .init(hex: "#666666")
        lbl.textAlignment = .center
        lbl.font = .init(style: .regular, size: 11.uiX)
        lbl.text = "我"
        
        addSubview(lbl)
        addSubview(imgView)
        addSubview(powerView)
        
        imgView.cornerRadius = 22.uiX
        imgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 44.uiX, height: 44.uiX))
        }
        
        lbl.snp.makeConstraints { make in
            make.top.equalTo(imgView.snp.bottom).offset(7.uiX)
            make.left.right.equalToSuperview()
        }
        
        powerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(imgView.snp.bottom)
            make.height.equalTo(12.uiX)
            make.width.equalTo(40.uiX)
        }
        
        powerImgView.snp.makeConstraints { make in
            make.size.equalTo(powerImgView.image!.size)
        }
        
        let stack = UIStackView(arrangedSubviews: [powerImgView, powerlbl], axis: .horizontal, spacing: 2.uiX, alignment: .center, distribution: .equalSpacing)
        powerView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to model: HomeUserItemCellViewModel) {
        
        cellDisposeBag = DisposeBag()
        
        switch model.type {
        case .all:
            lbl.text = "全部"
            imgView.image = UIImage.create("icon_all")
            powerView.isHidden = true
            imgView.borderColor = .clear
            imgView.borderWidth = 0
            model.isSelected.distinctUntilChanged().bind { [weak self] isSelected in
                guard let self = self else { return }
                if isSelected {
                    self.powerView.isHidden = true
                    self.imgView.borderColor = .init(hex: "#27CBB3")
                    self.imgView.borderWidth = Float(1.5).uiX
                } else {
                    self.powerView.isHidden = true
                    self.imgView.borderColor = .clear
                    self.imgView.borderWidth = 0
                }
            }.disposed(by: cellDisposeBag)
        case .add:
            lbl.text = "添加"
            imgView.image = UIImage.create("icon_add")
            powerView.isHidden = true
            imgView.borderColor = .clear
            imgView.borderWidth = 0
        case .normal:
            model.nickname.bind(to: lbl.rx.text).disposed(by: cellDisposeBag)
            model.avatar.bind {[weak self] avatar in
                guard let self = self else { return }
                self.imgView.kf.setImage(with: URL(string: avatar), placeholder: UIImage.create("icon_all"))
            }.disposed(by: cellDisposeBag)
            model.lastElectric.bind {[weak self] power in
                guard let self = self else { return }
                self.powerlbl.text = String(format: "%d%%", power)
                self.powerlbl.textColor = .init(hex: "#9E9E9E")
                switch power {
                case ..<20:
                    self.powerImgView.image = UIImage.create("battery1")
                    self.powerlbl.textColor = .init(hex: "#FF6E52")
                case 20..<40:
                    self.powerImgView.image = UIImage.create("battery2")
                case 40..<60:
                    self.powerImgView.image = UIImage.create("battery3")
                case 60..<80:
                    self.powerImgView.image = UIImage.create("battery4")
                default:
                    self.powerImgView.image = UIImage.create("battery5")
                }
            }.disposed(by: cellDisposeBag)
            model.isSelected.distinctUntilChanged().bind { [weak self] isSelected in
                guard let self = self else { return }
                if isSelected {
                    self.powerView.isHidden = false
                    self.imgView.borderColor = .init(hex: "#27CBB3")
                    self.imgView.borderWidth = Float(1.5).uiX
                } else {
                    self.powerView.isHidden = true
                    self.imgView.borderColor = .clear
                    self.imgView.borderWidth = 0
                }
            }.disposed(by: cellDisposeBag)
        }
        
    }
    
}
