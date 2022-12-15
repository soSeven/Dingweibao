//
//  AuthToSettingAlert.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/3.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import SwiftEntryKit

class AuthToSettingAlert: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        let bg1 = UIView()
        let t1 = getTitleView(text: "耗电说明")
        let v1 = getMsgView(text: "全天耗电不到2%")
        bg1.addSubview(t1)
        bg1.addSubview(v1)
        t1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        v1.snp.makeConstraints { make in
            make.top.equalTo(t1.snp.bottom).offset(10.uiX)
            make.left.equalToSuperview().offset(30.uiX)
            make.bottom.equalToSuperview()
        }
        
        let bg2 = UIView()
        let t2 = getTitleView(text: "隐私保护")
        let v2 = getMsgView(text: "我们将依照法律保护您的隐私")
        let v3 = getMsgView(text: "只有家人才能看到您的位置")
        let v4 = getMsgView(text: "您可以随时在APP内设置隐藏位置")
        let stack = UIStackView(arrangedSubviews: [v2, v3, v4], axis: .vertical, spacing: 8.uiX, alignment: .leading, distribution: .equalSpacing)
        bg2.addSubview(t2)
        bg2.addSubview(stack)
        t2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        stack.snp.makeConstraints { make in
            make.top.equalTo(t2.snp.bottom).offset(10.uiX)
            make.left.equalToSuperview().offset(30.uiX)
            make.bottom.equalToSuperview()
        }
        
        addSubview(bg1)
        addSubview(bg2)
        bg1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20.uiX)
            make.left.right.equalToSuperview()
        }
        
        bg2.snp.makeConstraints { make in
            make.top.equalTo(bg1.snp.bottom).offset(20.uiX)
            make.left.right.equalToSuperview()
        }
        
        let btn = UIButton()
        btn.borderWidth = 0.5
        btn.borderColor = .init(hex: "#EDEDED")
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#002522"),
        ]
        btn.setAttributedTitle(.init(string: "去设置", attributes: att), for: .normal)
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.top.equalTo(bg2.snp.bottom).offset(26.uiX)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50.uiX)
        }
        btn.rx.tap.subscribe(onNext: { _ in
            if let URL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(URL)
            }
            SwiftEntryKit.dismiss()
        }).disposed(by: rx.disposeBag)
        
        snp.makeConstraints { make in
            make.width.equalTo(290.uiX)
        }
        
        cornerRadius = 8.uiX
    }
    
    func getTitleView(text: String) -> UIView {
        let lbl1 = UILabel()
        lbl1.text = text
        lbl1.textColor = .init(hex: "#222222")
        lbl1.font = .init(style: .medium, size: 16.uiX)
        return lbl1
    }
    
    func getMsgView(text: String) -> UIView {
        
        let dotView = UIView()
        dotView.backgroundColor = .init(hex: "#9F9FBD")
        dotView.cornerRadius = 5.uiX / 2.0
        dotView.snp.makeConstraints { make in
            make.width.equalTo(5.uiX)
            make.height.equalTo(5.uiX)
        }
        
        let lbl1 = UILabel()
        lbl1.text = text
        lbl1.textColor = .init(hex: "#666666")
        lbl1.font = .init(style: .regular, size: 14.uiX)
        
        let stack = UIStackView(arrangedSubviews: [dotView, lbl1], axis: .horizontal, spacing: 5.uiX, alignment: .center, distribution: .equalSpacing)
        
        return stack
    }
    
    
    // MARK: - Show
    
    func show() {
        
        var attributes = EKAttributes.centerFloat
        
        attributes.screenBackground = .color(color: .init(.init(white: 0, alpha: 0.6)))
        attributes.entryBackground = .color(color: .init(.init(hex: "#F7F7F7")))
        attributes.screenInteraction = .absorbTouches
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .disabled
        attributes.displayDuration = .infinity
        attributes.roundCorners = .all(radius: 8.uiX)
        
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        
        SwiftEntryKit.display(entry: self, using: attributes)
    }
    
}
