//
//  MyViewModel.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/8.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

enum MyCellType {
    case avator(title: String, info: UserModel)
    case name(title: String, info: UserModel)
    case phone(title: String, info: UserModel)
}

class MyViewModel: ViewModel, ViewModelType {
    
    
    private var location = PublishRelay<Bool>()
    
    struct Input {
        let request: Observable<Void>
        let requestRemove: Observable<Void>
        let saveImage: Observable<UIImage>
    }
    
    struct Output {
        let items: BehaviorRelay<[SectionModel<String, MyCellType>]>
        let showSuccess: PublishRelay<String>
    }
    
    func transform(input: Input) -> Output {
        
        let items = BehaviorRelay<[SectionModel<String, MyCellType>]>(value: [])
        let showSuccess = PublishRelay<String>()
        
        UserManager.shared.login.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let section = self.getSectionModel()
            items.accept(section)
        }).disposed(by: rx.disposeBag)
        
        input.request.subscribe(onNext: { _ in
            UserManager.shared.updateUser()
        }).disposed(by: rx.disposeBag)
        
        input.requestRemove.subscribe(onNext: { _ in
            UserManager.shared.login.accept((nil, .loginOut))
        }).disposed(by: rx.disposeBag)
        
        input.saveImage.subscribe(onNext: {[weak self] image in
            guard let self = self else { return }
            self.requestUpload(image: image).subscribe(onNext: { value in
                showSuccess.accept("修改成功")
                guard let user = UserManager.shared.login.value.0 else { return }
                user.avatar = value
                UserManager.shared.login.accept((user, .change))
            }, onError: { error in

            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        return Output(items: items, showSuccess: showSuccess)
    }
    
    /// MARK: - Request
    
    func getSectionModel() -> [SectionModel<String, MyCellType>] {
        
        guard let user = UserManager.shared.login.value.0 else {
            return []
        }
        
        let g1: MyCellType = .avator(title: "头像", info: user)
        let g2: MyCellType = .name(title: "姓名", info: user)
        let g3: MyCellType = .phone(title: "手机号", info: user)
        
        return [SectionModel<String, MyCellType>(model: "用户信息", items: [g1, g2, g3])]
    }
    
    func requestUpload(image: UIImage) -> Observable<String> {

        return NetManager.requestResponseObj(.upImage(image: image, dirName: "avatar")).flatMap { rep  -> Single<String> in
            let url = rep.data?.stringValue ?? ""
            return NetManager.requestResponse(.changeUserInfo(type: .avatar, value: url)).flatMap { _ in
                return Single.just(url)
            }
        }.asObservable().trackError(error).trackActivity(loading)

    }
    
}
