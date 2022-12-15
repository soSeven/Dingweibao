//
//  Application.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import Swinject
import RxCocoa
import RxSwift

enum ApplicationChildCoordinator {
    case home
    case auth
    case guide
    case launch
}

final class Application: NSObject {
    
    static let shared = Application()
    internal let container = Container()
    private var childCoordinator = [ApplicationChildCoordinator:Coordinator]()
    var window: UIWindow!
    
    let guideKey = "guideKey"
    let protocolKey = "protocolKey"
    
    func configureDependencies() {
        
        
        container.register(HomeViewModel.self) { r in
            let v = HomeViewModel()
            return v
        }
        container.register(HomeViewController.self) { r in
            let home = HomeViewController()
            home.viewModel = r.resolve(HomeViewModel.self)!
            return home
        }
        
        container.register(UserViewModel.self) { r in
            let v = UserViewModel()
            return v
        }
        container.register(UserViewController.self) { r in
            let user = UserViewController()
            user.viewModel = r.resolve(UserViewModel.self)!
            return user
        }
        
        container.register(CircleInfoViewModel.self) { (r: Resolver, id: String) in
            let v = CircleInfoViewModel(id: id)
            return v
        }
        container.register(CircleInfoViewController.self) { (r: Resolver, id: String) in
            let info = CircleInfoViewController()
            info.viewModel = r.resolve(CircleInfoViewModel.self, argument: id)!
            return info
        }
        
        container.register(CircleAuthViewController.self) { (r: Resolver, type: Int) in
            let auth = CircleAuthViewController()
            auth.authType = CircleAuthType(rawValue: type) ?? .needAuth
            return auth
        }
        
        container.register(EditNameViewModel.self) { (r: Resolver, service: EditNameService) in
            let v = EditNameViewModel(service: service)
            return v
        }
        container.register(EditNameViewController.self) { (r: Resolver, service: EditNameService) in
            let edit = EditNameViewController()
            edit.viewModel = r.resolve(EditNameViewModel.self, argument: service)
            return edit
        }
        
        container.register(OtherUserViewModel.self) { (r: Resolver, id: String, userId: String) in
            let v = OtherUserViewModel(id: id, userId: userId)
            return v
        }
        container.register(OtherUserInfoViewController.self) { (r: Resolver, id: String, userId: String) in
            let otherUser = OtherUserInfoViewController()
            otherUser.viewModel = r.resolve(OtherUserViewModel.self, arguments: id, userId)
            return otherUser
        }
        
        /// 授权
        container.register(AuthLoginViewModel.self) { r in
            let v = AuthLoginViewModel()
            return v
        }
        container.register(AuthLoginViewController.self) { r in
            let login = AuthLoginViewController()
            login.viewModel = r.resolve(AuthLoginViewModel.self)!
            return login
        }
        container.register(AuthLocationViewController.self) { r in
            let location = AuthLocationViewController()
            return location
        }
        
        container.register(AuthPayViewModel.self) { r in
            let v = AuthPayViewModel()
            return v
        }
        container.register(AuthPayViewController.self) { r in
            let pay = AuthPayViewController()
            pay.viewModel = r.resolve(AuthPayViewModel.self)!
            return pay
        }
        
        /// 注册登录
        container.register(PhoneViewModel.self) { (r: Resolver, service: PhoneService) in
            return PhoneViewModel(service: service)
        }
        container.register(LoginController.self) { (r: Resolver, viewModel: PhoneViewModel) in
            let login = LoginController()
            login.viewModel = viewModel
            return login
        }
        container.register(UserInfoPhoneViewController.self) { (r: Resolver, viewModel: PhoneViewModel) in
            let login = UserInfoPhoneViewController()
            login.viewModel = viewModel
            return login
        }
        
        /// 设置
        container.register(SettingViewModel.self) { r in
            return SettingViewModel()
        }
        container.register(SettingViewController.self) { r in
            let setting = SettingViewController()
            setting.viewModel = r.resolve(SettingViewModel.self)!
            return setting
        }
        
        container.register(AboutViewController.self) { r in
            let about = AboutViewController()
            return about
        }
        
        container.register(MyViewModel.self) { r in
            return MyViewModel()
        }
        container.register(MyViewController.self) { r in
            let my = MyViewController()
            my.viewModel = r.resolve(MyViewModel.self)!
            return my
        }
        
        container.register(ListViewModel<MessageListModel>.self) { r in
            let v = ListViewModel<MessageListModel>(service: MessageListService())
            return v
        }
        container.register(MessageViewController.self) { r in
            let message = MessageViewController()
            message.viewModel = r.resolve(ListViewModel<MessageListModel>.self)!
            return message
        }
        
        container.register(CallPhoneViewController.self) { r in
            let call = CallPhoneViewController()
            return call
        }
        
        container.register(PowerViewModel.self) { r in
            return PowerViewModel()
        }
        container.register(PowerViewController.self) { r in
            let power = PowerViewController()
            power.viewModel = r.resolve(PowerViewModel.self)!
            return power
        }
        
        /// 网页
        container.register(WebViewController.self) { r in
            return WebViewController()
        }
        
        
    }
    
    func configureMainInterface(in window: UIWindow) {
        
        self.window = window
        
        if let _ = UserDefaults.standard.object(forKey: protocolKey) {
            showGuideOrContent()
        } else {
            showLaunch()
        }
        
    }
    
    func showGuideOrContent() {
        
        if let _ = UserDefaults.standard.object(forKey: guideKey) {
            LibsManager.shared.registerUMPush()
            showContent()
        } else {
            UserDefaults.standard.set(guideKey, forKey: guideKey)
            showGuide()
        }
    }
    
    func showContent() {
        
        if UserManager.shared.isLogin {
            showHome()
        } else {
            showAuth()
        }

        UserManager.shared.login.subscribe(onNext: { [weak self] user in
            guard let self = self else { return }
            switch user.1 {
            case .loginOut:
                self.showAuth()
            default:
                break
            }
        }).disposed(by: rx.disposeBag)
    }
    
    func showLaunch() {
        let launch = LaunchCoordinator(window: window, container: container)
        launch.delegate = self
        launch.start()
        childCoordinator.removeAll()
        childCoordinator[.launch] = launch
    }
    
    func showHome() {
        let appCoordinator = HomeCoordinator(window: window, container: container)
        appCoordinator.start()
        childCoordinator.removeAll()
        childCoordinator[.home] = appCoordinator
    }
    
    func showAuth() {
        let authCoordinator = AuthCoordinator(window: window, container: container)
        authCoordinator.start()
        authCoordinator.delegate = self
        childCoordinator.removeAll()
        childCoordinator[.auth] = authCoordinator
    }
    
    func showGuide() {
        let guideCoordinator = GuideCoordinator(window: window, container: container)
        guideCoordinator.start()
        guideCoordinator.delegate = self
        childCoordinator.removeAll()
        childCoordinator[.guide] = guideCoordinator
    }
    
}

extension Application: LaunchCoordinatorDelegate {
    
    func launchCoordinatorDimiss(coordinator: LaunchCoordinator) {
        
        UserDefaults.standard.set(protocolKey, forKey: protocolKey)
        showGuideOrContent()
        
    }
    
}

extension Application: GuideCoordinatorDelegate {
    
    func guideCoordinatorDimiss(coordinator: GuideCoordinator) {
        
        showContent()
        
    }
    
}

extension Application: AuthCoordinatorDelegate {
    
    func authCoordinatorDimiss(coordinator: AuthCoordinator) {
        
        showHome()
        
    }
    
    
}
