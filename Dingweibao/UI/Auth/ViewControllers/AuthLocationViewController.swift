//
//  AuthLocationViewController.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/3.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import AuthenticationServices
import Permission
import RxSwift
import RxCocoa

class AuthLocationView: UIView {
    
    lazy var titleLbl: UILabel = {
        let l1 = UILabel()
        l1.textColor = .init(hex: "#393946")
        l1.text = ""
        l1.font = .init(style: .regular, size: 17.uiX)
        return l1
    }()
    
    lazy var msgLbl: UILabel = {
        let l1 = UILabel()
        l1.textColor = .init(hex: "#7F7F99")
        l1.text = ""
        l1.numberOfLines = 2
        l1.font = .init(style: .regular, size: 13.uiX)
        return l1
    }()
    
    lazy var btn: UIButton = {
        let b = UIButton()
        b.backgroundColor = .init(hex: "#27CBB3")
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 13.uiX),
            .foregroundColor: UIColor(hex: "#FFFFFF"),
        ]
        b.setAttributedTitle(.init(string: "去开启", attributes: att), for: .normal)
        b.cornerRadius = 3.uiX
        return b
    }()
    
    let checkImgView = UIImageView(image: UIImage.create("permissien_icon_check"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .init(hex: "#F5F5F7")
        cornerRadius = 5.uiX
        
        let stack = UIStackView(arrangedSubviews: [titleLbl, msgLbl], axis: .vertical, spacing: 6.uiX, alignment: .leading, distribution: .equalSpacing)
        
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15.uiX)
            make.width.equalTo(71.uiX)
            make.height.equalTo(34.uiX)
        }
        
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.uiX)
            make.centerY.equalToSuperview()
            make.right.equalTo(btn.snp.left).offset(33.uiX)
        }
        
        addSubview(checkImgView)
        checkImgView.snp.makeConstraints { make in
            make.size.equalTo(checkImgView.image!.snpSize)
            make.center.equalTo(btn.snp.center)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

protocol AuthLocationViewControllerDelegate: AnyObject {
    
    func locationShowPay(controller: AuthLocationViewController)
    
}

class AuthLocationViewController: ViewController {

    private var isCheck = true
    
    weak var delegate: AuthLocationViewControllerDelegate?
    
    let showAlertKey = "showAlertKey"

    override func viewDidLoad() {
        super.viewDidLoad()
        hbd_barHidden = true
        hbd_backInteractive = false
        view.backgroundColor = .white
        setupUI()
    }
    
    // MARK: - UI
    
    func setupUI() {
        
        let l1 = UILabel()
        l1.textColor = .init(hex: "#393946")
        l1.text = "欢迎使用定位宝"
        l1.font = .init(style: .medium, size: 24.uiX)
        view.addSubview(l1)
        l1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.uiX)
            make.top.equalToSuperview().offset(UIDevice.statusBarHeight + 96.uiX)
        }
        
        let l2 = UILabel()
        l2.textColor = .init(hex: "#67677C")
        l2.text = "为保证产品功能正常运行，需要您授予权限如下"
        l2.font = .init(style: .regular, size: 14.uiX)
        view.addSubview(l2)
        l2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.uiX)
            make.top.equalTo(l1.snp.bottom).offset(24.uiX)
        }
        
        let auth1 = AuthLocationView()
        auth1.titleLbl.text = "将位置权限设置为「始终」"
        auth1.msgLbl.text = "只有家人才能看到您的位置\n你也可以随时在APP内设置隐藏位置"
        auth1.btn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.showAlert()
        }).disposed(by: rx.disposeBag)
        LocationAuthManager.shared.authRelay.distinctUntilChanged().subscribe(onNext: { status in
            switch status {
            case .authorized:
                auth1.checkImgView.isHidden = false
                auth1.btn.isHidden = true
            default:
                auth1.checkImgView.isHidden = true
                auth1.btn.isHidden = false
            }
        }).disposed(by: rx.disposeBag)
        view.addSubview(auth1)
        auth1.snp.makeConstraints { make in
            make.width.equalTo(345.uiX)
            make.height.equalTo(110.uiX)
            make.centerX.equalToSuperview()
            make.top.equalTo(l2.snp.bottom).offset(53.uiX)
        }
        
        let auth2 = AuthLocationView()
        auth2.titleLbl.text = "打开通知权限「允许」"
        auth2.msgLbl.text = "用于接收家人移动行踪通知\n智能提醒更安全"
        auth2.btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.showAlert()
        }).disposed(by: rx.disposeBag)
        NotificationAuthManager.shared.authRelay.distinctUntilChanged().subscribe(onNext: { status in
            switch status {
            case .authorized:
                auth2.checkImgView.isHidden = false
                auth2.btn.isHidden = true
            default:
                auth2.checkImgView.isHidden = true
                auth2.btn.isHidden = false
            }
        }).disposed(by: rx.disposeBag)
        view.addSubview(auth2)
        auth2.snp.makeConstraints { make in
            make.width.equalTo(345.uiX)
            make.height.equalTo(110.uiX)
            make.centerX.equalToSuperview()
            make.top.equalTo(auth1.snp.bottom).offset(16.uiX)
        }
        
        let go = UIButton()
        go.backgroundColor = .init(hex: "#27CBB3")
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#FFFFFF"),
        ]
        go.setAttributedTitle(.init(string: "进入", attributes: att), for: .normal)
        go.cornerRadius = 5.uiX
        let con = Observable.combineLatest(LocationAuthManager.shared.authRelay, NotificationAuthManager.shared.authRelay)
        con.subscribe(onNext: { location, notification in
            switch (location, notification) {
            case (.authorized, .authorized):
                go.backgroundColor = .init(hex: "#27CBB3")
                go.isUserInteractionEnabled = true
            default:
                go.backgroundColor = .init(hex: "#DADAE0")
                go.isUserInteractionEnabled = false
            }
        }).disposed(by: rx.disposeBag)
        go.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.locationShowPay(controller: self)
        }).disposed(by: rx.disposeBag)
        view.addSubview(go)
        go.snp.makeConstraints { make in
            make.height.equalTo(44.uiX)
            make.width.equalTo(345.uiX)
            make.centerX.equalToSuperview()
            make.top.equalTo(auth2.snp.bottom).offset(61.uiX)
        }
        
    }
    
    // MARK: - Show Alert
    
    func showAlert() {
        
        if let _ = UserDefaults.standard.object(forKey: showAlertKey) {
            AuthToSettingAlert().show()
        } else {
            UserDefaults.standard.set(object: showAlertKey, forKey: showAlertKey)
            if let URL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(URL)
            }
        }
        
    }

}
