//
//  CircleInfoViewModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/1.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

enum CircleInfoType {
    case avator(title: String, info: CircleInfoModel, isCreated: Bool)
    case groupNumber(title: String, info: CircleInfoModel, isCreated: Bool)
    case groupName(title: String, info: CircleInfoModel, isCreated: Bool)
    case groupAuth(title: String, info: CircleInfoModel, isCreated: Bool)
    case user(user: CircleUserModel)
}

class CircleInfoViewModel: ViewModel, ViewModelType {
    
    var id: String
    
    struct Input {
        let request: Observable<Void>
        let requestChange: PublishRelay<(type: CircleInfoChangeType, value: String)>
        let removeCircle: Driver<Void>
    }
    
    struct Output {
        let dataItem: PublishRelay<CircleDataModel>
        let items: PublishRelay<[SectionModel<String, CircleInfoType>]>
        let showErrorView: BehaviorRelay<Bool>
        let showEmptyView: BehaviorRelay<Bool>
        let removeSuccess: PublishRelay<String>
    }
    
    required init(id: String) {
        self.id = id
        super.init()
    }
    
    func transform(input: Input) -> Output {
        
        let dataItem = PublishRelay<CircleDataModel>()
        let item = PublishRelay<[SectionModel<String, CircleInfoType>]>()
        let showErrorView = BehaviorRelay<Bool>(value: false)
        let showEmptyView = BehaviorRelay<Bool>(value: false)
        
        let changeNeedRequest = PublishRelay<Void>()
        
        let removeSuccess = PublishRelay<String>()
        
        let rq = Observable.merge(input.request, changeNeedRequest.asObservable())
        
        rq.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            showErrorView.accept(false)
            self.requestDetail().subscribe(onNext: { [weak self] detail in
                guard let self = self else { return }
                if let d = detail {
                    let sections = self.getSectionModel(data: d)
                    item.accept(sections)
                    dataItem.accept(d)
                } else {
                    showEmptyView.accept(true)
                }
            }, onError: { error in
                showErrorView.accept(true)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        input.requestChange.subscribe(onNext: { [weak self] (type, value) in
            guard let self = self else { return }
            self.requestChange(type: type, value: value).subscribe(onNext: { _ in
                changeNeedRequest.accept(())
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: self.rx.disposeBag)
        
        input.removeCircle.drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.requestRemove().subscribe(onNext: { _ in
                removeSuccess.accept("操作成功")
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: self.rx.disposeBag)
        
        return Output(dataItem: dataItem,
                      items: item,
                      showErrorView: showErrorView,
                      showEmptyView: showEmptyView,
                      removeSuccess: removeSuccess)
    }
    
    /// MARK: - Request
    
    func getSectionModel(data: CircleDataModel) -> [SectionModel<String, CircleInfoType>] {
        
        let g1: CircleInfoType = .avator(title: "群组图标", info: data.info, isCreated: data.isCreater)
        let g2: CircleInfoType = .groupNumber(title: "群号", info: data.info, isCreated: data.isCreater)
        let g3: CircleInfoType = .groupName(title: "群名称", info: data.info, isCreated: data.isCreater)
        let g4: CircleInfoType = .groupAuth(title: "加群权限", info: data.info, isCreated: data.isCreater)
        
        let section1 = SectionModel<String, CircleInfoType>(model: "群组资料", items: [g1, g2, g3, g4])
        
        let items = data.users.map { m -> CircleInfoType in
            return .user(user: m)
        }
        
        let section2 = SectionModel<String, CircleInfoType>(model: "群组成员", items: items)
        
        return [section1, section2]
        
    }
    
    /// MARK: - Request
    
    func requestDetail() -> Observable<CircleDataModel?> {
        return NetManager.requestObj(.circleInfo(id: id), type: CircleDataModel.self).trackActivity(loading).trackError(error)
    }
    
    func requestChange(type: CircleInfoChangeType, value: String) -> Observable<Void> {
        return NetManager.requestResponse(.circleEdit(id: id, type: type, value: value)).trackActivity(loading).trackError(error)
    }
    
    func requestRemove() -> Observable<Void> {
        return NetManager.requestResponse(.removeCircle(id: id)).trackActivity(loading).trackError(error)
    }
    
}
