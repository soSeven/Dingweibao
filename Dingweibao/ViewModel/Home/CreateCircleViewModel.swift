//
//  CreateCircleViewModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum CreateCircleStatus: Int {
    case input
    case loading
    case complete
}

class CreateCircleViewModel: ViewModel, ViewModelType {
    
    struct Input {
        var addCircle: Observable<(String?, String?)>
    }
    
    struct Output {
        var item: PublishRelay<CircleListCellViewModel>
        var status: BehaviorRelay<CreateCircleStatus>
        var msgError: PublishRelay<String>
    }
    
    func transform(input: Input) -> Output {
        
        let item = PublishRelay<CircleListCellViewModel>()
        let status = BehaviorRelay<CreateCircleStatus>(value: .input)
        let msgError = PublishRelay<String>()
        
        input.addCircle.subscribe(onNext: { [weak self] (name, avatar) in
            guard let self = self else { return }
            guard let name = name, !name.isEmpty else {
                status.accept(.input)
                msgError.accept("请填写群组名称")
                return
            }
            guard let avatar = avatar else {
                status.accept(.input)
                msgError.accept("请选择图标")
                return
            }
            let match = "(^[\u{4e00}-\u{9fa5}]+$)"
            let pre = NSPredicate(format: "SELF matches %@", match)
            if pre.evaluate(with: name) {
                if name.count > 8 {
                    msgError.accept("群组名称最多8个汉字")
                    return
                }
            } else {
                if name.count > 16 {
                    msgError.accept("群组名称最多16个字母")
                    return
                }
            }
            status.accept(.loading)
            self.requestCreateCircle(name: name, avatar: avatar).subscribe(onNext: { model in
                if let m = model {
                    item.accept(CircleListCellViewModel(model: m))
                    status.accept(.complete)
                } else {
                    status.accept(.input)
                    msgError.accept("创建失败")
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
                msgError.accept("创建失败")
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        return Output(item: item, status: status, msgError: msgError)
    }
    
    // MARK: - Request
    
    func requestCreateCircle(name: String, avatar: String) -> Observable<CircleListModel?> {
        
        return NetManager.requestObj(.createCircle(name: name, avatar: avatar), type: CircleListModel.self).trackError(error).trackActivity(loading).asObservable()
        
    }
    
    
}
