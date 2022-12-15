//
//  AboutViewController.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/8.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import SwifterSwift

class AboutViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "关于我们"
        setupUI()
    }
    
    // MARK: - UI
    
    func setupUI() {
        
        let logo = UIImageView(image: UIImage.create("aboutus_logo"))
        view.addSubview(logo)
        logo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(logo.image!.snpSize)
            make.top.equalToSuperview().offset(97.uiX)
        }
        
        let lbl1 = UILabel()
        lbl1.textColor = .init(hex: "#393946")
        lbl1.font = .init(style: .medium, size: 19.uiX)
        lbl1.text = "定位宝"
        view.addSubview(lbl1)
        lbl1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logo.snp.bottom).offset(22.uiX)
        }
        
        let lbl2 = UILabel()
        lbl2.textColor = .init(hex: "#7F7F99")
        lbl2.font = .init(style: .regular, size: 13.uiX)
        lbl2.text = "你安全 我安心"
        view.addSubview(lbl2)
        lbl2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lbl1.snp.bottom).offset(8.uiX)
        }
        
        let lbl3 = UILabel()
        lbl3.textColor = .init(hex: "#7F7F99")
        lbl3.font = .init(style: .regular, size: 13.uiX)
        lbl3.text = "V" + (UIApplication.shared.version ?? "")
        view.addSubview(lbl3)
        lbl3.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lbl2.snp.bottom).offset(6.uiX)
        }
        
        let lbl4 = UILabel()
        lbl4.textColor = .init(hex: "#7F7F99")
        lbl4.font = .init(style: .regular, size: 10.uiX)
        lbl4.text = "奇热公司.All Rights Reserved"
        view.addSubview(lbl4)
        lbl4.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin).offset(-20.uiX)
        }
        
        let lbl5 = UILabel()
        lbl5.textColor = .init(hex: "#7F7F99")
        lbl5.font = .init(style: .regular, size: 10.uiX)
        lbl5.text = "Copyright©2016-2020"
        view.addSubview(lbl5)
        lbl5.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(lbl4.snp.top).offset(-4.uiX)
        }
    }
    

}
