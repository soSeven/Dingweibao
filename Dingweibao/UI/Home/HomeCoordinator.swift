//
//  HomeCoordinator.swift
//  Dingweibao
//
//  Created by LiQi on 2020/5/27.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import Swinject
import RxSwift

enum HomeChildCoordinator {
    case login
    case setting
}

class HomeCoordinator: Coordinator {
    
    var container: Container
    var window: UIWindow
    var navigationController: UINavigationController!
    weak var homeController: HomeViewController?
    
    private var childCoordinators = [HomeChildCoordinator:Coordinator]()
    
    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
    }
    
    func start() {
        let home = container.resolve(HomeViewController.self)!
        home.delegate = self
        let nav = NavigationController(rootViewController: home)
        navigationController = nav
        window.rootViewController = nav
        homeController = home
    }
    
}

extension HomeCoordinator: HomeViewControllerDelegate {
    
    func homeShowPayController(controller: HomeViewController) {
        
        let pay = container.resolve(AuthPayViewController.self)!
        pay.delegate = self
        let nav = NavigationController(rootViewController: pay)
        nav.modalPresentationStyle = .overCurrentContext
        navigationController.present(nav, animated: true, completion: nil)
    }
    
    
    func homeShowCircleInfoController(controller: HomeViewController, circleModel: CircleListCellViewModel?) {
        guard let m = circleModel else {
            return
        }
        let info = container.resolve(CircleInfoViewController.self, argument: m.encodeId!)!
        info.delegate = self
        info.circleViewModel = circleModel
        info.removeRequest.bind(to: controller.removeCircle).disposed(by: info.rx.disposeBag)
        navigationController.pushViewController(info)
    }
    
    func homeShowUserController(controller: HomeViewController) {
        
        if UserManager.shared.isLogin {
            let setting = SettingCoordinator(container: container, navigationController: navigationController)
            setting.start()
            setting.delegate = self
            childCoordinators[.setting] = setting
        }
        
    }
    
    
}

extension HomeCoordinator: AuthPayViewControllerDelegate {
    
    func payShowProtocol(controller: AuthPayViewController, type: Int) {
        let web = container.resolve(WebViewController.self)!
        web.url = NetAPI.getHtmlProtocol(type: type)
        controller.navigationController?.pushViewController(web)
    }
    
    func payDimiss(controller: AuthPayViewController) {
        navigationController.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            let showCircleAlertKey = "HomeViewController.showCircleAlert"
            if let _ = UserDefaults.standard.object(forKey: showCircleAlertKey) {
                
            } else {
                UserDefaults.standard.set(object: showCircleAlertKey, forKey: showCircleAlertKey)
                self.homeController?.showCircleAlert.accept(())
            }
            
        })
    }
}


extension HomeCoordinator: CircleInfoViewControllerDelegate {
    
    func circleInfoDimiss(controller: CircleInfoViewController) {
        navigationController.popViewController()
    }
    
    func circleInfoShowUserController(controller: CircleInfoViewController, circleId: String, user: CircleUserModel) {
        if user.isMe {
            let my = container.resolve(MyViewController.self)!
            my.delegate = self
            navigationController.pushViewController(my)
        } else {
            let otherUserController = container.resolve(OtherUserInfoViewController.self, arguments: circleId, user.id!)!
            otherUserController.delegate = self
            otherUserController.needRequest.bind(to: controller.needRequest).disposed(by: otherUserController.rx.disposeBag)
            otherUserController.removeRequest.bind(to: controller.needRequest).disposed(by: otherUserController.rx.disposeBag)
            navigationController.pushViewController(otherUserController)
        }
        
    }
    
    func circleInfoShowNameController(controller: CircleInfoViewController, name: String, id: String) {
        
        let service = EditNameCircleNameService(id: id) as EditNameService
        let nameController = container.resolve(EditNameViewController.self, argument: service)!
        nameController.navigationItem.title = "修改群名称"
        nameController.wordCount = 1
        nameController.chinaWordCount = 1
        nameController.alertTitle = "最短1个字母或汉字，最多8个汉字或16个字母"
        nameController.text = name
        nameController.delegate = self
        nameController.showSuccess.flatMap { _ in Observable<Void>.just(())}.bind(to: controller.needRequest).disposed(by: nameController.rx.disposeBag)
        let nav = NavigationController(rootViewController: nameController)
        nav.modalPresentationStyle = .currentContext
        navigationController.present(nav, animated: true, completion: nil)
    }
    
    func circleInfoShowAuthController(controller: CircleInfoViewController, type: Int) {
        
        let auth = container.resolve(CircleAuthViewController.self, argument: type)!
        auth.delegate = self
        auth.requestChange.bind(to: controller.requestChange).disposed(by: auth.rx.disposeBag)
        navigationController.pushViewController(auth)
        
    }
    
}

extension HomeCoordinator: MyViewControllerDelegate {
    
    func myShowUserType(controller: MyViewController, type: MyCellType) {
        switch type {
        case let .name(title: _, info: user):
            let service = EditNameUserNameService() as EditNameService
            let nameController = container.resolve(EditNameViewController.self, argument: service)!
            nameController.navigationItem.title = "修改姓名"
            nameController.placeHolder = "请输入昵称..."
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

extension HomeCoordinator: AliPhoneLoginDelegate {
    
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

extension HomeCoordinator: UserInfoPhoneViewControllerDelegate {
    
    func userInfoPhoneDimiss(controller: UserInfoPhoneViewController) {
        navigationController.popViewController(animated: true)
    }
    
    func userInfoPhoneClickDecide(controller: UserInfoPhoneViewController, oldCode: String?) {
        navigationController.popViewController(animated: true)
    }
    
    
}


extension HomeCoordinator: OtherUserInfoViewControllerDelegate {
    
    func otherUserDimiss(controller: OtherUserInfoViewController) {
        
        navigationController.popViewController()
        
    }
    
    func otherUserInfoShowNameController(controller: OtherUserInfoViewController, id: String, info: CircleOtherModel) {
        
        let service = EditNameCircleUserNameService(id: id, userId: info.id) as EditNameService
        let nameController = container.resolve(EditNameViewController.self, argument: service)!
        nameController.navigationItem.title = "修改备注"
        nameController.placeHolder = "请输入备注..."
        nameController.text = info.remarks
        nameController.delegate = self
        nameController.showSuccess.flatMap { _ in Observable<Void>.just(())}.bind(to: controller.needRequest).disposed(by: nameController.rx.disposeBag)
        let nav = NavigationController(rootViewController: nameController)
        nav.modalPresentationStyle = .currentContext
        navigationController.present(nav, animated: true, completion: nil)
    }
    
}

extension HomeCoordinator: EditNameViewControllerDelegate {
    
    func editNameDimiss(controller: EditNameViewController) {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    
}

extension HomeCoordinator: CircleAuthViewControllerDelegate {
    
    func circleAuthDimiss(controller: CircleAuthViewController) {
        
        navigationController.popViewController(animated: true)
        
    }
    
}


extension HomeCoordinator: SettingCoordinatorDelegate {
    
    func settingCoordinatorDimiss(coordinator: SettingCoordinator) {
        childCoordinators[.setting] = nil
    }
    
}
