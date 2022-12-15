//
//  PushManager.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/12.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftEntryKit
import SwiftyJSON

enum PushEventType {
    case push(content: UNNotificationContent)
    case invite(inviteSrt: String)
}

class PushManager {
    
    static let shared = PushManager()
    
    var eventArray = [PushEventType]()
    var currentEvent: PushEventType?
    
    let disposeBag = DisposeBag()
    
    let addPushInfo = PublishRelay<UNNotificationContent>()
    var addCircle: PublishSubject<CircleListCellViewModel>?
    let showViewRelay = BehaviorRelay<Void>(value: ())
    
    init() {
        addPushInfo.subscribe(onNext: { [weak self] content in
            guard let self = self else { return }
            if !UserManager.shared.isLogin {
                return
            }
            self.eventArray.append(.push(content: content))
            self.showViewRelay.accept(())
        }).disposed(by: disposeBag)
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] no in
            guard let self = self else { return }
            guard let pasteStr = UIPasteboard.general.string else { return }
            let invite = pasteStr.components(separatedBy: "----")
            if invite.count != 4 {
                return
            }
            UIPasteboard.general.string = ""
            self.eventArray.append(.invite(inviteSrt: pasteStr))
            self.showViewRelay.accept(())
        }
    }
    
    func show() {
        
        if let _ = currentEvent {
            return
        }
        if  eventArray.isEmpty {
            return
        }
        let first = eventArray.removeFirst()
        currentEvent = first
        switch first {
        case let .push(content):
            showAlertWhenPush(content: content)
        case let .invite(inviteSrt):
            showAlertWhenInvite(inviteSrt: inviteSrt)
        }
    }
    
    func showAlertWhenInvite(inviteSrt: String) {
        let invite = inviteSrt.components(separatedBy: "----")
        if invite.count != 4 {
            self.currentEvent = nil
            self.showViewRelay.accept(())
            return
        }
        
        let inviteView = AddCircleAlertView(id: invite[1], encodeId: invite[2], userId: invite[3], dimiss: { [weak self] in
            guard let self = self else { return }
            self.currentEvent = nil
            self.showViewRelay.accept(())
        })
        inviteView.show()
        
    }
    
    func showAlertWhenPush(content: UNNotificationContent) {
        
        let userInfo = content.userInfo
        
        guard let type = userInfo["type"] as? Int else {
            self.currentEvent = nil
            self.showViewRelay.accept(())
            return
        }
        
        switch type {
        case 1: // 用户申请加入群组
            let message = MessageAddAlert()
            let nickname = userInfo["nickname"] as? String ?? ""
            let mobile = userInfo["mobile"] as? String ?? ""
            let avatar = userInfo["avatar"] as? String ?? ""
            let text = userInfo["des"] as? String ?? ""
            let applyId = userInfo["apply_id"] as? String ?? ""
            message.titleLbl.text = nickname
            message.phonelbl.text = mobile
            message.msgLbl.text = text
            message.imgView.kf.setImage(with: URL(string: avatar), placeholder: UIImage.create("my_pic_headportrait"))
            message.show()
            message.rightBtn.rx.tap.subscribe(onNext: { _ in
                NetManager.requestResponse(.addAgree(applyId: applyId)).subscribe(onSuccess: { _ in
                    
                }).disposed(by: self.disposeBag)
                SwiftEntryKit.dismiss(.displayed) {
                    self.currentEvent = nil
                    self.showViewRelay.accept(())
                }
            }).disposed(by: self.disposeBag)
            message.leftBtn.rx.tap.subscribe(onNext: { _ in
                NetManager.requestResponse(.addIgnore(applyId: applyId)).subscribe(onSuccess: { _ in
                    
                }).disposed(by: self.disposeBag)
                SwiftEntryKit.dismiss(.displayed) {
                    self.currentEvent = nil
                    self.showViewRelay.accept(())
                }
            }).disposed(by: self.disposeBag)
        case 2: // 群主同意申请，新用户加入群组
            let json = JSON(userInfo)
            let model = CircleListModel(json: json)
            let message = MessageDecideAlert()
            let title = userInfo["title"] as? String ?? ""
            let text = userInfo["text"] as? String ?? ""
            message.titleLbl.text = title
            message.msgLbl.text = text
            message.show()
            message.rightBtn.rx.tap.subscribe(onNext: { _ in
                SwiftEntryKit.dismiss(.displayed) {
                    self.currentEvent = nil
                    self.showViewRelay.accept(())
                }
            }).disposed(by: self.disposeBag)
            self.addCircle?.onNext(CircleListCellViewModel(model: model))
        default:
            let message = MessageDecideAlert()
            let title = userInfo["title"] as? String ?? ""
            let text = userInfo["text"] as? String ?? ""
            message.titleLbl.text = title
            message.msgLbl.text = text
            message.show()
            message.rightBtn.rx.tap.subscribe(onNext: { _ in
                SwiftEntryKit.dismiss(.displayed) {
                    self.currentEvent = nil
                    self.showViewRelay.accept(())
                }
            }).disposed(by: self.disposeBag)
        }
    }
}
