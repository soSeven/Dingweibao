//
//  HomeNavBar.swift
//  Dingweibao
//
//  Created by LiQi on 2020/5/27.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import NSObject_Rx

class HomeDropBtn: UIView {
    
    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#FFFFFF")
        l.font = .init(style: .medium, size: 19.uiX)
        l.textAlignment = .center
        return l
    }()
    lazy var arrowImgView: UIImageView = {
        let i = UIImageView(image: UIImage(named: "icon_xiala"))
        return i
    }()
    
    var action: ((HomeDropBtn)->())?
    var selected = false
    var containerView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLbl.setContentHuggingPriority(.init(floatLiteral: 100), for: .horizontal)
        titleLbl.setContentCompressionResistancePriority(.init(floatLiteral: 100), for: .horizontal)
        let stack = UIStackView(arrangedSubviews: [titleLbl, arrowImgView])
        stack.spacing = 5.uiX
        stack.alignment = .center
        addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.lessThanOrEqualToSuperview().offset(22.uiX)
            make.right.lessThanOrEqualToSuperview().offset(-22.uiX)
        }
        
        self.rx.tap().subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.action?(self)
        }).disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSelected(selected: Bool) {
        if selected {
//            titleLbl.textColor = .init(hex: "#FF2071")
//            arrowImgView.image = UIImage(named: "search_icon_arrow_up")
            arrowImgView.transform = .init(rotationAngle: CGFloat(Float.pi))
            self.selected = true
        } else {
//            arrowImgView.image = UIImage(named: "search_icon_arrow_down")
            arrowImgView.transform = .identity
//            titleLbl.textColor = .init(hex: "#999999")
            self.selected = false
        }
    }
    
}

class HomeNavBar: UIView {
    
