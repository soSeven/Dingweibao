//
//  UserInfoPhoneViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/13.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import SwiftPhoneNumberFormatter
import RxSwift
import RxCocoa

enum UserInfoPhoneType: Int {
    case loginBind
    case bind
    case change
    case check
}

protocol UserInfoPhoneViewControllerDelegate: AnyObject {
    
    func userInfoPhoneClickDecide(controller: UserInfoPhoneViewController, oldCode: String?)
    func userInfoPhoneDimiss(controller: UserInfoPhoneViewController)
}

class UserInfoPhoneViewController: ViewController {
    
    var viewModel: PhoneViewModel!
    weak var delegate: UserInfoPhoneViewControllerDelegate?
    
    private var phoneTextField: PhoneFormattedTextField!
    private var codeTextField: PhoneFormattedTextField!
    private var loginBtn: UIButton!
    private var codeBtn: UIButton!
    
    var type: UserInfoPhoneType = .check
    var isShowSkip = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        hbd_backInteractive = true
        setupUI()
        setupBinding()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        let input = PhoneViewModel.Input(phone: phoneTextField.rx.text.orEmpty.asDriver(),
                                         code: codeTextField.rx.text.orEmpty.asDriver(),
                                         codeTap: codeBtn.rx.tap,
                                         loginTap: loginBtn.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.phone.drive(phoneTextField.rx.text).disposed(by: rx.disposeBag)
        output.code.drive(codeTextField.rx.text).disposed(by: rx.disposeBag)
        
        output.codeEnabled.drive(onNext: { [weak self] codeEnable in
            guard let self = self else { return }
            if codeEnable.enable {
                self.codeBtn.setTitleColor(.init(hex: "#1AAB97"), for: .normal)
                self.codeBtn.isUserInteractionEnabled = true
            } else {
                self.codeBtn.setTitleColor(.init(hex: "#CCCCCC"), for: .normal)
                self.codeBtn.isUserInteractionEnabled = false
            }
            if codeEnable.time == 0 {
                self.codeBtn.setTitle("获取验证码", for: .normal)
            } else {
                self.codeBtn.setTitle("\(codeEnable.time)s", for: .normal)
            }
        }, onCompleted: {
            print("completed code")
        }).disposed(by: rx.disposeBag)
        
        output.signupEnabled.drive(loginBtn.rx.isEnabled).disposed(by: rx.disposeBag)
        
        loginBtn.rx.tap.bind {[weak self]  _ in
            guard let self = self else { return }
            self.phoneTextField.resignFirstResponder()
            self.codeTextField.resignFirstResponder()
        }.disposed(by: rx.disposeBag)
        output.login.bind(onNext: {[weak self] success in
            guard let self = self else { return }
            if !success { return }
            switch self.type {
            case .change, .bind, .loginBind:
                Observable.of("绑定成功").bind(to: self.view.rx.mbHudText(completion: {[weak self] in
                    guard let self = self else { return }
                    self.changeUserInfo()
                })).disposed(by: self.rx.disposeBag)
                break
            case .check:
                self.changeUserInfo()
            }
        }).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.bind(to: view.rx.toastErrorCenter).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: view.rx.mbHudLoaing).disposed(by: rx.disposeBag)
        
    }
    
    private func changeUserInfo() {
        
        self.delegate?.userInfoPhoneClickDecide(controller: self, oldCode: self.codeTextField.text)
        
        guard let user = UserManager.shared.login.value.0 else {
            return
        }
        let mobile = phoneTextField.text?.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        user.mobile = mobile
        UserManager.shared.login.accept((user, .change))
        
    }
    
    
    // MARK: - UI
    
    private func setupUI() {
        
//        let titleLbl = UILabel()
//        titleLbl.font = .init(style: .regular, size: 15.uiX)
//        titleLbl.textColor = .init(hex: "#ffffff")
//        view.addSubview(titleLbl)
//        titleLbl.snp.makeConstraints { make in
//            make.left.equalTo(self.view.snp.left).offset(15.uiX)
//            make.top.equalTo(view.snp.topMargin).offset(30.uiX)
//        }
//        switch type {
//        case .check:
//            titleLbl.text = "为了账号安全，需要验证已绑定的手机"
//            navigationItem.title = "更换手机"
//        case .bind:
//            titleLbl.text = "为了账号安全，请绑定手机号码"
//            navigationItem.title = "绑定手机"
//        case .change:
//            titleLbl.text = "请绑定新的手机号码"
//            navigationItem.title = "更换手机"
//        case .loginBind:
//            hbd_barHidden = true
//            titleLbl.font = .init(style: .regular, size: 20.uiX)
//            titleLbl.text = "为了账号安全，请绑定手机号码"
//            navigationItem.title = "绑定手机"
//
//            let closeBtn = Button()
//            let closeImg = UIImage(named: "login_icon_return")!
//            closeBtn.setImage(closeImg, for: .normal)
//            view.addSubview(closeBtn)
//            closeBtn.snp.makeConstraints { make in
//                make.top.equalTo(self.view.snp_topMargin).offset(23.uiX)
//                make.left.equalTo(self.view.snp.left).offset(15.uiX)
//                make.width.equalTo(11.uiX)
//                make.height.equalTo(closeBtn.snp.width).multipliedBy(closeImg.snpScale)
//            }
//            closeBtn.rx.tap.subscribe(onNext: { [weak self] in
//                guard let self = self else { return }
//                self.delegate?.userInfoPhoneClickDecide(controller: self, oldCode: nil)
//            }).disposed(by: rx.disposeBag)
//
//            let skipBtn = Button()
//            skipBtn.titleLabel?.font = .init(style: .regular, size: 17.uiX)
//            skipBtn.setTitle("跳过", for: .normal)
//            skipBtn.setTitleColor(.init(hex: "#999999"), for: .normal)
//            view.addSubview(skipBtn)
//            skipBtn.snp.makeConstraints { make in
//                make.centerY.equalTo(closeBtn.snp.centerY)
//                make.right.equalTo(self.view.snp.right).offset(-15.uiX)
//            }
//            skipBtn.rx.tap.subscribe(onNext: { [weak self] in
//                guard let self = self else { return }
//                self.delegate?.userInfoPhoneClickDecide(controller: self, oldCode: nil)
//            }).disposed(by: rx.disposeBag)
//
//            titleLbl.snp.remakeConstraints { make in
//                make.left.equalTo(self.view.snp.left).offset(15.uiX)
//                make.top.equalTo(closeBtn.snp.bottom).offset(45.uiX)
//            }
//        }
        
        if isShowSkip {
            let att: [NSAttributedString.Key: Any] = [
                .font : UIFont(style: .regular, size: 15.uiX),
                .foregroundColor: UIColor(hex: "#393946")
            ]
            let cancelBtn = Button()
            cancelBtn.setAttributedTitle(.init(string: "跳过", attributes: att), for: .normal)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelBtn)
            cancelBtn.rx.tap.subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.userInfoPhoneDimiss(controller: self)
            }).disposed(by: rx.disposeBag)
        }
        
        navigationItem.title = "绑定手机"
        
        let (phoneView, field) = getPhoneView()
        phoneTextField = field
        phoneTextField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "### #### ####")
        
        switch type {
        case .check:
            if var mobile = UserManager.shared.login.value.0?.mobile,
            mobile.count == 11 {
                phoneTextField.isEnabled = false
                mobile.insert(Character(" "), at: mobile.index(mobile.startIndex, offsetBy: 3))
                mobile.insert(Character(" "), at: mobile.index(mobile.startIndex, offsetBy: 8))
                phoneTextField.text = mobile
            }
            
        default:
            break
        }
        
        view.addSubview(phoneView)
        phoneView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40.uiX)
            make.left.equalTo(self.view).offset(35.uiX);
            make.right.equalTo(self.view).offset(-35.uiX);
            make.height.equalTo(76.uiX);
        }
        
        let (codeView, codeField, btn) = getCodeView()
        codeBtn = btn
        codeTextField = codeField
        view.addSubview(codeView)
        codeView.snp.makeConstraints { make in
            make.top.equalTo(phoneView.snp.bottom);
            make.left.equalTo(self.view).offset(35.uiX);
            make.right.equalTo(self.view).offset(-35.uiX);
            make.height.equalTo(76.uiX);
        }
        
        loginBtn = UIButton()
        loginBtn.titleLabel?.font = .init(style: .medium, size: 16.uiX)
        loginBtn.titleLabel?.textColor = .init(hex: "#ffffff")
        loginBtn.layer.cornerRadius = 5.uiX
        loginBtn.clipsToBounds = true
        loginBtn.setTitle("确定", for: .normal)
        
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { make in
            make.centerX.equalTo(self.view);
            make.top.equalTo(codeView.snp.bottom).offset(57.uiX);
            make.width.equalTo(305.uiX)
            make.height.equalTo(50.uiX);
        }
        let backgroundImg = UIImage(color: .init(hex: "#DADAE0"), size: .init(width: 305.uiX, height: 50.uiX))
        let normalbackgroundImg = UIImage(color: .init(hex: "#27CBB3"), size: .init(width: 305.uiX, height: 50.uiX))
        loginBtn.setBackgroundImage(backgroundImg, for: .disabled)
        loginBtn.setBackgroundImage(normalbackgroundImg, for: .normal)
       
    }
    
    private func getPhoneView() -> (UIView, PhoneFormattedTextField) {
        let phoneView = UIView()
        
        let lbl = UILabel()
        lbl.text = "手机号"
        lbl.textColor = .init(hex: "#393946")
        lbl.font = .init(style: .regular, size: 16.uiX)
        
        let field = getTextField(with: "请输入您的手机号")
        
        let lineView = UIView()
        lineView.backgroundColor = .init(hex: "#F5F5F7")
        
        phoneView.addSubview(lbl)
        phoneView.addSubview(field)
        phoneView.addSubview(lineView)
        
        lbl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lbl.snp.makeConstraints { make in
            make.left.centerY.equalTo(phoneView);
        }
        
        field.snp.makeConstraints { make in
            make.left.equalTo(lbl.snp.right).offset(26.uiX);
            make.right.centerY.equalTo(phoneView);
            make.top.equalTo(phoneView.snp.top).offset(2.uiX);
        }
        
        lineView.snp.makeConstraints { make in
            make.right.left.bottom.equalTo(phoneView);
            make.height.equalTo(1/UIScreen.main.scale);
        }
        
        return (phoneView, field)
    }
    
    private func getCodeView() -> (UIView, PhoneFormattedTextField, UIButton) {
        let codeView = UIView()
        
        let btn = UIButton()
        btn.titleLabel?.font = .init(style: .regular, size: 14.uiX)
        btn.setTitle("获取验证码", for: .normal)
        btn.titleLabel?.textColor = .init(hex: "#999999")
        btn.isUserInteractionEnabled = false
        
        let field = getTextField(with: "短信验证码")
        
        let lineView = UIView()
        lineView.backgroundColor = .init(hex: "#F5F5F7")
        
        let marginLineView = UIView()
        marginLineView.backgroundColor = .init(hex: "#F5F5F7")
        
        let lbl = UILabel()
        lbl.text = "验证码"
        lbl.textColor = .init(hex: "#393946")
        lbl.font = .init(style: .regular, size: 16.uiX)
        
        codeView.addSubview(lbl)
        codeView.addSubview(btn)
        codeView.addSubview(field)
        codeView.addSubview(lineView)
        codeView.addSubview(marginLineView)
        
        btn.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        btn.snp.makeConstraints { make in
            make.right.centerY.equalTo(codeView);
            make.width.equalTo(100.uiX)
        }
        
        lbl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lbl.snp.makeConstraints { make in
            make.left.centerY.equalTo(codeView);
        }
        
        field.snp.makeConstraints { make in
            make.left.equalTo(lbl.snp.right).offset(26.uiX);
            make.right.equalTo(codeView).offset(-100.uiX);
            make.centerY.equalTo(codeView);
            make.top.equalTo(codeView.snp.top).offset(2.uiX);
        }
        
        lineView.snp.makeConstraints { make in
            make.right.left.bottom.equalTo(codeView);
            make.height.equalTo(1/UIScreen.main.scale);
        }
        
        marginLineView.snp.makeConstraints { make in
            make.left.equalTo(btn.snp.left);
            make.centerY.equalTo(btn);
            make.width.equalTo(1/UIScreen.main.scale);
            make.height.equalTo(26.uiX);
        }
        
        return (codeView, field, btn)
    }
    
    private func getTextField(with placeholder: String) -> PhoneFormattedTextField {
        let textField = PhoneFormattedTextField()
        let placeAtt:[NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#CCCCCC")
        ]
        textField.textColor = .init(hex: "#393946")
        
        switch type {
        case .loginBind:
            textField.font = .init(style: .regular, size: 17.uiX)
        default:
            textField.font = .init(style: .regular, size: 16.uiX)
        }
        
        textField.keyboardType = .numberPad
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeAtt)
        return textField
    }

}
