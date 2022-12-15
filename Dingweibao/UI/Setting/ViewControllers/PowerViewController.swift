//
//  PowerViewController.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/5.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import YYText

protocol PowerViewControllerDelegate: AnyObject {
    
    func powerShowPay(controller: PowerViewController)
    
}

class PowerViewController: ViewController {
    
    var viewModel: PowerViewModel!
    
    weak var delegate: PowerViewControllerDelegate?
    
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "电量提醒"
        setupUI()
        setupBinding()
    }
    
    // MARK: - UI
    
    func setupUI() {
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.register(cellType: PowerTableCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        NotificationAuthManager.shared.authRelay.subscribe(onNext: { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .authorized:
                let headerView = UIView()
                let lbl = UILabel()
                lbl.textColor = .init(hex: "#999999")
                lbl.font = .init(style: .regular, size: 13.uiX)
                lbl.text = "手机电量低时提醒我"
                headerView.addSubview(lbl)
                lbl.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.left.equalToSuperview().offset(15.uiX)
                }
                headerView.frame = .init(x: 0, y: 0, width: 0, height: 39.uiX)
                self.tableView.tableHeaderView = headerView
            default:
                
                let text = NSMutableAttributedString(string: "通知权限未开启，将无法收到提醒通知，")
                text.yy_font = .init(style: .regular, size: 13.uiX)
                text.yy_color = .init(hex: "#FFFFFF")
                
                let a = NSMutableAttributedString(string: "点击开启")
                a.yy_font = .init(style: .regular, size: 12.uiX)
                a.yy_color = .init(hex: "#FFFFFF")
                a.yy_underlineColor = .init(hex: "#FFFFFF")
                a.yy_underlineStyle = .single
                
                let hi = YYTextHighlight()
                hi.tapAction =  { containerView, text, range, rect in
                    if let URL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(URL)
                    }
                };
                a.yy_setTextHighlight(hi, range: a.yy_rangeOfAll())
                text.append(a)
                
                let headerView = UIView()
                let v1 = UIView()
                v1.backgroundColor = .init(hex: "#FF4949")
                let lbl1 = YYLabel()
                lbl1.attributedText = text
                v1.addSubview(lbl1)
                lbl1.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.left.equalToSuperview().offset(15.uiX)
                }
                headerView.addSubview(v1)
                let v2 = UIView()
                let lbl = UILabel()
                lbl.textColor = .init(hex: "#999999")
                lbl.font = .init(style: .regular, size: 13.uiX)
                lbl.text = "手机电量低时提醒我"
                v2.addSubview(lbl)
                lbl.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.left.equalToSuperview().offset(15.uiX)
                }
                headerView.addSubview(v2)
                v1.snp.makeConstraints { make in
                    make.top.left.right.equalToSuperview()
                    make.height.equalTo(44.uiX)
                }
                v2.snp.makeConstraints { make in
                    make.bottom.left.right.equalToSuperview()
                    make.top.equalTo(v1.snp.bottom)
                }
                
                headerView.frame = .init(x: 0, y: 0, width: 0, height: 84.uiX)
                self.tableView.tableHeaderView = headerView
            }
            
        }).disposed(by: rx.disposeBag)
        
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        let input = PowerViewModel.Input(request: errorBtnTap.asObservable().startWith(()))
        let output = viewModel.transform(input: input)
        
        output.items.bind(to: tableView.rx.items(cellIdentifier: PowerTableCell.reuseIdentifier, cellType: PowerTableCell.self)) { (row, element, cell) in
            cell.bind(to: element)
            cell.lineView.isHidden = (row == output.items.value.count - 1)
        }.disposed(by: rx.disposeBag)

        output.showEmptyView.distinctUntilChanged().bind(to: rx.showEmptyView()).disposed(by: rx.disposeBag)
        output.showErrorView.distinctUntilChanged().bind(to: rx.showErrorView()).disposed(by: rx.disposeBag)
        
        output.showVip.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.powerShowPay(controller: self)
        }).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.asObserver().bind(to: view.rx.toastError).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: view.rx.mbHudLoaing).disposed(by: rx.disposeBag)
        
    }
    

}