    lazy var myBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 45.uiX / 2
        btn.shadowRadius = 3.uiX
        btn.shadowOffset = .init(width: Float(1.5).uiX, height: 0)
        btn.shadowColor = .init(hex: "#363636")
        btn.shadowOpacity = 0.16
        return btn
    }()
    
    lazy var mapBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 45.uiX / 2
        btn.shadowRadius = 3.uiX
        btn.shadowOffset = .init(width: Float(1.5).uiX, height: 0)
        btn.shadowColor = .init(hex: "#363636")
        btn.shadowOpacity = 0.16
        return btn
    }()
    
    lazy var contentBtnView: UIView = {
        let v = UIView()
        return v
    }()
    
    // Drop View
    
    lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }()
    
    lazy var bgView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        v.rx.tap().subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.dimiss()
        }).disposed(by: rx.disposeBag)
        return v
    }()
    
    lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.clipsToBounds = true
        return v
    }()
    
    lazy var dropBtn: HomeDropBtn = {
        let b = HomeDropBtn()
        b.titleLbl.text = "我的家人"
        b.backgroundColor = .init(hex: "#27CBB3")
        b.cornerRadius = 22.uiX
        return b
    }()
    
    var isShow = false
    
    var circleListRelay = BehaviorRelay<[CircleListCellViewModel]>(value: [])
    var selectRelay = PublishRelay<CircleListCellViewModel>()
    var addCircle = PublishRelay<Void>()
    var createCircle = PublishRelay<Void>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    func setupUI() {
        
        addSubview(contentBtnView)
        contentBtnView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(64.uiX)
        }
        
        let my = UIImage.create("icon_my")
        myBtn.setImage(my, for: .normal)
        let map = UIImage.create("icon_sj")
        mapBtn.setImage(map, for: .normal)
        
        dropBtn.action = {[weak self] btn in
            guard let self = self else { return }
            self.onclickChooseBtn(btn: btn)
        }
        
        contentBtnView.addSubview(myBtn)
        contentBtnView.addSubview(mapBtn)
        contentBtnView.addSubview(dropBtn)
        
        dropBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(44.uiX)
            make.width.equalTo(150.uiX)
        }
        
        myBtn.snp.makeConstraints { make in
            make.width.equalTo(45.uiX)
            make.height.equalTo(45.uiX)
            make.centerY.equalToSuperview()
            make.left.equalTo(self.snp.left).offset(17.uiX)
        }
        
        mapBtn.snp.makeConstraints { make in
            make.width.equalTo(45.uiX)
            make.height.equalTo(45.uiX)
            make.centerY.equalToSuperview()
            make.right.equalTo(self.snp.right).offset(-17.uiX)
        }
        
        circleListRelay.subscribe(onNext: { [weak self] list in
            guard let self = self else { return }
            if list.isEmpty {
                self.dropBtn.titleLbl.text = "没有群组"
            }
            let h = 66.uiX + CGFloat.minimum(6.0, CGFloat(Float(list.count))) * (65.uiX)
            let v = HomeCircleListView(frame: CGRect(x: 0, y: 0, width: 0, height: h), titles: list)
            v.backgroundColor = .white
            v.selectRelay.bind(to: self.selectRelay).disposed(by: v.rx.disposeBag)
            v.addCircle.bind(to: self.addCircle).disposed(by: v.rx.disposeBag)
            v.createCircle.bind(to: self.createCircle).disposed(by: v.rx.disposeBag)
            let me = Observable.merge(v.selectRelay.flatMap{ _ in Observable.just(())}.asObservable(), v.addCircle.asObservable(), v.createCircle.asObservable())
            me.subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dimiss()
            }).disposed(by: v.rx.disposeBag)
            self.dropBtn.containerView = v
        }).disposed(by: rx.disposeBag)
    }
    
    private func onclickChooseBtn(btn: HomeDropBtn) {
        guard let superView = superview else {
            return
        }
        guard let _ = dropBtn.containerView else {
            return
        }

        if btn.selected { //收起
            isShow = false
            
            backgroundColor = .clear
            mapBtn.isHidden = false
            myBtn.isHidden = false
            
            superView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.3, animations: {
                btn.setupSelected(selected: false)
                self.bgView.alpha = 0
                self.containerView.frame = CGRect(x: 0, y: 0, width: self.contentView.width, height: 0)
            }) { finished in
                superView.isUserInteractionEnabled = true
                self.contentView.removeFromSuperview()
                self.containerView.removeSubviews()
            }
        } else {
            if !isShow { // 第一次
                superView.addSubview(contentView)
                contentView.frame = getShowFrame()

                contentView.addSubview(bgView)
                bgView.frame = contentView.bounds
                bgView.alpha = 0

                contentView.addSubview(containerView)
                containerView.frame = CGRect(x: 0, y: 0, width: contentView.width, height: 0)
            }
            isShow = true

            backgroundColor = .init(hex: "#27CBB3")
            mapBtn.isHidden = true
            myBtn.isHidden = true
            
            let lastSubView = containerView.subviews.first
            let currentSubView = btn.containerView

            if lastSubView != currentSubView {
                lastSubView?.alpha = 1
                currentSubView?.alpha = 0
                if let v = currentSubView {
                    v.frame = CGRect(x: 0, y: 0, width: containerView.width, height: v.height)
                    containerView.addSubview(v)
                }
            }

            superView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.3, animations: {
                btn.setupSelected(selected: true)
                self.bgView.alpha = 1
                self.containerView.frame = CGRect(x: 0, y: 0, width: self.contentView.width, height: btn.containerView?.height ?? 0)
                if lastSubView != currentSubView {
                    currentSubView?.alpha = 1
                    lastSubView?.alpha = 0
                }
            }) { finished in
                superView.isUserInteractionEnabled = true
                if lastSubView != currentSubView {
                    lastSubView?.removeFromSuperview()
                }
            }
        }

    }

    func dimiss() {
        guard let superView = superview else {
            return
        }
        isShow = false
        
        backgroundColor = .clear
        mapBtn.isHidden = false
        myBtn.isHidden = false
        
        superView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.dropBtn.setupSelected(selected: false)
            self.bgView.alpha = 0
            self.containerView.frame = CGRect(x: 0, y: 0, width: self.contentView.width, height: 0)
        }) { finished in
            superView.isUserInteractionEnabled = true
            self.contentView.removeFromSuperview()
            self.containerView.removeSubviews()
        }
    }

    private func getShowFrame() -> CGRect {
        guard let superView = superview else {
            return .zero
        }
        let selfFrame = frame
        let superBounds = superView.bounds
        let x: CGFloat = selfFrame.origin.x
        let y: CGFloat = selfFrame.origin.y + selfFrame.size.height
        let w: CGFloat = selfFrame.size.width
        let h: CGFloat = superBounds.height - y
        let frame = CGRect(x: x, y: y, width: w, height: h)
        return frame
    }
    
    
}

