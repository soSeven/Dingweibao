//
//  LaunchProtocolView.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/16.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import YYText

class LaunchProtocolView: UIView {

    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#222222")
        lbl.font = .init(style: .regular, size: 16.uiX)
        lbl.text = "用户隐私保护指引"
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var leftBtn: UIButton = {
        let b = UIButton()
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#999999"),
        ]
        b.setAttributedTitle(.init(string: "不同意并退出", attributes: att), for: .normal)
        b.borderColor = .init(hex: "#EDEDED")
        b.borderWidth = 0.5
        return b
    }()
    
    lazy var rightBtn: UIButton = {
        let b = UIButton()
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#FF4040"),
        ]
        b.setAttributedTitle(.init(string: "确定", attributes: att), for: .normal)
        b.borderColor = .init(hex: "#EDEDED")
        b.borderWidth = 0.5
        return b
    }()
    
    var protocolEvent: ((Int)->(Void))?
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        backgroundColor = .white
        
        addSubview(titleLbl)
        addSubview(leftBtn)
        addSubview(rightBtn)
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22.uiX)
            make.left.equalToSuperview().offset(20.uiX)
            make.right.equalToSuperview().offset(-20.uiX)
        }
        
        let text = NSMutableAttributedString(string: "定位宝非常重视您的个人信息和隐私保护。为了更好地保障您的个人权益，在您使用我们的产品前，请认真阅读")
        text.yy_font = .init(style: .regular, size: 12.uiX)
        text.yy_color = .init(hex: "#666666")
        
        let a = NSMutableAttributedString(string: "《用户服务协议》")
        a.yy_font = .init(style: .regular, size: 12.uiX)
        a.yy_color = .init(hex: "#1AAB97")
        
        let hi = YYTextHighlight()
        hi.tapAction =  {[weak self] containerView, text, range, rect in
            guard let self = self else { return }
            self.protocolEvent?(1)
        };
        a.yy_setTextHighlight(hi, range: a.yy_rangeOfAll())
        
        let b = NSMutableAttributedString(string: "与")
        b.yy_font = .init(style: .regular, size: 12.uiX)
        b.yy_color = .init(hex: "#666666")
        
        let c = NSMutableAttributedString(string: "《隐私协议》")
        c.yy_font = .init(style: .regular, size: 12.uiX)
        c.yy_color = .init(hex: "#1AAB97")
        
        let chi = YYTextHighlight()
        chi.tapAction = {[weak self] containerView, text, range, rect in
            guard let self = self else { return }
            self.protocolEvent?(2)
        };
        c.yy_setTextHighlight(chi, range: c.yy_rangeOfAll())
        
        let d = NSMutableAttributedString(string: "的全部内容，点击同意并接受全部条款后开始使用我们的产品和服务。")
        d.yy_font = .init(style: .regular, size: 12.uiX)
        d.yy_color = .init(hex: "#666666")
        
        text.append(a)
        text.append(b)
        text.append(c)
        text.append(d)
        
        text.yy_lineSpacing = 4.uiX;
        let protocolLbl = YYLabel()
        protocolLbl.numberOfLines = 0
        protocolLbl.preferredMaxLayoutWidth = 250.uiX
        addSubview(protocolLbl)
        protocolLbl.attributedText = text;
        protocolLbl.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(10.uiX)
            make.left.equalToSuperview().offset(20.uiX)
            make.right.equalToSuperview().offset(-20.uiX)
        }
        
        let v1 = getAuthView(img: UIImage.create("pop_icon01"), title: "存储空间、设备信息、位置信息", msg: "必要权限，用于产品主要功能，与家人分享位置信息")
        let v2 = getAuthView(img: UIImage.create("pop_icon02"), title: "摄像头和相册访问权限", msg: "功能权限，用于修改用户资料等")
        addSubview(v1)
        addSubview(v2)
        v1.snp.makeConstraints { make in
            make.top.equalTo(protocolLbl.snp.bottom).offset(17.uiX)
            make.left.equalToSuperview().offset(20.uiX)
            make.right.equalToSuperview().offset(-20.uiX)
        }
        
        v2.snp.makeConstraints { make in
            make.top.equalTo(v1.snp.bottom).offset(14.uiX)
            make.left.equalToSuperview().offset(20.uiX)
            make.right.equalToSuperview().offset(-20.uiX)
        }
        
        let text2 = NSMutableAttributedString(string: "功能权限不会默认开启，只有经过明示授权后才会在实现功能和服务时使用，您均可以拒绝且不影响您继续使用其他功能和服务。")
        text2.yy_font = .init(style: .regular, size: 12.uiX)
        text2.yy_color = .init(hex: "#666666")
        text2.yy_lineSpacing = 4.uiX;
        
        let protocolLbl2 = YYLabel()
        protocolLbl2.attributedText = text2
        protocolLbl2.numberOfLines = 0
        protocolLbl2.preferredMaxLayoutWidth = 250.uiX
        addSubview(protocolLbl2)
        
        protocolLbl2.snp.makeConstraints { make in
            make.top.equalTo(v2.snp.bottom).offset(17.uiX)
            make.left.equalToSuperview().offset(20.uiX)
            make.right.equalToSuperview().offset(-20.uiX)
        }
        
        leftBtn.snp.makeConstraints { make in
            make.top.equalTo(protocolLbl2.snp.bottom).offset(14.uiX)
            make.left.bottom.equalToSuperview()
            make.height.equalTo(50.uiX)
        }
        
        rightBtn.snp.makeConstraints { make in
            make.top.equalTo(leftBtn.snp.top)
            make.bottom.equalTo(leftBtn.snp.bottom)
            make.right.equalToSuperview()
            make.left.equalTo(leftBtn.snp.right)
            make.width.equalTo(leftBtn.snp.width)
        }
        
        cornerRadius = 8.uiX
    }
    
    func getAuthView(img: UIImage, title: String, msg: String) -> UIView {
        let imgView = UIImageView(image: img)
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#222222")
        lbl.font = .init(style: .regular, size: 14.uiX)
        lbl.text = title
        
        let lbl1 = UILabel()
        lbl1.textColor = .init(hex: "#666666")
        lbl1.font = .init(style: .regular, size: 12.uiX)
        lbl1.numberOfLines = 2
        lbl1.text = msg
        
        let view = UIView()
        view.addSubview(imgView)
        view.addSubview(lbl)
        view.addSubview(lbl1)
        
        lbl.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.left.equalToSuperview().offset(25.uiX)
        }
        
        lbl1.snp.makeConstraints { make in
            make.top.equalTo(lbl.snp.bottom).offset(5.uiX)
            make.bottom.right.equalToSuperview()
            make.left.equalToSuperview().offset(25.uiX)
        }
        
        imgView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalTo(lbl)
        }
        
        return view
    }
}
