//
//  AlertViewController.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/10.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum AlertViewShowType {
    case btn1
    case btn2
}

class AlertViewController: UIAlertController {
    
    var btnView1: UIView?
    var btnView2: UIView?
    
    var type: AlertViewShowType = .btn2
    var isShow = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable<Int>.interval(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            switch self.type {
            case .btn1:
                if let v = self.btnView1 {
                    if self.isShow {
                        v.backgroundColor = .init(hex: "#27CBB3")
                        self.isShow = false
                    } else {
                        v.backgroundColor = .clear
                        self.isShow = true
                    }
                }
            case .btn2:
                if let v = self.btnView2 {
                    if self.isShow {
                        v.backgroundColor = .init(hex: "#27CBB3")
                        self.isShow = false
                    } else {
                        v.backgroundColor = .clear
                        self.isShow = true
                    }
                }
            }
            
        }).disposed(by: rx.disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(view.subviews)
        if let v = view.subviews.first?.subviews.first, v.subviews.count == 2 {
            let s = v.subviews[1]
            if s.subviews.count == 3 {
                let s1 = s.subviews[2]
                if let s2 = s1.subviews.first?.subviews.first, let s3 = s2 as? UIStackView {
                    if let s4 = s3.arrangedSubviews.first?.subviews.first {
                        btnView1 = s4
                    }
                    if s3.arrangedSubviews.count > 2, let s4 = s3.arrangedSubviews[2].subviews.first {
                        btnView2 = s4
                    }
                }
            }
        }
    }

}
