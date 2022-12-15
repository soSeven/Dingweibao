//
//  GuideViewController.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import SwiftEntryKit
import RxCocoa
import RxSwift

class GuideViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        let page1 = GuidePageView()
        page1.lbl.text = "实时定位追踪"
        page1.imgView.image = UIImage.create("guidepage_bg1")
        page1.btn.rx.tap.subscribe(onNext: { _ in
            scrollView.setContentOffset(.init(x: UIDevice.screenWidth, y: 0), animated: true)
        }).disposed(by: rx.disposeBag)
        contentView.addSubview(page1)
        page1.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(UIDevice.screenWidth)
        }
        
        let page2 = GuidePageView()
        page2.lbl.text = "获取智能通知"
        page2.imgView.image = UIImage.create("guidepage_bg2")
        page2.btn.rx.tap.subscribe(onNext: { _ in
            scrollView.setContentOffset(.init(x: UIDevice.screenWidth*2, y: 0), animated: true)
        }).disposed(by: rx.disposeBag)
        contentView.addSubview(page2)
        page2.snp.makeConstraints { make in
            make.left.equalTo(page1.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(UIDevice.screenWidth)
        }
        
        let page3 = GuidePageView()
        page3.lbl.text = "卫星实景地图"
        page3.imgView.image = UIImage.create("guidepage_bg3")
        page3.btn.rx.tap.subscribe(onNext: { _ in
            scrollView.setContentOffset(.init(x: UIDevice.screenWidth*3, y: 0), animated: true)
        }).disposed(by: rx.disposeBag)
        contentView.addSubview(page3)
        page3.snp.makeConstraints { make in
            make.left.equalTo(page2.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(UIDevice.screenWidth)
        }
        
        let page4 = GuidePageView()
        page4.lbl.text = "模拟真实来电"
        page4.imgView.image = UIImage.create("guidepage_bg4")
        page4.btn.rx.tap.subscribe(onNext: { _ in
            
        }).disposed(by: rx.disposeBag)
        contentView.addSubview(page4)
        page4.snp.makeConstraints { make in
            make.left.equalTo(page3.snp.right)
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(UIDevice.screenWidth)
        }
        
        let merge = Observable.merge(scrollView.rx.didEndDecelerating.asObservable(), scrollView.rx.didEndScrollingAnimation.asObservable())
        merge.subscribe(onNext: { [weak scrollView] _ in
            guard let scrollView = scrollView else { return }
            if scrollView.contentOffset.x >= UIDevice.screenWidth,
                scrollView.contentOffset.x < (UIDevice.screenWidth * 2) {
                page2.showPushImgView()
            } else {
                page2.hidePushImgView()
            }
        }).disposed(by: rx.disposeBag)
    }
    
    override func onceWhenViewDidAppear(_ animated: Bool) {
        
        
        
    }

}
