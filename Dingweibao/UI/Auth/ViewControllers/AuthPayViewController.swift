//
//  AuthPayViewController.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/4.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import FSPagerView
import YYText
import RxSwift
import RxCocoa

protocol AuthPayViewControllerDelegate: AnyObject {
    func payDimiss(controller: AuthPayViewController)
    func payShowProtocol(controller: AuthPayViewController, type: Int)
}

class AuthPayViewController: ViewController {
    
    var viewModel: AuthPayViewModel!
    
    weak var delegate: AuthPayViewControllerDelegate?
    
    private let currentPayView = PayCurrentView()
    private let payListView = PayListView()
    private let retryBtn = UIButton()
    
    private let imgNames = ["pay_pic_position", "pay_pic_inform", "pay_pic_battery", "pay_pic_call"]

    override func viewDidLoad() {
        super.viewDidLoad()
        hbd_barHidden = true
        hbd_backInteractive = false
        setupUI()
        setupBinding()
    }
    
    // MARK: - Binding
    
    func setupBinding() {
        
        let buy = PublishRelay<String>()
        let restore = PublishRelay<Void>()
        var recommendProduct: PayProductModel?
        
        let input = AuthPayViewModel.Input(request: Observable<Void>.just(()),
                                           buy: buy.asObservable(),
                                           restore: restore.asObservable())
        let output = viewModel.transform(input: input)
        
        output.items.bind(to: payListView.items).disposed(by: rx.disposeBag)
        output.items.bind { [weak self] list in
            guard let self = self else { return }
            if list.isEmpty {
                self.currentPayView.isHidden = true
            } else {
                if CheckManager.shared.isCheck {
                    self.currentPayView.isHidden = true
                    recommendProduct = list.filter{$0.isRecommend}.first ?? list.first
                    self.currentPayView.lbl.text = recommendProduct?.recommendDes
                    self.payListView.isHidden = false
                } else {
                    self.currentPayView.isHidden = false
                    recommendProduct = list.filter{$0.isRecommend}.first ?? list.first
                    self.currentPayView.lbl.text = recommendProduct?.recommendDes
                }
            }
        }.disposed(by: rx.disposeBag)
        
        let completion = {[weak self] in
            guard let self = self else { return }
            self.delegate?.payDimiss(controller: self)
        }
        output.buySuccess.bind(to: view.rx.mbHudText(completion: completion)).disposed(by: rx.disposeBag)
        
        payListView.collectionView.rx.itemSelected.subscribe(onNext: { index in
            let m = output.items.value[index.row]
            buy.accept(m.id)
        }).disposed(by: rx.disposeBag)
        
        currentPayView.retryBtn.rx.tap.subscribe(onNext: { _ in
            restore.accept(())
        }).disposed(by: rx.disposeBag)
        
        currentPayView.goBtn.rx.tap.subscribe(onNext: { _ in
            guard let m = recommendProduct else { return }
            buy.accept(m.id)
        }).disposed(by: rx.disposeBag)
        
        retryBtn.rx.tap.subscribe(onNext: { _ in
            restore.accept(())
        }).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.asObserver().bind(to: view.rx.toastError).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: view.rx.mbHudLoaingForce).disposed(by: rx.disposeBag)
        
    }
    
    // MARK: - UI
    
    func setupUI() {
        
        let topView = UIView()
        topView.backgroundColor = .init(hex: "#27CBB3")
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(UIDevice.statusBarHeight)
        }
        
        let imgView = UIImageView(image: UIImage.create("pay_bg"))
        view.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.right.equalToSuperview()
        }
        
        let btn = Button()
        view.addSubview(btn)
        let closeImg = UIImage.create("pay_icon_shut")
        btn.setImage(closeImg, for: .normal)
        btn.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(22.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
        }
        btn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.payDimiss(controller: self)
        }).disposed(by: rx.disposeBag)
        
        // Create a pager view
        let pagerView = FSPagerView(frame: .zero)
        view.addSubview(pagerView)
        pagerView.isInfinite = true
        pagerView.automaticSlidingInterval = 3
        pagerView.dataSource = self
        let scale: CGFloat = 428.0 / 640.0
        let width = 320.uiX
        let height = width * scale
        pagerView.itemSize = .init(width: width, height: height)
        pagerView.interitemSpacing = (UIScreen.main.bounds.width - width)
        pagerView.contentMode = .bottom
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        
        
        pagerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(90.uiX + UIDevice.statusBarHeight)
            make.height.equalTo(height)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        
        let lbl1 = UILabel()
        lbl1.text = "定位宝"
        lbl1.textColor = .init(hex: "#FFFFFF")
        lbl1.font = .init(style: .medium, size: 24.uiX)
        
        let lbl2 = UILabel()
        lbl2.text = "解锁专业版"
        lbl2.textColor = .init(hex: "#FFFFFF")
        lbl2.font = .init(style: .regular, size: 14.uiX)
        
        view.addSubview(lbl1)
        view.addSubview(lbl2)
        lbl2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(pagerView.snp.top).offset(-16.uiX)
        }
        lbl1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(lbl2.snp.top).offset(-2.uiX)
        }
        
        let payView = UIView()
