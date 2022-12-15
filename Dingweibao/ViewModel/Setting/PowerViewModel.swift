//
//  PowerViewModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/8.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

class PowerViewModel: ViewModel, ViewModelType {
    
    private let showVip = PublishRelay<Void>()
    
    struct Input {
        var request: Observable<Void>
    }
    
    struct Output {
        var items: BehaviorRelay<[PowerCellViewModel]>
        let showErrorView: BehaviorRelay<Bool>
        let showEmptyView: BehaviorRelay<Bool>
        let showVip: PublishRelay<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let items = BehaviorRelay<[PowerCellViewModel]>(value: [])
        let showErrorView = BehaviorRelay<Bool>(value: false)
        let showEmptyView = BehaviorRelay<Bool>(value: false)
        
        input.request.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            showErrorView.accept(false)
            showEmptyView.accept(false)
            self.requestList().subscribe(onNext: { list in
                items.accept(list)
                showEmptyView.accept(list.count == 0)
            }, onError: { _ in
                showErrorView.accept(true)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)

        return Output(items: items, showErrorView: showErrorView, showEmptyView: showEmptyView, showVip: showVip)
    }
    
    // MARK: - Request
    
    /// MARK: - Request
    
    func requestList() -> Observable<[PowerCellViewModel]> {
        
        return NetManager.requestObjArray(.powerList, type: PowerModel.self).asObservable().mapMany({ m in
            let vm = PowerCellViewModel(model: m)
            vm.remindEvent.subscribe(onNext: { [weak vm, weak self] isRemind in
                guard let self = self else { return }
                guard let vm = vm else { return }
                guard let vip = UserManager.shared.login.value.0?.isVip, vip else {
                    self.showVip.accept(())
                    vm.isRemind.accept(vm.isRemind.value)
                    return
                }
                self.requestSetPower(userId: vm.id.value).subscribe(onNext: { _ in
                    vm.isRemind.accept(!vm.isRemind.value)
                }, onError: { _ in
                    vm.isRemind.accept(vm.isRemind.value)
                }).disposed(by: self.rx.disposeBag)
            }).disposed(by: self.rx.disposeBag)
            return vm
        }).trackError(error).trackActivity(loading)
    }
    
    func requestSetPower(userId: String) -> Observable<Void> {
        
        return NetManager.requestResponse(.powerSet(userId: userId)).asObservable().trackError(error).trackActivity(loading)
        
    }
    
    
}
