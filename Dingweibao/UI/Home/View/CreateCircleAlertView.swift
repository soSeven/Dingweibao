//
//  CreateCircleAlertSuccessView.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/8.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import SwiftEntryKit
import RxSwift
import RxCocoa
import MBProgressHUD
import SwifterSwift

class CreateCircleAlertSuccessView: UIView {
    
    lazy var btn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .init(hex: "#47CBB9")
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#ffffff"),
        ]
        btn.setImage(UIImage.create("login_wechat"), for: .normal)
        btn.setAttributedTitle(.init(string: " 微信邀请", attributes: att), for: .normal)
        return btn
    }()
    
    lazy var copyBtn: UIButton = {
        let btn = UIButton()
//        btn.backgroundColor = .init(hex: "#67677C")
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#67677C"),
        ]
        btn.borderColor = .init(hex: "#67677C")
        btn.borderWidth = 0.5
        btn.setAttributedTitle(.init(string: "复制邀请码", attributes: att), for: .normal)
        return btn
    }()
    
    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#222222")
        l.font = .init(style: .medium, size: 18.uiX)
        l.text = "邀请加入"
        l.textAlignment = .center
        return l
    }()
    
    lazy var descipLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#CCCCCC")
        l.font = .init(style: .regular, size: 12.uiX)
        l.text = "分享邀请码给好友"
        
        return l
    }()
    
    lazy var codeLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#1AAB97")
        l.font = .init(style: .bold, size: 34.uiX)
        l.text = "660888"
        l.textAlignment = .center
        return l
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = Button()
        btn.setImage(UIImage.create("icon_shut"), for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        addSubview(btn)
        btn.cornerRadius = 6.uiX
        btn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10.uiX)
            make.height.equalTo(44.uiX)
            make.width.equalTo(230.uiX)
            make.centerX.equalToSuperview()
        }
        
        addSubview(copyBtn)
        copyBtn.cornerRadius = 6.uiX
        copyBtn.snp.makeConstraints { make in
            make.bottom.equalTo(btn.snp.top).offset(-10.uiX)
            make.height.equalTo(44.uiX)
            make.width.equalTo(230.uiX)
            make.centerX.equalToSuperview()
        }
        
        addSubview(descipLbl)
        descipLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(copyBtn.snp.top).offset(-25.uiX)
        }
        
        addSubview(codeLbl)
        codeLbl.snp.makeConstraints { make in
//            make.height.equalTo(35.uiX)
//            make.width.equalTo(230.uiX)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(descipLbl.snp.top).offset(5.uiX)
        }
        
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(codeLbl.snp.top).offset(-10.uiX)
            make.top.equalToSuperview().offset(10.uiX)
        }
        
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLbl.snp.centerY)
            make.right.equalToSuperview().offset(-25.uiX)
        }
        
    }
}

class CreateCircleAlertLoadingView: UIView {
    
    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#222222")
        l.font = .init(style: .medium, size: 18.uiX)
        l.text = "创建群组"
        l.textAlignment = .center
        return l
    }()
    
    lazy var descipLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#666666")
        l.font = .init(style: .regular, size: 14.uiX)
        l.text = "请输入群号"
        
        return l
    }()
    
    lazy var activityView: UIActivityIndicatorView = {
        let l = UIActivityIndicatorView()
        l.color = .gray
        l.style = .whiteLarge
        l.startAnimating()
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        addSubview(activityView)
        activityView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        addSubview(descipLbl)
        descipLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
}

class CreateCircleAlertInputView: UIView {
    
    lazy var btn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .init(hex: "#47CBB9")
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .medium, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#ffffff"),
        ]
        btn.setAttributedTitle(.init(string: "创建", attributes: att), for: .normal)
        return btn
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = Button()
        btn.setImage(UIImage.create("icon_shut"), for: .normal)
        return btn
    }()
    
    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#222222")
        l.font = .init(style: .medium, size: 18.uiX)
        l.text = "创建群组"
        l.textAlignment = .center
        return l
    }()
    
    let avaImgView = UIImageView(image: UIImage.create("flock_headportrait"))
    
    lazy var textField: UITextField = {
        let l = UITextField()
        l.textColor = .init(hex: "#393946")
        l.font = .init(style: .medium, size: 20.uiX)
        l.textAlignment = .center
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .medium, size: 20.uiX),
            .foregroundColor: UIColor(hex: "#CCCCCC"),
        ]
        l.attributedPlaceholder = .init(string: "群组名称", attributes: att)
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        addSubview(btn)
        btn.cornerRadius = 5.uiX
        btn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10.uiX)
            make.height.equalTo(41.uiX)
            make.width.equalTo(230.uiX)
            make.centerX.equalToSuperview()
        }
        
        let lineView = UIView()
        lineView.backgroundColor = .init(hex: "#EEEEEE")
        addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(0.5)
            make.width.equalTo(230.uiX)
            make.bottom.equalTo(btn.snp.top).offset(-29.uiX)
        }
        
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.height.equalTo(35.uiX)
            make.width.equalTo(230.uiX)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(lineView.snp.top)
        }
