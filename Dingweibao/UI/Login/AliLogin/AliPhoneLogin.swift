//
//  AliPhoneLogin.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/14.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import ATAuthSDK
import Toast_Swift
import SwifterSwift
import RxCocoa
import RxSwift

protocol AliPhoneLoginDelegate: AnyObject {
    
    func aliloginShowOtherLogin()
    
}

class AliPhoneLogin: NSObject {
    
    private static var authSuccess = false
    private var viewController: UIViewController
    private var closeTitle: String
    weak var delegate: AliPhoneLoginDelegate?
    
    required init(controller: UIViewController, closeTitle: String) {
        viewController = controller
        self.closeTitle = closeTitle
        super.init()
    }
    
    deinit {
        print("deinit")
    }
    
    // MARK: - Login
    
    func show() {
        login(with: viewController)
    }
    
    private func login(with controller: UIViewController) {
        controller.view.makeToastActivity(.center)
        if AliPhoneLogin.authSuccess {
            self.phoneLogin(with: controller)
        } else {
            TXCommonHandler.sharedInstance().setAuthSDKInfo(AppDefine.aliAuthKey) { dict in
                DispatchQueue.main.async {
                    if let code = dict["resultCode"] as? String, code == PNSCodeSuccess {
                        self.phoneLogin(with: controller)
                    } else {
                        controller.view.hideToastActivity()
                        self.presetenPhoneLoginController()
                    }
                }
            }
        }
    }
    
    private func phoneLogin(with controller: UIViewController) {
        let model = getCustomModel()
        TXCommonHandler.sharedInstance().checkEnvAvailable { resultDic in
            
            DispatchQueue.main.async {
                
                guard let code = resultDic?["resultCode"] as? String, code == PNSCodeSuccess else {
                    controller.view.hideToastActivity()
                    self.presetenPhoneLoginController()
                    return
                }
                
                TXCommonHandler.sharedInstance().getLoginToken(withTimeout: 3, controller: controller, model: model) { resultDic in
                    if let code = resultDic["resultCode"] as? String {
                        if code == PNSCodeLoginControllerPresentSuccess {
                            controller.view.hideToastActivity()
                        } else if code == PNSCodeLoginControllerClickCancel {
                            // 点击了授权页的返回
                        } else if code == PNSCodeLoginControllerClickChangeBtn {
                            // 点击切换其他登录方式按钮
                        } else if code == PNSCodeLoginControllerClickLoginBtn {
//                            controller.view.hideToastActivity()
                            controller.view.makeToastActivity(.center)
                        } else if code == PNSCodeLoginControllerClickCheckBoxBtn {
                            // 点击check box
                        } else if code == PNSCodeLoginControllerClickProtocol {
                            // 点击了协议富文本
                        } else if code == PNSCodeSuccess, let token = resultDic["token"] as? String {
                            controller.view.hideToastActivity()
                            NetManager.requestResponse(.aliBindPhone(token: token)).subscribe(onSuccess: { _ in
                                TXCommonHandler.sharedInstance().cancelLoginVC(animated: true, complete: nil)
                                UserManager.shared.updateUser()
                            }, onError: { error in
                                if let e = error as? NetError, let v = controller.view.window {
                                    switch e {
                                    case let .error(code: _, msg: msg):
                                        Observable.just(msg).bind(to: v.rx.mbHudText).disposed(by: controller.rx.disposeBag)
                                    }
                                }
                                
                            }).disposed(by: self.rx.disposeBag)
                        } else {
                            controller.view.hideToastActivity()
                            self.presetenPhoneLoginController()
                        }
                    } else {
                        controller.view.hideToastActivity()
                        self.presetenPhoneLoginController()
                    }
                }
                
            }
        }
    }
    
    private func presetenPhoneLoginController() {
        TXCommonHandler.sharedInstance().cancelLoginVC(animated: false, complete: nil)
        delegate?.aliloginShowOtherLogin()
    }
    
