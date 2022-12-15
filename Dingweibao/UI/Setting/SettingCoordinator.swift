//
//  SettingCoordinator.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/8.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import Swinject
import RxCocoa
import RxSwift

protocol SettingCoordinatorDelegate: AnyObject {
    func settingCoordinatorDimiss(coordinator: SettingCoordinator)
}

class SettingCoordinator: Coordinator {
    
    var container: Container
    var navigationController: UINavigationController!
    
    weak var delegate: SettingCoordinatorDelegate?
    
    private var childCoordinators = [HomeChildCoordinator:Coordinator]()
    
    init(container: Container, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let user = container.resolve(UserViewController.self)!
        user.delegate = self
//        user.modalPresentationStyle = .overCurrentContext
        let nav = NavigationController(rootViewController: user)
        nav.modalPresentationStyle = .overCurrentContext
        navigationController.present(nav, animated: false, completion: nil)
        navigationController = nav
    }
    
    
}

extension SettingCoordinator: UserViewControllerDelegate {
    
    func userShowUserInfo(controller: UserViewController) {
        let my = container.resolve(MyViewController.self)!
        my.delegate = self
        navigationController.pushViewController(my)
    }
    
    func userShowSetting(controller: UserViewController, viewModel: UserCellViewModel) {
        switch viewModel.type {
        case .setting:
            let setting = container.resolve(SettingViewController.self)!
            setting.delegate = self
            navigationController.pushViewController(setting)
        case .power:
            let power = container.resolve(PowerViewController.self)!
            power.delegate = self
            navigationController.pushViewController(power)
        case .message:
            let message = container.resolve(MessageViewController.self)!
            navigationController.pushViewController(message)
        case .phone:
            let phone = container.resolve(CallPhoneViewController.self)!
            phone.modalPresentationStyle = .overCurrentContext
            phone.delegate = self
            navigationController.present(phone, animated: true, completion: nil)
        case .pro:
            let pay = container.resolve(AuthPayViewController.self)!
            pay.delegate = self
            let nav = NavigationController(rootViewController: pay)
            nav.modalPresentationStyle = .overCurrentContext
            navigationController.present(nav, animated: true, completion: nil)
        }
    }
    
}

extension SettingCoordinator: PowerViewControllerDelegate {
    
    func powerShowPay(controller: PowerViewController) {
        let pay = container.resolve(AuthPayViewController.self)!
        pay.delegate = self
        let nav = NavigationController(rootViewController: pay)
        nav.modalPresentationStyle = .overCurrentContext
        navigationController.present(nav, animated: true, completion: nil)
    }
    
}

extension SettingCoordinator: AuthPayViewControllerDelegate {
    
    func payShowProtocol(controller: AuthPayViewController, type: Int) {
        let web = container.resolve(WebViewController.self)!
        web.url = NetAPI.getHtmlProtocol(type: type)
        controller.navigationController?.pushViewController(web)
    }
    
    func payDimiss(controller: AuthPayViewController) {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
}

extension SettingCoordinator: MyViewControllerDelegate {
    
    func myShowUserType(controller: MyViewController, type: MyCellType) {
        switch type {
        case let .name(title: _, info: user):
            let service = EditNameUserNameService() as EditNameService
            let nameController = container.resolve(EditNameViewController.self, argument: service)!
            nameController.navigationItem.title = "修改姓名"
            nameController.text = user.nickname
            nameController.delegate = self
            nameController.showSuccess.flatMap { _ in Observable<Void>.just(())}.bind(to: controller.needRequest).disposed(by: nameController.rx.disposeBag)
            let nav = NavigationController(rootViewController: nameController)
            nav.modalPresentationStyle = .currentContext
            navigationController.present(nav, animated: true, completion: nil)
        case .phone:
            let alilogin = AliPhoneLogin(controller: navigationController, closeTitle: "取消")
            alilogin.delegate = self
            alilogin.show()
        default:
            break
        }
    }
    
    
}

extension SettingCoordinator: AliPhoneLoginDelegate {
    
    func aliloginShowOtherLogin() {
        
        let service = BindPhoneService() as PhoneService
        let viewModel = container.resolve(PhoneViewModel.self, argument: service)!
        let phone = container.resolve(UserInfoPhoneViewController.self, argument: viewModel)!
        phone.hbd_backInteractive = false
        phone.type = .bind
        phone.delegate = self
        navigationController.pushViewController(phone)
        
    }
    
}

extension SettingCoordinator: UserInfoPhoneViewControllerDelegate {
    
    func userInfoPhoneDimiss(controller: UserInfoPhoneViewController) {
        navigationController.popViewController(animated: true)
    }
    
    
    func userInfoPhoneClickDecide(controller: UserInfoPhoneViewController, oldCode: String?) {
        navigationController.popViewController(animated: true)
    }
    
    
}

extension SettingCoordinator: EditNameViewControllerDelegate {
    
    func editNameDimiss(controller: EditNameViewController) {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    
}

extension SettingCoordinator: SettingViewControllerDelegate {
    
    func settingShowType(controller: SettingViewController, type: SettingType) {
        switch type {
        case .about:
            let about = container.resolve(AboutViewController.self)!
            navigationController.pushViewController(about)
        case .userPrivacy:
            let web = container.resolve(WebViewController.self)!
            web.url = NetAPI.getHtmlProtocol(type: 2)
            navigationController.pushViewController(web)
        case .userProtocol:
            let web = container.resolve(WebViewController.self)!
            web.url = NetAPI.getHtmlProtocol(type: 1)
            navigationController.pushViewController(web)
        }
    }
    
}

extension SettingCoordinator: CallPhoneViewControllerDelegate {
    
    func callPhoneDimiss(controller: CallPhoneViewController) {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    
}

