//
//  HomeUsersView.swift
//  Dingweibao
//
//  Created by LiQi on 2020/5/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeUsersAlertView: UIView {
    
    lazy var lbl1: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#E31C1C")
        l.font = .init(style: .regular, size: 12.uiX)
        l.text = "位置服务已禁用"
        return l
    }()
    
    lazy var lbl2: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#E31C1C")
        l.font = .init(style: .regular, size: 12.uiX)
        l.text = "请启用位置服务以保证定位宝正常工作"
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(lbl1)
        addSubview(lbl2)
        
        lbl1.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(10.uiX)
        }
        
        lbl2.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(lbl1.snp.bottom)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HomeUsersBtnView: UIView {
    
    lazy var contentView: UIView = {
        let l = UIView()
        l.shadowRadius = 10.uiX
        l.shadowOffset = .init(width: 0, height: 5.uiX)
        l.shadowColor = UIColor(hex: "#00C2A8")
        l.shadowOpacity = 0.44
        l.layer.cornerRadius = 23.uiX
        l.backgroundColor = .init(hex: "#27CBB3")
        return l
    }()
    
    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#FFFFFF")
        l.font = .init(style: .regular, size: 16.uiX)
        l.text = "通知我"
        return l
    }()
    
    lazy var descpLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#A0F0E2")
        l.font = .init(style: .regular, size: 10.uiX)
        l.text = "当Ta离开当前位置"
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(46.uiX)
            make.top.equalToSuperview().offset(20.uiX)
            make.bottom.equalToSuperview().offset(-5.uiX)
        }
        
        
        let stack = UIStackView(arrangedSubviews: [titleLbl, descpLbl], axis: .vertical, spacing: 0, alignment: .center, distribution: .equalSpacing)
        
        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HomeUsersLocationView: UIView {
    
    lazy var locationLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#222222")
        l.font = .init(style: .regular, size: 13.uiX)
        l.text = ""
        l.numberOfLines = 4
        return l
    }()
    
    lazy var timeLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#999999")
        l.font = .init(style: .regular, size: 12.uiX)
        l.text = "5分钟前"
        return l
    }()
    
    lazy var distanceLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#999999")
        l.font = .init(style: .regular, size: 12.uiX)
        l.text = ""
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(locationLbl)
        addSubview(timeLbl)
        addSubview(distanceLbl)
        
        locationLbl.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(10.uiX)
        }
        
        timeLbl.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.top.equalTo(locationLbl.snp.bottom).offset(8.uiX)
        }
        
        distanceLbl.snp.makeConstraints { make in
            make.left.equalTo(timeLbl.snp.right).offset(20.uiX)
            make.centerY.equalTo(timeLbl.snp.centerY)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HomeUsersView: UIView {

    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#222222")
        l.font = .init(style: .medium, size: 17.uiX)
        l.text = "我的家人"
        return l
    }()
    
    let infoBtn = UIButton()
    let stack = UIStackView()
    let locationView = HomeUsersLocationView()
    let btnView = HomeUsersBtnView()
    let alertView = HomeUsersAlertView()
    let loadingView = UIActivityIndicatorView(style: .whiteLarge)
    
    var collectionView: UICollectionView!
    
    let userListRelay = BehaviorRelay<[HomeUserItemCellViewModel]>(value: [])
    let userListStatus = BehaviorRelay<UserListStatus>(value: .hide)
    let currentSelectedUserId = BehaviorRelay<(String?, String?)>(value: (nil, nil))
    let itemSelected = PublishRelay<String?>()
//    let allSelected = PublishRelay<Void>()
    let addSelected = PublishRelay<Void>()
    
    var selectedDisposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        shadowRadius = 16.uiX
        shadowOffset = .init(width: 0, height: 11.uiX)
        shadowColor = UIColor(hex: "#363636")
        shadowOpacity = 0.24
        layer.cornerRadius = 10.uiX
        
        setupUI()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupUI() {
        
        stack.axis = .vertical
        
        let titleContentView = getTitleContentView()
        let userListView = getTitleUserListView()
        
        stack.addArrangedSubview(titleContentView)
        stack.addArrangedSubview(userListView)
        stack.addArrangedSubview(locationView)
        
        stack.addArrangedSubview(alertView)
        stack.addArrangedSubview(btnView)
        
        alertView.isHidden = true
        btnView.isHidden = true
//        locationView.isHidden = true
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
//
//            UIView.animate(withDuration: 0.25) {
//                locationView.isHidden = false
//                stack.layoutIfNeeded()
//            }
//        }
        
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 17.uiX, left: 25.uiX, bottom: 17.uiX, right: 25.uiX))
        }
        
        addSubview(loadingView)
        loadingView.color = .init(hex: "#27CBB3")
        loadingView.hidesWhenStopped = true
        loadingView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 50.uiX, height: 50.uiX))
            make.center.equalToSuperview()
        }
    }
    
    func getTitleContentView() -> UIView {
        let titleContentView = UIView()
        titleContentView.backgroundColor = .white
        
        titleContentView.addSubview(titleLbl)
        
        infoBtn.setBackgroundImage(UIImage.create("icon_gengduo"), for: .normal)
        titleContentView.addSubview(infoBtn)
        infoBtn.snp.makeConstraints { make in
            make.right.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 24.uiX, height: 24.uiX))
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalTo(infoBtn.snp.centerY)
            make.left.equalToSuperview()
            make.right.equalTo(infoBtn.snp.left).offset(-15.uiX)
        }
        
        titleContentView.snp.makeConstraints { make in
            make.height.equalTo(32.uiX)
        }
        return titleContentView
    }
    
    func getTitleUserListView() -> UIView {
        let listContentView = UIView()
        listContentView.backgroundColor = .random
        listContentView.snp.makeConstraints { make in
            make.height.equalTo(73.uiX)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 44.uiX, height: 73.uiX)
        layout.minimumLineSpacing = 15.uiX
        layout.minimumInteritemSpacing = 15.uiX
        layout.scrollDirection = .horizontal
//        layout.sectionInset = .init(top: 0, left: 15.uiX, bottom: 40.uiX, right: 15.uiX)
//        layout.headerReferenceSize = .init(width: 200, height: 70.uiX)
        collectionView = UICollectionView(frame: listContentView.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        listContentView.backgroundColor = .white
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        listContentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.register(cellType: HomeUserItemCell.self)
        
        return listContentView
    }
    
    // MARK: - Binding
    
    func setupBinding() {
        
        userListRelay.bind(to: collectionView.rx.items(cellIdentifier: HomeUserItemCell.reuseIdentifier, cellType: HomeUserItemCell.self)) { (row, element, cell) in
            cell.bind(to: element)
        }.disposed(by: rx.disposeBag)
        
        collectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            let items = self.userListRelay.value
            let item = items[indexPath.row]
            if item.type == .add {
                self.addSelected.accept(())
                return
            }
            if item.type == .all {
                self.itemSelected.accept(nil)
                return
            }
            self.itemSelected.accept(item.uniqueId.value)
        }).disposed(by: rx.disposeBag)
        
        currentSelectedUserId.subscribe(onNext: {[weak self] (userId, _) in
            guard let self = self else { return }
            self.selectedDisposeBag = DisposeBag()
            let items = self.userListRelay.value
            var selectedModel: HomeUserItemCellViewModel?
            items.forEach { item in
                if let userId = userId {
                    if item.uniqueId.value == userId {
                        item.isSelected.accept(true)
                        selectedModel = item
                    } else {
                        item.isSelected.accept(false)
                    }
                } else {
                    if item.type == .all {
                        item.isSelected.accept(true)
                        selectedModel = item
                    } else {
                        item.isSelected.accept(false)
                    }
                }
            }
            if let model = selectedModel {
                
                if model.type == .normal {
                    model.lastPosition.bind(to: self.locationView.locationLbl.rx.text).disposed(by: self.selectedDisposeBag)
                    model.lastTime.bind(to: self.locationView.timeLbl.rx.text).disposed(by: self.selectedDisposeBag)
                    model.distance.flatMap{ return Observable<String>.just("距离我\($0.string)km")}.bind(to: self.locationView.distanceLbl.rx.text).disposed(by: self.selectedDisposeBag)
                    let con = Observable.combineLatest(model.lastPositionAuth, model.isMe, model.isHidden)
                    con.bind { [weak self] (auth, isMe, isHidden) in
                        guard let self = self else { return }
                        switch (auth, isHidden) {
                        case (1, false):
                            self.alertView.isHidden = true
                            self.locationView.isHidden = false
                            if isMe {
                                self.locationView.distanceLbl.isHidden = true
                                self.btnView.isHidden = true
                            } else {
                                self.locationView.distanceLbl.isHidden = false
                                self.btnView.isHidden = false
                                self.btnView.titleLbl.text = "通知我"
                                self.btnView.descpLbl.isHidden = false
                                self.btnView.descpLbl.text = "当Ta离开当前位置"
                                self.btnView.contentView.rx.tap().subscribe(onNext: { _ in
                                    model.eventRelay.accept(.shareDistance)
                                }).disposed(by: self.selectedDisposeBag)
                            }
                        default:
                            self.alertView.isHidden = false
                            self.locationView.isHidden = true
                            self.btnView.isHidden = false
                            if isMe {
                                self.alertView.lbl1.text = "位置服务已禁用"
                                self.alertView.lbl2.text = "请启用位置服务以保证定位宝正常工作"
                                self.btnView.titleLbl.text = "启用位置服务"
                                self.btnView.descpLbl.isHidden = true
                                self.btnView.contentView.rx.tap().subscribe(onNext: { _ in
                                    model.eventRelay.accept(.goSetting)
                                }).disposed(by: self.selectedDisposeBag)
                            } else {
                                self.alertView.lbl1.text = "对方的位置服务已禁用"
                                self.alertView.lbl2.text = "请通知Ta启用位置服务以守护人身安全"
                                self.btnView.titleLbl.text = "发送请求"
                                self.btnView.descpLbl.isHidden = true
                                self.btnView.contentView.rx.tap().subscribe(onNext: { _ in
                                    model.eventRelay.accept(.sharePosition)
                                }).disposed(by: self.selectedDisposeBag)
                            }
                        }
                    }.disposed(by: self.selectedDisposeBag)
                } else if model.type == .all {
                    self.locationView.isHidden = true
                    self.btnView.isHidden = true
                    self.alertView.isHidden = true
                }
                
            }
            
        }).disposed(by: rx.disposeBag)
        
        userListStatus.bind { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .hide:
                self.isHidden = true
            case .loading:
                self.isHidden = false
                self.stack.isHidden = true
                self.loadingView.startAnimating()
            case .normal:
                self.isHidden = false
                self.stack.isHidden = false
                self.loadingView.stopAnimating()
            }
        }.disposed(by: rx.disposeBag)
    }

}