//        textField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
//            guard let self = self else { return }
//            if text.count >= 6 {
//                self.textField.text = String(text.prefix(6))
//            }
//        }).disposed(by: rx.disposeBag)
        
        avaImgView.backgroundColor = .init(hex: "#F6F6F8")
        avaImgView.cornerRadius = 27.uiX
        addSubview(avaImgView)
        avaImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 54.uiX, height: 54.uiX))
            make.bottom.equalTo(textField.snp.top).offset(-20.uiX)
        }
        
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(avaImgView.snp.top).offset(-18.uiX)
            make.top.equalToSuperview().offset(10.uiX)
        }
        
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLbl.snp.centerY)
            make.right.equalToSuperview().offset(-25.uiX)
        }
        
    }
}


class CreateCircleAlertView: UIView {
    
    var viewModel = CreateCircleViewModel()
    var shareViewModel = ShareViewModel()
    
    var addCircle: PublishSubject<CircleListCellViewModel>?
    
    var avatar: String?
    var name: String?
    
    let addRelay = PublishSubject<(String?, String?)>()
    
    let shareSubject = PublishSubject<(ShareType, Int)>()
    
    let inputTextView = CreateCircleAlertInputView()
    let loadingView = CreateCircleAlertLoadingView()
    let successView = CreateCircleAlertSuccessView()
    
    var currentID: Int?
    
    init(name: String?, avatar: String?, currentID: Int? = nil, title: String? = nil) {
        super.init(frame: .zero)
        self.name = name
        self.avatar = avatar
        self.currentID = currentID
        setupUI()
        if let title = title {
            successView.titleLbl.text = title
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        inputTextView.textField.text = name ?? "我的家人"
        inputTextView.closeBtn.rx.tap.subscribe(onNext: { _ in
            SwiftEntryKit.dismiss()
        }).disposed(by: rx.disposeBag)
        inputTextView.btn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.addRelay.onNext((self.name, self.avatar))
        }).disposed(by: rx.disposeBag)
        inputTextView.avaImgView.rx.tap().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let v = CircleAvatarsView(avatar: self.avatar)
            let name = self.name
            let addCircle = self.addCircle
            v.completion = { a in
                let c = CreateCircleAlertView(name: name, avatar: a)
                c.addCircle = addCircle
                c.show()
            }
            v.show()
        }).disposed(by: rx.disposeBag)
        inputTextView.textField.rx.text.orEmpty.subscribe(onNext: { [weak self] str in
            guard let self = self else { return }
            self.name = str
        }).disposed(by: rx.disposeBag)
        inputTextView.avaImgView.kf.setImage(with: URL(string: avatar), placeholder: UIImage.create("flock_headportrait"))
        addSubview(inputTextView)
        inputTextView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(140.uiX)
        }
        
//        successView.btn.rx.tap.subscribe(onNext: { _ in
//            SwiftEntryKit.dismiss()
//        }).disposed(by: rx.disposeBag)
        successView.closeBtn.rx.tap.subscribe(onNext: { _ in
            SwiftEntryKit.dismiss()
        }).disposed(by: rx.disposeBag)
        addSubview(successView)
        successView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 290.uiX, height: 260.uiX))
        }
        
        if let id = self.currentID {
            self.successView.isHidden = false
            self.loadingView.isHidden = true
            self.inputTextView.isHidden = true
            self.successView.codeLbl.text = String(id)
        }
        
        setupBinding()
    }
    
    // MARK: Binding
    
    func setupBinding() {
        
        if self.currentID == nil {
            let input = CreateCircleViewModel.Input(addCircle: addRelay.asObserver())
            let output = viewModel.transform(input: input)
            
            output.status.distinctUntilChanged().subscribe(onNext: { [weak self] status in
                guard let self = self else { return }
                self.successView.isHidden = !(status == .complete)
                self.loadingView.isHidden = !(status == .loading)
                self.inputTextView.isHidden = !(status == .input)
                self.loadingView.descipLbl.text = self.name
            }).disposed(by: rx.disposeBag)
            
            output.msgError.bind(to: rx.mbHudText).disposed(by: rx.disposeBag)
            
            output.item.subscribe(onNext: { [weak self] m in
                guard let self = self else { return }
                self.addCircle?.onNext(m)
                self.successView.codeLbl.text = String(m.id)
                self.currentID = m.id
            }).disposed(by: rx.disposeBag)
        }
        
        let shareInput = ShareViewModel.Input(share: shareSubject.asObserver())
        let shareOutput = shareViewModel.transform(input: shareInput)
        shareOutput.hud.bind(to: rx.mbHudText).disposed(by: rx.disposeBag)
        shareViewModel.loading.asObservable().bind(to: rx.mbHudLoaing).disposed(by: rx.disposeBag)
        
        successView.btn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard let id = self.currentID else { return }
            self.shareSubject.onNext((.wxFriend, id))
        }).disposed(by: rx.disposeBag)
        
        successView.copyBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard let id = self.currentID else { return }
            UIPasteboard.general.string = String(id)
            Observable.just("复制成功").bind(to: self.rx.mbHudText).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
    }
    
    
    // MARK: - Show
    
    func show() {
        
        var attributes = EKAttributes.centerFloat
        
        attributes.screenBackground = .color(color: .init(.init(white: 0, alpha: 0.6)))
        attributes.entryBackground = .color(color: .white)
        attributes.screenInteraction = .absorbTouches
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .disabled
        attributes.displayDuration = .infinity
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        
        attributes.lifecycleEvents.didAppear = { [weak self] in
            guard let self = self else { return }
            if self.currentID == nil {
                self.inputTextView.textField.becomeFirstResponder()
            }
        }
        
        SwiftEntryKit.display(entry: self, using: attributes, presentInsideKeyWindow: true)
    }
    
}
