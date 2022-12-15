//
//  UserViewController.swift
//  Dingweibao
//
//  Created by LiQi on 2020/5/28.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift

protocol UserViewControllerDelegate: AnyObject {
    
    func userShowSetting(controller: UserViewController, viewModel: UserCellViewModel)
    func userShowUserInfo(controller: UserViewController)
}

class UserViewController: ViewController {
    
    var viewModel: UserViewModel!
    
    weak var delegate: UserViewControllerDelegate?
    
    var tableView: UITableView!
    var headerView: UserInfoView!
    
    lazy var contentView: UIView = {
        let c = UIView()
        c.backgroundColor = .white
        c.transform = .init(translationX: -300.uiX, y: 0)
        return c
    }()
    
    lazy var bgView: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.alpha = 0
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        hbd_barHidden = true
        setupUI()
        UserManager.shared.updateUser()
    }
    
    override func onceWhenViewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.bgView.alpha = 0.5
            self.contentView.transform = .identity
        }
        setupBinding()
    }
    
    // MARK: - UI
    
    func setupUI() {
        
        view.addSubview(bgView)
        bgView.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.25, animations: {
                self.bgView.alpha = 0
                self.contentView.transform = .init(translationX: -300.uiX, y: 0)
            }) { finished in
                self.dismiss(animated: false, completion: nil)
            }
        }).disposed(by: rx.disposeBag)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(300.uiX)
        }
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 64.uiX
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        let header = UserInfoView(frame: .init(x: 0, y: 0, width: 0, height: 230.uiX + UIDevice.statusBarHeight))
        let merge = Observable.merge(header.imgView.rx.tap(), header.namelbl.rx.tap())
        merge.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.userShowUserInfo(controller: self)
        }).disposed(by: rx.disposeBag)
        headerView = header
        header.backgroundColor = .clear
        tableView.tableHeaderView = header
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.register(cellType: UserTableCell.self)
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        let input = UserViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.items.bind(to: tableView.rx.items(cellIdentifier: UserTableCell.reuseIdentifier, cellType: UserTableCell.self)) { (row, element, cell) in
            cell.bind(to: element)
        }.disposed(by: rx.disposeBag)

        tableView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            guard let self = self else { return }
            self.tableView.deselectRow(at: indexPath, animated: true)
            let item = output.items.value[indexPath.row]
            item.dot.accept(false)
            self.delegate?.userShowSetting(controller: self, viewModel: item)
        }).disposed(by: rx.disposeBag)
        
        output.login.bind(to: headerView.rx.model).disposed(by: rx.disposeBag)
        
    }
    


}
