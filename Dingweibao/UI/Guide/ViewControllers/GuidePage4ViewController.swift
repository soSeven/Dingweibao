//
//  GuidePage4ViewController.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/10.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

protocol GuidePage4ViewControllerDelegate: AnyObject {
    func page4ShowNext(controller: GuidePage4ViewController)
}

class GuidePage4ViewController: ViewController {
    
    weak var delegate: GuidePage4ViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hbd_barHidden = true
        hbd_backInteractive = false
        
        let page4 = GuidePageView()
        page4.lbl.text = "模拟真实来电"
        page4.imgView.image = UIImage.create("guidepage_bg4")
        page4.btn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.page4ShowNext(controller: self)
        }).disposed(by: rx.disposeBag)
        view.addSubview(page4)
        page4.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    

}
