//
//  AddCircleAlertView.swift
//  Dingweibao
//
//  Created by LiQi on 2020/5/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftEntryKit
import RxSwift
import RxCocoa
import MBProgressHUD

class AddCircleAlertSuccessView: UIView {
    
    lazy var btn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .init(hex: "#47CBB9")
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .medium, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#ffffff"),
        ]
        btn.setAttributedTitle(.init(string: "我知道了", attributes: att), for: .normal)
        return btn
    }()
    
    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#222222")
        l.font = .init(style: .medium, size: 18.uiX)
        l.text = "加入群组"
        l.textAlignment = .center
        return l
    }()
    
    lazy var descipLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#666666")
        l.font = .init(style: .regular, size: 14.uiX)
        l.text = "请等待群主通过"
        
        return l
    }()
    
    lazy var successView: UIButton = {
        let btn = UIButton()
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 20.uiX),
            .foregroundColor: UIColor(hex: "#222222"),
        ]
        btn.setAttributedTitle(.init(string: " 申请成功", attributes: att), for: .normal)
        btn.setImage(UIImage.create("icon_succeed"), for: .normal)
        btn.isUserInteractionEnabled = false
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
        btn.cornerRadius = 5.uiX
        btn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10.uiX)
            make.height.equalTo(41.uiX)
            make.width.equalTo(230.uiX)
            make.centerX.equalToSuperview()
        }
        
        addSubview(descipLbl)
        descipLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(btn.snp.top).offset(-22.uiX)
        }
        
        addSubview(successView)
        successView.snp.makeConstraints { make in
            make.height.equalTo(35.uiX)
//            make.width.equalTo(230.uiX)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(descipLbl.snp.top).offset(-25.uiX)
        }
        
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(successView.snp.top).offset(-25.uiX)
            make.top.equalToSuperview().offset(10.uiX)
        }
        
    }
}

class AddCircleAlertLoadingView: UIView {
    
    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#222222")
        l.font = .init(style: .medium, size: 18.uiX)
        l.text = "加入群组"
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

class AddCircleAlertInputView: UIView {
    
    lazy var btn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .init(hex: "#47CBB9")
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .medium, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#ffffff"),
        ]
        btn.setAttributedTitle(.init(string: "加入", attributes: att), for: .normal)
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
        l.text = "加入群组"
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
    
    lazy var textField: UITextField = {
        let l = UITextField()
        l.textColor = .init(hex: "#393946")
        l.font = .init(style: .medium, size: 20.uiX)
        l.textAlignment = .center
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .medium, size: 20.uiX),
            .foregroundColor: UIColor(hex: "#CCCCCC"),
        ]
        l.attributedPlaceholder = .init(string: "000000", attributes: att)
        l.keyboardType = .numberPad
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
        
        addSubview(descipLbl)
        descipLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(btn.snp.top).offset(-22.uiX)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = .init(hex: "#EEEEEE")
        addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(0.5)
            make.width.equalTo(230.uiX)
            make.bottom.equalTo(descipLbl.snp.top).offset(-20.uiX)
        }
        
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.height.equalTo(35.uiX)
            make.width.equalTo(230.uiX)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(lineView.snp.top)
        }
        textField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            if text.count >= 6 {
                self.textField.text = String(text.prefix(6))
            }
        }).disposed(by: rx.disposeBag)
        
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(textField.snp.top).offset(-24.uiX)
            make.top.equalToSuperview().offset(10.uiX)
        }
        
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLbl.snp.centerY)
            make.right.equalToSuperview().offset(-25.uiX)
        }
        
    }
}


class AddCircleAlertView: UIView {
    
    var viewModel = AddCircleViewModel()
    
    var addCircle: PublishSubject<CircleListCellViewModel>?
    let addRelay = PublishSubject<(String?, String?, String?)>()
    
    let successView = AddCircleAlertSuccessView()
    let loadingView = AddCircleAlertLoadingView()
    let inputTextView = AddCircleAlertInputView()
    
    var id: String?
    var encodeId: String?
    var userId: String?
    var dimiss: SwiftEntryKit.DismissCompletionHandler?
    
    init(id: String? = nil, encodeId: String? = nil, userId: String? = nil, dimiss: SwiftEntryKit.DismissCompletionHandler? = nil) {
        self.id = id
        self.encodeId = encodeId
        self.userId = userId
        self.dimiss = dimiss
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        if let id = id {
            inputTextView.textField.text = id
        }
        inputTextView.closeBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            SwiftEntryKit.dismiss(.displayed, with: self.dimiss)
        }).disposed(by: rx.disposeBag)
        inputTextView.btn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.addRelay.onNext((self.inputTextView.textField.text, self.encodeId, self.userId))
        }).disposed(by: rx.disposeBag)
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
        
        successView.btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            SwiftEntryKit.dismiss(.displayed, with: self.dimiss)
        }).disposed(by: rx.disposeBag)
        addSubview(successView)
        successView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 290.uiX, height: 230.uiX))
        }
        
        setupBinding()
    }
    
    // MARK: - Binding
    
    func setupBinding() {
        let input = AddCircleViewModel.Input(addCircle: addRelay.asObserver())
        let output = viewModel.transform(input: input)
        
        output.status.subscribe(onNext: {[weak self] status in
            guard let self = self else { return }
            self.successView.isHidden = !(status == .complete)
            self.loadingView.isHidden = !(status == .loading)
            self.inputTextView.isHidden = !(status == .input)
        }).disposed(by: rx.disposeBag)
        
        output.msgError.bind(to: rx.mbHudImageText).disposed(by: rx.disposeBag)
        
        output.item.subscribe(onNext: { [weak self] m in
            guard let self = self else { return }
            self.addCircle?.onNext(m)
            switch m.joinAuth {
            case 2:
                let att: [NSAttributedString.Key:Any] = [
                    .font: UIFont(style: .regular, size: 20.uiX),
                    .foregroundColor: UIColor(hex: "#222222"),
                ]
                self.successView.successView.setAttributedTitle(.init(string: " 加入成功", attributes: att), for: .normal)
                self.successView.descipLbl.isHidden = true
                break
            default:
                break
            }
        }).disposed(by: rx.disposeBag)
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
        
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        
        attributes.lifecycleEvents.didAppear = { [weak self] in
            guard let self = self else { return }
            if self.id == nil {
                self.inputTextView.textField.becomeFirstResponder()
            }
        }
        SwiftEntryKit.display(entry: self, using: attributes, presentInsideKeyWindow: true)
    }
    
}
