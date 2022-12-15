//
//  AuthLoginViewController.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/3.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import YYText
import AuthenticationServices
import RxSwift
import RxCocoa

protocol AuthLoginViewControllerDelegate: AnyObject {
    
    func authLoginShowLocation(controller: AuthLoginViewController)
    func authLoginShowProtocol(controller: AuthLoginViewController, type: Int)
    
}

class AuthLoginViewController: ViewController {
    
    var viewModel: AuthLoginViewModel!
    
    weak var delegate: AuthLoginViewControllerDelegate?
    
    let appleLogin = PublishRelay<Void>()
    let weChat = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        hbd_barHidden = true
        view.backgroundColor = .white
        setupUI()
        setupBinding()
    }
    
    // MARK: - Binding
    
    func setupBinding() {
        
        viewModel.window = UIApplication.shared.keyWindow
        
        let input = AuthLoginViewModel.Input(weChat: weChat.rx.tap.asObservable(),
                                             apple: appleLogin.asObservable())
        let output = viewModel.transform(input: input)
        
        viewModel.loading.asObservable().bind(to: view.rx.mbHudLoaingForce).disposed(by: rx.disposeBag)
        let completion = {[weak self] in
            guard let self = self else { return }
            self.delegate?.authLoginShowLocation(controller: self)
        }
        output.loginSuccess.bind(to: view.rx.mbHudText(completion: completion)).disposed(by: rx.disposeBag)
        viewModel.parsedError.asObserver().bind(to: view.rx.toastError).disposed(by: rx.disposeBag)

    }
    
    // MARK: - UI
    
    func setupUI() {
        
        let logoImgView = UIImageView(image: UIImage.create("login_logo"))
        view.addSubview(logoImgView)
        logoImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(UIDevice.statusBarHeight + 83.uiX)
        }
        
        let nameImgView = UIImageView(image: UIImage.create("定位宝"))
        view.addSubview(nameImgView)
        nameImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImgView.snp.bottom).offset(20.uiX)
        }
        
        let l1 = UILabel()
        l1.textColor = .init(hex: "#67677C")
        l1.text = "你安全·我安心"
        l1.font = .init(style: .regular, size: 14.uiX)
        view.addSubview(l1)
        l1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameImgView.snp.bottom).offset(11.uiX)
        }
        
        weChat.backgroundColor = .init(hex: "#27CBB3")
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#FFFFFF"),
        ]
        weChat.setAttributedTitle(.init(string: " 微信登录", attributes: att), for: .normal)
        weChat.setImage(UIImage.create("login_wechat"), for: .normal)
        weChat.cornerRadius = 5.uiX
        view.addSubview(weChat)
        weChat.snp.makeConstraints { make in
            make.height.equalTo(44.uiX)
            make.width.equalTo(295.uiX)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset( -(UIDevice.safeAreaBottom + 156.uiX))
        }
        
        let l2 = UILabel()
        l2.textColor = .init(hex: "#B3B3B3")
        l2.text = "首次登录将自动注册账号"
        l2.font = .init(style: .regular, size: 12.uiX)
        view.addSubview(l2)
        l2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(weChat.snp.top).offset(-14.uiX)
        }
        
        
        
        if #available(iOS 13.0, *) {
            let apple = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .whiteOutline)
            view.addSubview(apple)
            apple.snp.makeConstraints { make in
                make.height.equalTo(44.uiX)
                make.width.equalTo(295.uiX)
                make.top.equalTo(weChat.snp.bottom).offset(15.uiX)
                make.centerX.equalToSuperview()
            }
            apple.cornerRadius = 5.uiX
            apple.rx.controlEvent(.touchUpInside).bind(to: appleLogin).disposed(by: rx.disposeBag)
            
            let protocolView = getProtocolView()
            view.addSubview(protocolView)
            protocolView.snp.makeConstraints { make in
                make.left.equalTo(weChat.snp.left)
                make.top.equalTo(apple.snp.bottom).offset(15.uiX)
                make.right.equalToSuperview()
                make.height.equalTo(40.uiX)
            }
        } else {
            let protocolView = getProtocolView()
            view.addSubview(protocolView)
            protocolView.snp.makeConstraints { make in
                make.left.equalTo(weChat.snp.left)
                make.top.equalTo(weChat.snp.bottom).offset(15.uiX)
                make.right.equalToSuperview()
                make.height.equalTo(40.uiX)
            }
        }
        
    }
    
    private func getProtocolView() -> UIView {
        
        let btn = Button()
        btn.setImage(UIImage.create("login_selected"), for: .selected)
        btn.setImage(UIImage.create("login_uncheck"), for: .normal)
        btn.isSelected = viewModel.isCheck
        btn.snp.makeConstraints { make in
            make.height.equalTo(13.uiX)
            make.width.equalTo(13.uiX)
        }
        
        let text = NSMutableAttributedString(string: "已阅读并同意")
        text.yy_font = .init(style: .regular, size: 13.uiX)
        text.yy_color = .init(hex: "#7F7F99")
        
        let a = NSMutableAttributedString(string: "用户协议")
        a.yy_font = .init(style: .regular, size: 13.uiX)
        a.yy_color = .init(hex: "#27CBB3")
        
        let hi = YYTextHighlight()
        hi.tapAction =  { [weak self] containerView, text, range, rect in
            guard let self = self else { return }
            self.delegate?.authLoginShowProtocol(controller: self, type: 1)
        };
        a.yy_setTextHighlight(hi, range: a.yy_rangeOfAll())
        
        let b = NSMutableAttributedString(string: "和")
        b.yy_font = .init(style: .regular, size: 13.uiX)
        b.yy_color = .init(hex: "#7F7F99")
        
        let c = NSMutableAttributedString(string: "隐私协议")
        c.yy_font = .init(style: .regular, size: 13.uiX)
        c.yy_color = .init(hex: "#27CBB3")
        
        let chi = YYTextHighlight()
        chi.tapAction = {[weak self] containerView, text, range, rect in
            guard let self = self else { return }
            self.delegate?.authLoginShowProtocol(controller: self, type: 2)
        };
        c.yy_setTextHighlight(chi, range: c.yy_rangeOfAll())
        
        text.append(a)
        text.append(b)
        text.append(c)
        
        let protocolLbl = YYLabel()
        protocolLbl.attributedText = text;
        protocolLbl.isUserInteractionEnabled = true
        protocolLbl.snp.makeConstraints { make in
            make.width.equalTo(200.uiX)
        }
        
        let stack = UIView()
        stack.addSubview(btn)
        stack.addSubview(protocolLbl)
        
        btn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        protocolLbl.snp.makeConstraints { make in
            make.left.equalTo(btn.snp.right).offset(5.uiX)
            make.centerY.equalToSuperview()
        }
        
        btn.rx.tap.subscribe(onNext: { [weak self, weak btn] _ in
            guard let self = self else { return }
            self.viewModel.isCheck = !self.viewModel.isCheck
            btn?.isSelected = self.viewModel.isCheck
        }).disposed(by: rx.disposeBag)
        
        return stack
    }
    
}

