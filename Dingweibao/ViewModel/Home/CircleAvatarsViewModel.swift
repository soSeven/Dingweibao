//
//  CircleAvatarsViewModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class CircleAvatarsViewModel: ViewModel, ViewModelType {
    
    struct Input {
        var request: Observable<Void>
    }
    
    struct Output {
        var items: BehaviorRelay<[SectionModel<String, CircleAvatarModel>]>
    }
    
    func transform(input: Input) -> Output {
        
        let items = BehaviorRelay<[SectionModel<String, CircleAvatarModel>]>(value: [])
        
        input.request.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.requestList().subscribe(onNext: { lists in
                let sections = lists.map { SectionModel<String, CircleAvatarModel>(model: $0.name, items: $0.avatars) }
                items.accept(sections)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        return Output(items: items)
    }
    
    // MARK: - Request
    
    func requestList() -> Observable<[CircleAvatarSectionModel]> {
        return NetManager.requestObjArray(.getCircleAvatars, type: CircleAvatarSectionModel.self).trackError(error).trackActivity(loading).asObservable()
    }
    
    
}
