//
//  AuthCoordinator.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/3.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import Swinject

protocol AuthCoordinatorDelegate: AnyObject {
    func authCoordinatorDimiss(coordinator: AuthCoordinator)
}

class AuthCoordinator: Coordinator {
    
    var container: Container
    var window: UIWindow
    var navigationController: UINavigationController!
    
    weak var delegate: AuthCoordinatorDelegate?
    
    private var childCoordinators = [HomeChildCoordinator:Coordinator]()
    
    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
    }
    
    func start() {
        let login = container.resolve(AuthLoginViewController.self)!
        login.delegate = self
        let nav = NavigationController(rootViewController: login)
        navigationController = nav
        window.rootViewController = nav
    }
    
    
}

extension AuthCoordinator: AuthLoginViewControllerDelegate {
    
    func authLoginShowProtocol(controller: AuthLoginViewController, type: Int) {
        
        let web = container.resolve(WebViewController.self)!
        web.url = NetAPI.getHtmlProtocol(type: type)
        navigationController.pushViewController(web)
        
    }
    
    func authLoginShowLocation(controller: AuthLoginViewController) {
        
        if CheckManager.shared.isCheck {
            self.delegate?.authCoordinatorDimiss(coordinator: self)
        } else {
            let location = container.resolve(AuthLocationViewController.self)!
            location.delegate = self
            navigationController.pushViewController(location, animated: true)
            
            guard let mobile = UserManager.shared.login.value.0?.mobile, !mobile.isEmpty else {
                let alilogin = AliPhoneLogin(controller: navigationController, closeTitle: "跳过")
                alilogin.delegate = self
                alilogin.show()
                return
            }
        }
    }

}

extension AuthCoordinator: AliPhoneLoginDelegate {
    
    func aliloginShowOtherLogin() {
        
        let service = BindPhoneService() as PhoneService
        let viewModel = container.resolve(PhoneViewModel.self, argument: service)!
        let phone = container.resolve(UserInfoPhoneViewController.self, argument: viewModel)!
        phone.hbd_backInteractive = false
        phone.type = .bind
        phone.delegate = self
        phone.isShowSkip = true
        let nav = NavigationController(rootViewController: phone)
        nav.modalPresentationStyle = .overCurrentContext
        navigationController.present(nav, animated: true, completion: nil)
        
    }
    
}

extension AuthCoordinator: UserInfoPhoneViewControllerDelegate {
    
    func userInfoPhoneDimiss(controller: UserInfoPhoneViewController) {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func userInfoPhoneClickDecide(controller: UserInfoPhoneViewController, oldCode: String?) {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
}

extension AuthCoordinator: AuthLocationViewControllerDelegate {
    
    func locationShowPay(controller: AuthLocationViewController) {
        
//        guard let vip = UserManager.shared.login.value.0?.isVip, vip else {
//            let pay = container.resolve(AuthPayViewController.self)!
//            pay.delegate = self
//            navigationController.pushViewController(pay, animated: true)
//            return
//        }
        
        self.delegate?.authCoordinatorDimiss(coordinator: self)
        
    }
    
}

extension AuthCoordinator: AuthPayViewControllerDelegate {
    
    func payShowProtocol(controller: AuthPayViewController, type: Int) {
        let web = container.resolve(WebViewController.self)!
        web.url = NetAPI.getHtmlProtocol(type: type)
        navigationController.pushViewController(web)
    }
    
    func payDimiss(controller: AuthPayViewController) {
        self.delegate?.authCoordinatorDimiss(coordinator: self)
    }
    
    
}
