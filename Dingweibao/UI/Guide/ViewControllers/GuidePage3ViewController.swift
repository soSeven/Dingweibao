//
//  GuidePage3ViewController.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/10.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

protocol GuidePage3ViewControllerDelegate: AnyObject {
    func page3ShowNext(controller: GuidePage3ViewController)
}

class GuidePage3ViewController: ViewController {
    
    weak var delegate: GuidePage3ViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        hbd_barHidden = true
        hbd_backInteractive = false
        
        let page3 = GuidePageView()
        page3.lbl.text = "卫星实景地图"
        page3.imgView.image = UIImage.create("guidepage_bg3")
        page3.btn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.page3ShowNext(controller: self)
        }).disposed(by: rx.disposeBag)
        view.addSubview(page3)
        page3.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func onceWhenViewDidAppear(_ animated: Bool) {
        
        let alert = AlertViewController(title: "允许\"定位宝\"访问您的位置？", message: "定位宝将在家人定位和求助中使用您的位置信息，以确保您和家人的安全", preferredStyle: .alert)
        alert.type = .btn1
        let action1 = UIAlertAction(title: "使用App时允许", style: .default) { a in
            LocationAuthManager.shared.request()
        }
        let action2 = UIAlertAction(title: "允许一次", style: .default) { a in
            LocationAuthManager.shared.request()
        }
        let action3 = UIAlertAction(title: "不允许", style: .default) { a in
            LocationAuthManager.shared.request()
        }
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        present(alert, animated: true, completion: nil)
        
    }
    

}
