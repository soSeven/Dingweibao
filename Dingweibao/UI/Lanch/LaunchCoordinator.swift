//
//  LaunchCoordinator.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/16.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import Swinject
import RxSwift

protocol LaunchCoordinatorDelegate: AnyObject {
    func launchCoordinatorDimiss(coordinator: LaunchCoordinator)
}

class LaunchCoordinator: Coordinator {
    
    var container: Container
    var window: UIWindow
    var navigationController: UINavigationController!
    
    weak var delegate: LaunchCoordinatorDelegate?
    
    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
    }
    
    func start() {
        
        let launch = LaunchViewController()
        launch.delegate = self
        let nav = NavigationController(rootViewController: launch)
        window.rootViewController = nav
        navigationController = nav
    }
    
}

extension LaunchCoordinator: LaunchViewControllerDelegate {
    
    func launchShowProtocol(controller: LaunchViewController, type: Int) {
        let web = container.resolve(WebViewController.self)!
        web.url = NetAPI.getHtmlProtocol(type: type)
        navigationController.pushViewController(web)
    }
    
    func launchDimiss(controller: LaunchViewController) {
        self.delegate?.launchCoordinatorDimiss(coordinator: self)
    }
    
}
