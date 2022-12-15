//
//  OtherUserViewModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/2.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

enum OtherUserType {
    case avator(title: String, info: CircleOtherModel)
    case name(title: String, info: CircleOtherModel)
    case otherName(title: String, info: CircleOtherModel)
    case phone(title: String, info: CircleOtherModel)
    case location(title: String, info: CircleOtherModel)
}

class OtherUserViewModel: ViewModel, ViewModelType {
    
    var id: String
    private var userId: String
    
    private var location = PublishRelay<Bool>()
    
    struct Input {
        let request: Observable<Void>
        let requestRemove: Observable<Void>
    }
    
    struct Output {
        let items: PublishRelay<[SectionModel<String, OtherUserType>]>
        let dataItem: PublishRelay<CircleOtherModel>
        let removeSuccess: PublishRelay<String>
    }
    
    required init(id: String, userId: String) {
        self.id = id
        self.userId = userId
    }
    
    func transform(input: Input) -> Output {
        
        let items = PublishRelay<[SectionModel<String, OtherUserType>]>()
        let dataItem = PublishRelay<CircleOtherModel>()
        let mLocation = PublishRelay<Bool>()
        let removeSuccess = PublishRelay<String>()
        
        input.request.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.requestInfo().subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                if let m = model {
                    m.hideEvent.subscribe(onNext: {[weak self] status in
                        guard let self = self else { return }
                        self.location.accept(status)
                    }).disposed(by: self.rx.disposeBag)
                    mLocation.bind(to: m.isHide).disposed(by: self.rx.disposeBag)
                    let section = self.getSectionModel(data: m)
                    items.accept(section)
                    dataItem.accept(m)
                }
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        location.subscribe(onNext: { [weak self] status in
            guard let self = self else { return }
            self.requestHideLocation(status: status).subscribe(onNext: { _ in
                mLocation.accept(status)
            }, onError: { _ in
                mLocation.accept(!status)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        input.requestRemove.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.requestRemoveUser().subscribe(onNext: { _ in
                removeSuccess.accept("移出成功")
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        return Output(items: items, dataItem: dataItem, removeSuccess: removeSuccess)
    }
    
    /// MARK: - Request
    
    func getSectionModel(data: CircleOtherModel) -> [SectionModel<String, OtherUserType>] {
        
        let g1: OtherUserType = .avator(title: "头像", info: data)
        let g2: OtherUserType = .name(title: "姓名", info: data)
        let g3: OtherUserType = .otherName(title: "备注", info: data)
        let g4: OtherUserType = .phone(title: "手机号", info: data)
        
        let section1 = SectionModel<String, OtherUserType>(model: "个人资料", items: [g1, g2, g3, g4])
        
        let g5: OtherUserType = .location(title: "对其隐藏位置", info: data)
        let section2 = SectionModel<String, OtherUserType>(model: "个人资料", items: [g5])
        
        return [section1, section2]
    }
    
    /// MARK: - Request
    
    func requestInfo() -> Observable<CircleOtherModel?> {
        
        return NetManager.requestObj(.circleUserInfo(id: id, userId: userId), type: CircleOtherModel.self).asObservable().trackError(error).trackActivity(loading)
    }
    
    func requestHideLocation(status: Bool) -> Observable<Void> {
        let value = status ? "open" : "close"
        return NetManager.requestResponse(.circleOtherHideLocation(id: id, userId: userId, value: value)).asObservable().trackError(error).trackActivity(loading)
    }
    
    func requestRemoveUser() -> Observable<Void> {
        
        return NetManager.requestResponse(.circleOtherUserRemove(id: id, userId: userId)).asObservable().trackError(error).trackActivity(loading)
    }
    
}
