//
//  CircleAuthViewController.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/1.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum CircleAuthType: Int {
    case needAuth = 1
    case notAuth = 2
    case refuse = 3
    
    var text: String {
        switch self {
        case .needAuth:
            return "仅群主验证通过"
        case .notAuth:
            return "无需验证"
        case .refuse:
            return "拒绝所有人"
        }
    }
}

protocol CircleAuthViewControllerDelegate: AnyObject {
    
    func circleAuthDimiss(controller: CircleAuthViewController)
    
}

class CircleAuthViewController: ViewController {
    
    var authType: CircleAuthType = .needAuth
    var tableView: UITableView!
    
    weak var delegate: CircleAuthViewControllerDelegate?
    
    let requestChange = PublishRelay<(type: CircleInfoChangeType, value: String)>()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "加群权限"
        setupUI()
        setupBinding()
    }
    
    // MARK: UI
    
    private func setupUI() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 55.uiX
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.contentInset = .init(top: 0, left: 0, bottom: UIDevice.safeAreaBottom + 20, right: 0)
        tableView.register(cellType: CircleAuthTableCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let footer = UIView(frame: .init(x: 0, y: 0, width: 0, height: 40.uiX))
        let l = UILabel()
        l.text = "其他人申请加入此群，通过以下方式验证"
        l.textColor = .init(hex: "#999999")
        l.font = UIFont(style: .regular, size: 13.uiX)
        footer.addSubview(l)
        l.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15.uiX)
        }
        self.tableView.tableHeaderView = footer
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        let items: [CircleAuthType] = [ .notAuth, .needAuth, .refuse]
        Observable.just(items).bind(to: tableView.rx.items(cellIdentifier: CircleAuthTableCell.reuseIdentifier, cellType: CircleAuthTableCell.self)) {[weak self] (row, element, cell) in
            guard let self = self else { return }
            cell.bind(to: element, needCheck: element == self.authType)
        }.disposed(by: rx.disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            let type = items[indexPath.row]
            if type == self.authType {
                return
            }
            self.authType = type
            self.tableView.reloadData()
            self.requestChange.accept((.auth, value: String(type.rawValue)))
            self.delegate?.circleAuthDimiss(controller: self)
        }).disposed(by: rx.disposeBag)
        
    }


}
