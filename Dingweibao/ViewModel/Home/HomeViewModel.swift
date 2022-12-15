//
//  HomeViewModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/5/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import SwiftyJSON
import RxSwiftExt

enum UserListStatus {
    case hide
    case loading
    case normal
}

class HomeViewModel: ViewModel, ViewModelType {
    
    private var disposeBag = DisposeBag()
    private var userDisposeBag = DisposeBag()
    private let hudTextRelay = PublishRelay<String>()
    private let vipRelay = PublishRelay<Void>()
    
    struct Input {
        let requestCircleList: Observable<Void>
        let requestUserList: Observable<CircleListCellViewModel?>
        let removeCircle: Observable<CircleListCellViewModel>
        let addCircle: Observable<CircleListCellViewModel>
        let requestCurrentUserList: Observable<Void>
    }
    
    struct Output {
        let circleList: BehaviorRelay<[CircleListCellViewModel]>
        let userList: BehaviorRelay<[HomeUserItemCellViewModel]>
        let userListStatus: BehaviorRelay<UserListStatus>
        let currentCircle: PublishRelay<CircleListCellViewModel>
        let hudTextRelay: PublishRelay<String>
        let vipRelay: PublishRelay<Void>
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    func transform(input: Input) -> Output {
        
        let circleList = BehaviorRelay<[CircleListCellViewModel]>(value: [])
        let userList = BehaviorRelay<[HomeUserItemCellViewModel]>(value: [])
        let currentCircle = PublishRelay<CircleListCellViewModel>()
        let userListStatus = BehaviorRelay<UserListStatus>(value: .hide)
        let removeCircle = PublishRelay<CircleListCellViewModel>()
        
        let requestUserList = PublishRelay<CircleListCellViewModel?>()
        
//        .asObservable()
        ReachabilityManager.shared.relay.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.requestCircleList().subscribe(onNext: { list in
                circleList.accept(list)
                let current = list.filter { $0.isChecked.value }.first
                if let c = current {
                    requestUserList.accept(c)
                } else if let c = list.first {
                    c.isChecked.accept(true)
                    requestUserList.accept(c)
                }
            }, onError: { error in
                
            }).disposed(by: self.rx.disposeBag)
            
        }).disposed(by: rx.disposeBag)
        
        Observable.merge(input.removeCircle, removeCircle.asObservable()).subscribe(onNext: { circle in
            
            var items = circleList.value
            items.removeAll { obj -> Bool in
                return (obj.id == circle.id)
            }
            items.forEach{$0.isChecked.accept(false)}
            circleList.accept(items)
    
            items.first?.isChecked.accept(true)
            requestUserList.accept(items.first)
            
        }).disposed(by: rx.disposeBag)
        
        input.addCircle.subscribe(onNext: { circle in
            
            var items = circleList.value
            // 是否已经存在
            if !(items.filter({ $0.id == circle.id }).isEmpty) {
                return
            }
            
            items.insert(circle, at: 0)
            items.forEach{$0.isChecked.accept(false)}
            circleList.accept(items)
            
            items.first?.isChecked.accept(true)
            requestUserList.accept(items.first)
            
        }).disposed(by: rx.disposeBag)
        
        let userListObserver = Observable.merge(input.requestUserList, requestUserList.asObservable())
        
        let requestCurrentUserList = input.requestCurrentUserList
        
        userListObserver.subscribe(onNext: {[weak self] circleModel in
            guard let self = self else { return }
            guard let circleModel = circleModel else {
                userListStatus.accept(.hide)
                return
            }
            currentCircle.accept(circleModel)
            userListStatus.accept(.loading)
            self.disposeBag = DisposeBag()
            self.requestSelect(circleId: circleModel.encodeId).subscribe(onNext: { _ in
                
            }).disposed(by: self.disposeBag)
            
            let merge = Observable.merge(Observable<Int>.interval(.seconds(10), scheduler: MainScheduler.instance).startWith(0), requestCurrentUserList.flatMap{ Observable.just(0) })
            merge.subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.userDisposeBag = DisposeBag()
                self.requestUserList(circleId: circleModel.encodeId).subscribe(onNext: { listModel in
                    if let cM = listModel?.circle {
                        circleModel.avatar.accept(cM.avatar)
                        circleModel.name.accept(cM.name)
                        circleModel.userCount.accept(cM.userCount)
                    }
                    let list = listModel?.users ?? []
                    userListStatus.accept(.normal)
                    let all = HomeUserItemCellViewModel(model: nil, type: .all)
                    let add = HomeUserItemCellViewModel(model: nil, type: .add)
                    var newList = [all]
                    newList.append(contentsOf: list.map{ self.getCellViewModel(with: $0, circleId: circleModel.encodeId) })
                    newList.append(add)
                    userList.accept(newList)
                    circleModel.userCount.accept(list.count)
                }, onError: { error in
                    if let e = error as? NetError {
                        switch e {
                        case let .error(code: code, msg: msg):
                            if code == 1 { //退出群组
                                removeCircle.accept(circleModel)
                                self.hudTextRelay.accept(msg)
                            }
                        }
                    }
                }).disposed(by: self.userDisposeBag)
            }).disposed(by: self.disposeBag)
            
        }).disposed(by: rx.disposeBag)
        
        return Output(circleList: circleList,
                      userList: userList,
                      userListStatus: userListStatus,
                      currentCircle: currentCircle,
                      hudTextRelay: hudTextRelay,
                      vipRelay: vipRelay)
    }
    
    // MARK: - Tool
    
    func getCellViewModel(with model: HomeUserListModel, circleId: String) -> HomeUserItemCellViewModel {
        let cellViewModel = HomeUserItemCellViewModel(model: model)
        let userId = model.id ?? ""
        cellViewModel.eventRelay.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            switch type {
            case .goSetting:
                if let URL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(URL)
                }
            case .shareDistance:
                guard let vip = UserManager.shared.login.value.0?.isVip, vip else {
                    self.vipRelay.accept(())
                    return
                }
                self.requestShareDistance(circleId: circleId, userId: userId).subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.hudTextRelay.accept("提醒通知设置成功")
                }).disposed(by: self.disposeBag)
            case .sharePosition:
                self.requestSharePosition(circleId: circleId, userId: userId).subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.hudTextRelay.accept("发送请求成功")
                }).disposed(by: self.disposeBag)
            }
        }).disposed(by: self.userDisposeBag)
        
        return cellViewModel
    }
    
    // MARK: - Request
    
    func requestCircleList() -> Observable<[CircleListCellViewModel]> {
        return NetManager.requestObjArray(.circleList, type: CircleListModel.self).asObservable().mapMany { list in
            return CircleListCellViewModel(model: list)
        }
    }
    
    func requestUserList(circleId: String) -> Observable<HomeUserModel?> {
        return NetManager.requestObj(.homeUserList(circleId: circleId), type: HomeUserModel.self).asObservable()
    }
    
    func requestSelect(circleId: String) -> Observable<Void> {
        return NetManager.requestResponse(.selectCircle(id: circleId)).asObservable()
    }
    
    func requestSharePosition(circleId: String, userId: String) -> Observable<Void> {
        return NetManager.requestResponse(.sharePosition(circleId: circleId, userId: userId)).asObservable().trackActivity(loading).trackError(error)
    }
    
    func requestShareDistance(circleId: String, userId: String) -> Observable<Void> {
        return NetManager.requestResponse(.shareDistance(circleId: circleId, userId: userId)).asObservable().trackActivity(loading).trackError(error)
    }
    
}
