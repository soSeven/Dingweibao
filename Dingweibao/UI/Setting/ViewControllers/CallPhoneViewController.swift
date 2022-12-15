//
//  CallPhoneViewController.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/5.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation

class CallPhoneWaitView: UIView {
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#FFFFFF")
        lbl.font = .init(style: .regular, size: 31.uiX)
        lbl.text = "亲爱的"
        return lbl
    }()
    
    lazy var msglbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#FFFFFF")
        lbl.font = .init(style: .regular, size: 16.uiX)
        lbl.text = "上海移动"
        return lbl
    }()
    
    lazy var resignBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.create("call_hangup"), for: .normal)
        return btn
    }()
    
    lazy var listenBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.create("call_answer"), for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLbl)
        addSubview(msglbl)
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(UIDevice.statusBarHeight + 44.uiX)
        }
        
        msglbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLbl.snp.bottom).offset(8.uiX)
        }
        
        addSubview(resignBtn)
        addSubview(listenBtn)
        
        resignBtn.snp.makeConstraints { make in
            make.size.equalTo(resignBtn.currentImage!.snpSize)
            make.bottom.equalToSuperview().offset(-(UIDevice.safeAreaBottom + 40.uiX))
            make.left.equalToSuperview().offset(70.uiX)
        }
        
        listenBtn.snp.makeConstraints { make in
            make.size.equalTo(resignBtn.currentImage!.snpSize)
            make.bottom.equalToSuperview().offset(-(UIDevice.safeAreaBottom + 40.uiX))
            make.right.equalToSuperview().offset(-70.uiX)
        }
        
        let img1 = UIImageView(image: UIImage.create("call_alarmclock"))
        let img2 = UIImageView(image: UIImage.create("call_message"))
        addSubview(img1)
        addSubview(img2)
        
        img1.snp.makeConstraints { make in
            make.size.equalTo(img1.image!.snpSize)
            make.centerX.equalTo(resignBtn.snp.centerX)
            make.bottom.equalTo(resignBtn.snp.top).offset(-35.uiX)
        }
        
        img2.snp.makeConstraints { make in
            make.size.equalTo(img2.image!.snpSize)
            make.centerX.equalTo(listenBtn.snp.centerX)
            make.bottom.equalTo(listenBtn.snp.top).offset(-35.uiX)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CallPhoneListenView: UIView {
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#FFFFFF")
        lbl.font = .init(style: .regular, size: 31.uiX)
        lbl.text = "亲爱的"
        return lbl
    }()
    
    lazy var msglbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#FFFFFF")
        lbl.font = .init(style: .regular, size: 16.uiX)
        lbl.text = "00:00"
        return lbl
    }()
    
    lazy var resignBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.create("call_hangup2"), for: .normal)
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLbl)
        addSubview(msglbl)
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(UIDevice.statusBarHeight + 44.uiX)
        }
        
        msglbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLbl.snp.bottom).offset(8.uiX)
        }
        
        addSubview(resignBtn)
        
        resignBtn.snp.makeConstraints { make in
            make.size.equalTo(resignBtn.currentImage!.snpSize)
            make.bottom.equalToSuperview().offset(-(UIDevice.safeAreaBottom + 92.uiX))
            make.centerX.equalToSuperview()
        }
        
        let img1 = UIImageView(image: UIImage.create("call_function"))
        addSubview(img1)
        
        img1.snp.makeConstraints { make in
            make.size.equalTo(img1.image!.snpSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(msglbl.snp.bottom).offset(82.uiX)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol CallPhoneViewControllerDelegate: AnyObject {
    func callPhoneDimiss(controller: CallPhoneViewController)
}

class CallPhoneViewController: ViewController {
    
    let waitView = CallPhoneWaitView()
    let listenView = CallPhoneListenView()
    
    weak var delegate: CallPhoneViewControllerDelegate?
    
    var play: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(hex: "#303642")
        setupUI()
        setupBinding()
        if let path = Bundle.main.path(forResource: "callPhone.mp3", ofType: nil) {
            self.play = AVPlayer(url: URL(fileURLWithPath: path))
            self.play?.play()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(repeatPlay), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc
    func repeatPlay() {
        self.play?.seek(to: .zero)
        self.play?.play()
    }
    
    //MARK: - UI
    
    func setupUI() {
        
        view.addSubview(waitView)
        waitView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(listenView)
        listenView.isHidden = true
        listenView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Binding
    
    func setupBinding() {
        
        waitView.resignBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.callPhoneDimiss(controller: self)
            self.play?.pause()
            self.play = nil
        }).disposed(by: rx.disposeBag)
        
        waitView.listenBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.listenView.isHidden = false
            self.waitView.isHidden = true
            self.play?.pause()
            self.play = nil
            Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] i in
                guard let self = self else { return }
                let second = i % 60
                let minute = i / 60
                self.listenView.msglbl.text = String(format: "%.2d:%.2d", minute, second)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        listenView.resignBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.callPhoneDimiss(controller: self)
        }).disposed(by: rx.disposeBag)
        
    }

}
