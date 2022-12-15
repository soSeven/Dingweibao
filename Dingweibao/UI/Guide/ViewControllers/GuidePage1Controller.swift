//
//  GuidePage1Controller.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/10.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

protocol GuidePage1ViewControllerDelegate: AnyObject {
    func page1ShowNext(controller: GuidePage1Controller)
}

class GuidePage1Controller: ViewController {
    
    weak var delegate: GuidePage1ViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        hbd_barHidden = true
        hbd_backInteractive = false
        
        let page1 = GuidePageView()
        page1.lbl.text = "实时定位追踪"
        page1.imgView.image = UIImage.create("guidepage_bg1")
        page1.btn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.page1ShowNext(controller: self)
        }).disposed(by: rx.disposeBag)
        view.addSubview(page1)
        page1.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    

}
