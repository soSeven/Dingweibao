//
//  EditNameViewController.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/1.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol EditNameViewControllerDelegate: AnyObject {
    
    func editNameDimiss(controller: EditNameViewController)
    
}

class EditNameViewController: ViewController {
    
    var viewModel: EditNameViewModel!
    
    let showSuccess = PublishRelay<String>()
    
    var placeHolder = "请输入群名称..."
    var text = ""
    
    var wordCount = 4
    var chinaWordCount = 2
    var alertTitle = "最多8个汉字或16个字母"
    
    weak var delegate: EditNameViewControllerDelegate?
    
    private var saveBtn = Button()
    
    private lazy var textField: UITextField = {
        let t = UITextField()
        t.textColor = .init(hex: "#393946")
        t.returnKeyType = .done
        t.clearButtonMode = .whileEditing
        t.font = .init(style: .regular, size: 16.uiX)
        let att: [NSAttributedString.Key: Any] = [
            .font : UIFont(style: .regular, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#666666")
        ]
        t.attributedPlaceholder = NSAttributedString(string: self.placeHolder, attributes: att)
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    override func onceWhenViewDidAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        textField.rx.text.orEmpty.bind {[weak self] text in
            guard let self = self else { return }
            let match = "(^[\u{4e00}-\u{9fa5}]+$)"
            let pre = NSPredicate(format: "SELF matches %@", match)
            if pre.evaluate(with: text) {
                if text.count >= 8 {
                    self.textField.text = String(text.prefix(8))
                }
                if text.count < self.chinaWordCount {
                    self.setupSave(enable: false)
                } else {
                    self.setupSave(enable: true)
                }
                
            } else {
                if text.count >= 16 {
                    self.textField.text = String(text.prefix(16))
                }
                if text.count < self.wordCount {
                    self.setupSave(enable: false)
                } else {
                    self.setupSave(enable: true)
                }
            }
        }.disposed(by: rx.disposeBag)
        
        let save = saveBtn.rx.tap.flatMap {[weak self] _  -> Observable<String> in
            guard let self = self else { return Observable.empty() }
            guard let text = self.textField.text, !text.isEmpty else { return Observable.empty() }
//            let match = "(^[\u{4e00}-\u{9fa5}]+$)"
//            let pre = NSPredicate(format: "SELF matches %@", match)
//            if pre.evaluate(with: text) {
//                if text.count < 2 {
//                    return Observable.empty()
//                }
//            } else {
//                if text.count < 4 {
//                    return Observable.empty()
//                }
//            }
            return Observable.of(text)
        }
        let input = EditNameViewModel.Input(save: save)
        let output = viewModel.transform(input: input)
        
        viewModel.loading.asObservable().bind(to: view.rx.mbHudLoaingForce).disposed(by: rx.disposeBag)
        let completion = {[weak self] in
            guard let self = self else { return }
            self.delegate?.editNameDimiss(controller: self)
        }
        output.showSuccess.bind(to: view.rx.mbHudText(completion: completion)).disposed(by: rx.disposeBag)
        output.showSuccess.bind {[weak self] _ in
            guard let self = self else { return }
            guard let text = self.textField.text, !text.isEmpty else { return }
            self.showSuccess.accept(text)
            self.textField.resignFirstResponder()
        }.disposed(by: rx.disposeBag)
        viewModel.parsedError.asObserver().bind(to: view.rx.toastError).disposed(by: rx.disposeBag)
        
    }
    
    // MARK: UI
    
    private func setupUI() {
        setupSave(enable: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveBtn)
        
        let att: [NSAttributedString.Key: Any] = [
            .font : UIFont(style: .regular, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#393946")
        ]
        let cancelBtn = Button()
        cancelBtn.setAttributedTitle(.init(string: "取消", attributes: att), for: .normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelBtn)
        cancelBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.editNameDimiss(controller: self)
        }).disposed(by: rx.disposeBag)
        
        let bgView = UIView()
        bgView.borderColor = .init(hex: "#EDEDED")
        bgView.borderWidth = 0.5
        bgView.backgroundColor = .init(hex: "#ffffff")
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(65.uiX)
        }
        
        textField.text = text
        textField.autocorrectionType = .no
        bgView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 15.uiX, bottom: 0, right: 15.uiX))
        }
        
        let lbl = UILabel()
        lbl.text = alertTitle
        lbl.textColor = .init(hex: "#999999")
        lbl.font = .init(style: .regular, size: 12.uiX)
        view.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom).offset(13.uiX)
            make.left.equalToSuperview().offset(15.uiX)
        }
        
    }
    
    func setupSave(enable: Bool) {
        if enable {
            let att: [NSAttributedString.Key: Any] = [
                .font : UIFont(style: .regular, size: 15.uiX),
                .foregroundColor: UIColor(hex: "#393946")
            ]
            saveBtn.isUserInteractionEnabled = true
            saveBtn.setAttributedTitle(.init(string: "保存", attributes: att), for: .normal)
        } else {
            let att: [NSAttributedString.Key: Any] = [
                .font : UIFont(style: .regular, size: 15.uiX),
                .foregroundColor: UIColor(hex: "#CCCCCC")
            ]
            saveBtn.isUserInteractionEnabled = false
            saveBtn.setAttributedTitle(.init(string: "保存", attributes: att), for: .normal)
        }
        
    }

}
