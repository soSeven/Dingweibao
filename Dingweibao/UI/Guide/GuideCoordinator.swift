//
//  GuideCoordinator.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import Swinject
import RxSwift
import Onboard

protocol GuideCoordinatorDelegate: AnyObject {
    
    func guideCoordinatorDimiss(coordinator: GuideCoordinator)
    
}

class GuideCoordinator: Coordinator {
    
    var container: Container
    var window: UIWindow
    var navigationController: UINavigationController!
    
    weak var delegate: GuideCoordinatorDelegate?
    
    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
    }
    
    func start() {
        
        let page1 = GuidePage1Controller()
        page1.delegate = self
        let nav = NavigationController(rootViewController: page1)
        window.rootViewController = nav
        navigationController = nav
        
    }
    
}

extension GuideCoordinator: GuidePage1ViewControllerDelegate {
    
    func page1ShowNext(controller: GuidePage1Controller) {
        let page2 = GuidePage2ViewController()
        page2.delegate = self
        navigationController.pushViewController(page2)
    }
    
}

extension GuideCoordinator: GuidePage2ViewControllerDelegate {
    
    func page2ShowNext(controller: GuidePage2ViewController) {
        
        let page3 = GuidePage3ViewController()
        page3.delegate = self
        navigationController.pushViewController(page3)
        
    }
    
}

extension GuideCoordinator: GuidePage3ViewControllerDelegate {
    
    func page3ShowNext(controller: GuidePage3ViewController) {
        let page4 = GuidePage4ViewController()
        page4.delegate = self
        navigationController.pushViewController(page4)
    }
    
}

extension GuideCoordinator: GuidePage4ViewControllerDelegate {
    
    func page4ShowNext(controller: GuidePage4ViewController) {
        
        delegate?.guideCoordinatorDimiss(coordinator: self)
        
    }
    
}
