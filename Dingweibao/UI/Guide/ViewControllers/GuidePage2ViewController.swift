//
//  GuidePage2ViewController.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/10.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

protocol GuidePage2ViewControllerDelegate: AnyObject {
    func page2ShowNext(controller: GuidePage2ViewController)
}

class GuidePage2ViewController: ViewController {
    
    weak var delegate: GuidePage2ViewControllerDelegate?
    
    let page2 = GuidePageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        hbd_barHidden = true
        hbd_backInteractive = false
        
        page2.lbl.text = "获取智能通知"
        page2.imgView.image = UIImage.create("guidepage_bg2")
        page2.btn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.page2ShowNext(controller: self)
        }).disposed(by: rx.disposeBag)
        view.addSubview(page2)
        page2.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func onceWhenViewDidAppear(_ animated: Bool) {
        
        page2.showPushImgView()
        
        let alert = AlertViewController(title: "\"定位宝\"想给您发通知", message: "\"通知\"可能包括提醒、声音和图标标记。这些可在\"设置中配置\"", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "不允许", style: .default) { a in
            LibsManager.shared.registerUMPush()
        }
        let action2 = UIAlertAction(title: "允许", style: .default) { a in
            LibsManager.shared.registerUMPush()
        }
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
        
    }

}
