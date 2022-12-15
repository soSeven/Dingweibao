//
//  SettingViewController.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/8.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SettingViewControllerDelegate: AnyObject {
    
    func settingShowType(controller: SettingViewController, type: SettingType)
    
}

class SettingViewController: ViewController {
    
    var viewModel: SettingViewModel!
    
    weak var delegate: SettingViewControllerDelegate?
    
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "设置"
        setupUI()
        setupBinding()
    }
    
    // MARK: - UI
    
    func setupUI() {
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 55.uiX
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.register(cellType: SettingTableCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        let input = SettingViewModel.Input(request: Observable<Void>.just(()))
        let output = viewModel.transform(input: input)
        
        output.items.bind(to: tableView.rx.items(cellIdentifier: SettingTableCell.reuseIdentifier, cellType: SettingTableCell.self)) { (row, element, cell) in
            cell.bind(to: element)
            cell.lineView.isHidden = (row == output.items.value.count - 1)
        }.disposed(by: rx.disposeBag)

        tableView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            guard let self = self else { return }
            let type = output.items.value[indexPath.row]
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.delegate?.settingShowType(controller: self, type: type)
            
        }).disposed(by: rx.disposeBag)
        
    }
    

}
