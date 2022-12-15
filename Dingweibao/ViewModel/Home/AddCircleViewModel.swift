//
//  AddCircleViewModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum AddCircleStatus: Int {
    case input
    case loading
    case complete
}

class AddCircleViewModel: ViewModel, ViewModelType {
    
    struct Input {
        var addCircle: Observable<(String?, String?, String?)>
    }
    
    struct Output {
        var item: PublishRelay<CircleListCellViewModel>
        var status: BehaviorRelay<AddCircleStatus>
        var msgError: PublishRelay<String>
    }
    
    func transform(input: Input) -> Output {
        
        let item = PublishRelay<CircleListCellViewModel>()
        let status = BehaviorRelay<AddCircleStatus>(value: .input)
        let msgError = PublishRelay<String>()
        
        input.addCircle.subscribe(onNext: { [weak self] (id, encodeId, userId)  in
            guard let self = self else { return }
            guard let id = id, !id.isEmpty else {
                status.accept(.input)
                msgError.accept("请输入群号")
                return
            }
            status.accept(.loading)
            self.requestAddCircle(id: id, encodeId: encodeId, userId: userId).subscribe(onNext: { model in
                if let m = model {
                    switch (m.joinAuth, m.isInvited){
                    case (3, false):
                        msgError.accept("该群组拒绝加入")
                        status.accept(.input)
                    case (1, false):
                        status.accept(.complete)
                    default:
                        item.accept(CircleListCellViewModel(model: m))
                        status.accept(.complete)
                    }
                    
                } else {
                    msgError.accept("加入失败")
                    status.accept(.input)
                }
            }, onError: { error in
                status.accept(.input)
                if let e = error as? NetError {
                    switch e {
                    case let .error(code: _, msg: msg):
                        msgError.accept(msg)
                    }
                    return
                }
                msgError.accept("加入失败")
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        return Output(item: item, status: status, msgError: msgError)
    }
    
    // MARK: - Request
    
    func requestAddCircle(id: String, encodeId: String?, userId: String?) -> Observable<CircleListModel?> {
        
        return NetManager.requestObj(.addToCircle(id: id, encodeId: encodeId, userId: userId), type: CircleListModel.self).trackError(error).trackActivity(loading).asObservable()
        
    }
    
    
}
