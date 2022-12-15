//
//  GuidePageView.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class GuidePageView: UIView {
    
    let imgView = UIImageView()
    let pushImgView = UIImageView(image: UIImage.create("guidepage_push"))
    lazy var btn: UIButton = {
        let b = UIButton()
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .bold, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#016051"),
        ]
        b.cornerRadius = 30.uiX
        b.backgroundColor = .init(hex: "#27CBB3")
        b.setAttributedTitle(.init(string: "下一步", attributes: att), for: .normal)
        return b
    }()
    lazy var lbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#ffffff")
        lbl.font = .init(style: .bold, size: 30.uiX)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .random
        clipsToBounds = true
        
        imgView.contentMode = .scaleAspectFill
        addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(296.uiX)
            make.height.equalTo(60.uiX)
            make.bottom.equalToSuperview().offset(-(UIDevice.safeAreaBottom + 51.uiX))
        }
        
        let img = UIImageView(image: UIImage.create("guidepage_next"))
        btn.addSubview(img)
        img.snp.makeConstraints { make in
            make.size.equalTo(img.image!.snpSize)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-24.uiX)
        }
        
        addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(btn.snp.top).offset(-40.uiX)
        }
        
        addSubview(pushImgView)
        pushImgView.isHidden = true
        let w: CGFloat = UIDevice.screenWidth - 40.uiX
        let h: CGFloat = pushImgView.image!.snpScale * w
        pushImgView.transform = .init(translationX: 0, y: -(UIDevice.statusBarHeight + 24.uiX + h))
        pushImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.uiX)
            make.right.equalToSuperview().offset(-20.uiX)
            make.top.equalToSuperview().offset(UIDevice.statusBarHeight + 24.uiX)
            make.height.equalTo(pushImgView.snp.width).multipliedBy(pushImgView.image!.snpScale)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isShowPushImgView = false
    
    func showPushImgView() {
        
        if isShowPushImgView {
            return
        }
        isShowPushImgView = true
        pushImgView.isHidden = false
        UIView.animate(withDuration: 0.25) {
            self.pushImgView.transform = .identity
        }
    }
    
    func hidePushImgView() {
        
        if !isShowPushImgView {
            return
        }
        isShowPushImgView = false
        UIView.animate(withDuration: 0.25) {
            let w: CGFloat = UIDevice.screenWidth - 40.uiX
            let h: CGFloat = self.pushImgView.image!.snpScale * w
            self.pushImgView.transform = .init(translationX: 0, y: -(UIDevice.statusBarHeight + 24.uiX + h))
        }
    }
    
}