//        payView.backgroundColor = .random
        view.addSubview(payView)
        payView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
            make.height.equalTo(140.uiX)
            make.top.equalTo(pagerView.snp.bottom).offset(38.uiX)
        }
        
        payListView.backgroundColor = .clear
        payListView.isHidden = true
        payView.addSubview(payListView)
        payListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        currentPayView.backgroundColor = .clear
        payView.addSubview(currentPayView)
        currentPayView.changeBtn.rx.tap.subscribe(onNext: { [weak currentPayView, weak self] _ in
            guard let self = self else { return }
            guard let c = currentPayView else { return }
            UIView.transition(from: c, to: self.payListView, duration: 1, options: [.transitionFlipFromBottom, .showHideTransitionViews]) { _ in
                c.removeFromSuperview()
            }
        }).disposed(by: rx.disposeBag)
        currentPayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if CheckManager.shared.isCheck {
            let retryatt: [NSAttributedString.Key:Any] = [
                .font: UIFont(style: .regular, size: 14.uiX),
                .foregroundColor: UIColor(hex: "#7F7F99"),
            ]
            retryBtn.setAttributedTitle(.init(string: "恢复购买", attributes: retryatt), for: .normal)
            view.addSubview(retryBtn)
            retryBtn.snp.makeConstraints { make in
                make.top.equalTo(payView.snp.bottom).offset(5.uiX)
                make.right.equalTo(payView.snp.right)
            }
        }
        
        let att = NSMutableAttributedString(string: "自动续期服务：1.免费试用：专业版免费试用3天，试用结束按季度订阅，用户可以在试用期间随时取消。2.订阅会员自动续期，在服务到期前24小时自动续订服务并通过iTunes账户扣除相应费用，同时延长专业版高级服务相应的有效期。3.如需停止自动续期服务，请在下个账单日期之前在 App Store账户设置页，点击“订阅”取消对应服务。")
        att.yy_lineSpacing = 3.uiX
        att.yy_color = .init(hex: "#999999")
        att.yy_font = .init(style: .regular, size: 10.uiX)
        let lbl = UILabel()
        lbl.attributedText = att
        lbl.numberOfLines = 0
        view.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
            make.top.equalTo(payView.snp.bottom).offset(38.uiX)
        }
        
        let proto = getProtocolView()
        view.addSubview(proto)
        proto.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
            make.top.equalTo(lbl.snp.bottom).offset(18.uiX)
        }
        
        
    }
    
    private func getProtocolView() -> UIView {
        
        let text = NSMutableAttributedString(string: "")
        text.yy_font = .init(style: .regular, size: 12.uiX)
        text.yy_color = .init(hex: "#7F7F99")
        
        let a = NSMutableAttributedString(string: "自动续期服务声明")
        a.yy_font = .init(style: .regular, size: 12.uiX)
        a.yy_color = .init(hex: "#7F7F99")
        a.yy_underlineColor = .init(hex: "#7F7F99")
        a.yy_underlineStyle = .single
        
        let hi = YYTextHighlight()
        hi.tapAction =  { [weak self] containerView, text, range, rect in
            guard let self = self else { return }
            self.delegate?.payShowProtocol(controller: self, type: 4)
        };
        a.yy_setTextHighlight(hi, range: a.yy_rangeOfAll())
        
        let b = NSMutableAttributedString(string: "和")
        b.yy_font = .init(style: .regular, size: 13.uiX)
        b.yy_color = .init(hex: "#7F7F99")
        
        let c = NSMutableAttributedString(string: "隐私政策")
        c.yy_font = .init(style: .regular, size: 12.uiX)
        c.yy_color = .init(hex: "#7F7F99")
        c.yy_underlineColor = .init(hex: "#7F7F99")
        c.yy_underlineStyle = .single
        
        let chi = YYTextHighlight()
        chi.tapAction = { [weak self] containerView, text, range, rect in
            guard let self = self else { return }
            self.delegate?.payShowProtocol(controller: self, type: 2)
        };
        c.yy_setTextHighlight(chi, range: c.yy_rangeOfAll())
        
        text.append(a)
        text.append(b)
        text.append(c)
        
        let protocolLbl = YYLabel()
        protocolLbl.attributedText = text;
        
        return protocolLbl
    }

}

extension AuthPayViewController: FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imgNames.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let m = imgNames[index]
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = .create(m)
        cell.contentView.layer.shadowOpacity = 0
//        cell.isSelected = false
        cell.isHighlighted = false
//        cell.selectedBackgroundView = UIView()
        return cell
    }
    
}
