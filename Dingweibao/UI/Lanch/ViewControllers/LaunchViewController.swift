//
//  LaunchViewController.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/10.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import Alamofire

protocol LaunchViewControllerDelegate: AnyObject {
    func launchShowProtocol(controller: LaunchViewController, type: Int)
    func launchDimiss(controller: LaunchViewController)
}

class LaunchViewController: ViewController {
    
    var delegate: LaunchViewControllerDelegate?
    
    lazy var bgView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.alpha(0.6)
        return v
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        hbd_barHidden = true
        
        let launchVc = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        if let v = launchVc?.view {
            view.addSubview(v)
            v.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let alert = LaunchProtocolView()
        alert.protocolEvent = {[weak self] type in
            guard let self = self else { return }
            self.delegate?.launchShowProtocol(controller: self, type: type)
        }
        alert.rightBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.launchDimiss(controller: self)
        }).disposed(by: rx.disposeBag)
        alert.leftBtn.rx.tap.subscribe(onNext: { _ in
            exit(0)
        }).disposed(by: rx.disposeBag)
        view.addSubview(alert)
        alert.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(290.uiX)
        }
        
//        ReachabilityManager.shared.relay.subscribe(onNext: { status in
////            switch status {
////            case .notReachable:
//                let message = MessageAlert()
//                message.titleLbl.text = "温馨提示"
//                message.msgLbl.text = "是否确定退出登录？"
//                message.show()
//                message.rightBtn.rx.tap.subscribe(onNext: { _ in
//
//                }).disposed(by: self.rx.disposeBag)
////            default:
////                break
////            }
//        }).disposed(by: rx.disposeBag)
    }

}