    private func getCustomModel() -> TXCustomModel {
        
        //默认，注：model的构建需要放在主线程
        let model = TXCustomModel()
        model.navTitle = NSAttributedString(string: "");
        model.navColor = .clear
        model.navIsHidden = true
        
        let closeImg = UIImage(named: "pay_icon_shut")!
        
        let logoImg = UIImage.create("login_logo")
        model.logoImage = logoImg
        model.logoFrameBlock = { screenSize, superViewSize, frame in
            let x = (UIDevice.screenWidth - logoImg.snpSize.width)/2.0;
            let y = 98.uiX + UIDevice.statusBarHeight;
            return CGRect(x: x, y: y, width: logoImg.snpSize.width, height: logoImg.snpSize.height)
        }
        
        let sloganAtt: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 13.uiX),
            .foregroundColor: UIColor(hex: "#7F7F99")
        ]
        let str = TXCommonUtils.getCurrentCarrierName() ?? ""
        let sloganText = "\(str)提供认证服务"
        let sloganTextAtt = NSAttributedString(string: sloganText, attributes: sloganAtt)
        model.sloganText = sloganTextAtt
        model.sloganFrameBlock = { screenSize, superViewSize, frame in
            let width = frame.size.width
            let height = frame.size.height
            let x = (UIDevice.screenWidth - width)/2.0
            let y = 250.uiX  + UIDevice.statusBarHeight
            return CGRect(x: x, y: y, width: width, height: height)
        }
            
        model.numberFont = UIFont(style: .regular, size: 26.uiX)
        model.numberColor = .init(hex: "#393946")
        model.numberFrameBlock = { screenSize, superViewSize, frame in
            let width = frame.size.width
            let height = frame.size.height
            let x = (UIDevice.screenWidth - width)/2.0
            let y = 212.uiX + UIDevice.statusBarHeight
            return CGRect(x: x, y: y, width: width, height: height)
        }
        
        let loginImg = UIImage(named: "login_button")!
        model.loginBtnBgImgs = [loginImg, loginImg, loginImg];
        let loginAtt: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .medium, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#FFFFFF")
        ]
        let loginTextAtt = NSAttributedString(string: "本机号码一键绑定", attributes: loginAtt)
        model.loginBtnText = loginTextAtt;
        model.loginBtnFrameBlock = { screenSize, superViewSize, frame in
            let width = 255.uiX
            let height = 46.uiX
            let x = (UIDevice.screenWidth - width)/2.0
            let y = 302.uiX + UIDevice.statusBarHeight
            return CGRect(x: x, y: y, width: width, height: height)
        }
       
        model.changeBtnIsHidden = true
        
        model.checkBoxIsChecked = true
        model.checkBoxIsHidden = true
        model.privacyAlignment = .center
        model.privacyPreText = "同意"
        model.privacySufText = "并授权定位宝获得本机号码"
        model.privacyFont = .init(style: .regular, size: 12.uiX);
        model.privacyColors = [UIColor(hex: "#7F7F99"), UIColor(hex: "#27CBB3")]
        model.privacyOperatorPreText = "《"
        model.privacyOperatorSufText = "》"
        model.privacyNavBackImage = closeImg
        model.privacyNavColor = AppDefine.mainColor
        model.privacyNavTitleColor = .init(hex: "#111111")
        model.privacyFrameBlock = { screenSize, superViewSize, frame in
            let width = frame.size.width
            let height = frame.size.height
            let x = (UIDevice.screenWidth - width)/2.0;
            let y = UIDevice.screenHeight - height - 31.uiX - UIDevice.safeAreaBottom
            return CGRect(x: x, y: y, width: width, height: height)
            
        }
        
        let closeBtn = UIButton()
        let closeAtt: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .medium, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#7F7F99")
        ]
        closeBtn.setAttributedTitle(.init(string: closeTitle, attributes: closeAtt), for: .normal)
        closeBtn.rx.tap.subscribe(onNext: {
            TXCommonHandler.sharedInstance().cancelLoginVC(animated: true, complete: nil)
        }).disposed(by: rx.disposeBag)
        
        model.customViewBlock = { superCustomView in
            superCustomView.addSubview(closeBtn)
        }
        
        model.customViewLayoutBlock = { screenSize, contentViewFrame, navFrame, titleBarFrame, logoFrame, sloganFrame, numberFrame, loginFrame, changeBtnFrame, privacyFrame in
            
            let width = 40.uiX
            let height = 40.uiX
            let x = UIDevice.screenWidth - 15.uiX - width
            let y = 20.uiX + UIDevice.statusBarHeight
            closeBtn.frame = .init(x: x, y: y, width: width, height: height)
        };
        return model

    }
    
}
