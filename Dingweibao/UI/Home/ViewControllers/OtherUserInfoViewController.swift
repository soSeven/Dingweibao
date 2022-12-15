//
//  OtherUserInfoViewController.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/2.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift

protocol OtherUserInfoViewControllerDelegate: AnyObject {
    
    func otherUserInfoShowNameController(controller: OtherUserInfoViewController, id: String, info: CircleOtherModel)
    func otherUserDimiss(controller: OtherUserInfoViewController)

}

class OtherUserInfoViewController: ViewController {
    
    var viewModel: OtherUserViewModel!
    
    weak var delegate: OtherUserInfoViewControllerDelegate?
    
    var items: [SectionModel<String, OtherUserType>] = []
    
//    let requestChange = PublishRelay<(type: CircleInfoChangeType, value: String)>()
    let needRequest = PublishRelay<Void>()
    let removeRequest = PublishRelay<Void>()
    
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "成员资料"
        view.backgroundColor = .init(hex: "#F7F7FA")
        
        setupUI()
        setupBinding()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 0.5))
        tableView.tableFooterView = UIView()
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.contentInset = .init(top: 0, left: 0, bottom: UIDevice.safeAreaBottom + 20, right: 0)
        tableView.register(cellType: CircleInfoTextTableCell.self)
        tableView.register(cellType: CircleInfoLocationTableCell.self)
        tableView.register(cellType: CircleInfoAvatorTableCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        let removeSubject = PublishSubject<Void>()
        
        let input = OtherUserViewModel.Input(request: needRequest.asObservable().startWith(()),
                                             requestRemove: removeSubject.asObserver())
        let output = viewModel.transform(input: input)
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<String, OtherUserType>>(configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .avator:
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CircleInfoAvatorTableCell.self)
                cell.bind(to: item)
                return cell
            case .phone, .name, .otherName:
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CircleInfoTextTableCell.self)
                cell.bind(to: item)
                if dataSource.sectionModels[indexPath.section].items.count - 1 == indexPath.row {
                    cell.lineView.isHidden = true
                } else {
                    cell.lineView.isHidden = false
                }
                return cell
            case .location:
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CircleInfoLocationTableCell.self)
                cell.bind(to: item)
                return cell
            }
            
        })
        
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        output.items.bind(to: tableView.rx.items(dataSource: datasource)).disposed(by: rx.disposeBag)
        output.items.bind { [weak self] items in
            guard let self = self else { return }
            self.items = items
        }.disposed(by: rx.disposeBag)
        
        output.dataItem.subscribe(onNext: { [weak self] dataItem in
            guard let self = self else { return }
            if !dataItem.isCreater {
                self.tableView.tableFooterView = UIView()
                return
            }
            let footer = UIView(frame: .init(x: 0, y: 0, width: 0, height: 50.uiX))
            let btn = UIButton()
            let att: [NSAttributedString.Key:Any] = [
                .font: UIFont(style: .medium, size: 17.uiX),
                .foregroundColor: UIColor(hex: "#FF3434"),
            ]
            btn.backgroundColor = .white
            btn.setAttributedTitle(.init(string: "移出本群", attributes: att), for: .normal)
            footer.addSubview(btn)
            btn.snp.makeConstraints { make in
                make.bottom.left.right.equalToSuperview()
                make.height.equalTo(50.uiX)
            }
            btn.rx.tap.bind { _ in
                let message = MessageAlert()
                message.titleLbl.text = "确定将该成员移出群？"
                message.msgLbl.text = "移出后，将无法查看Ta的位置，群内成员位置也无法被Ta查看"
                let att: [NSAttributedString.Key:Any] = [
                    .font: UIFont(style: .regular, size: 16.uiX),
                    .foregroundColor: UIColor(hex: "#FF5050"),
                ]
                message.rightBtn.setAttributedTitle(.init(string: "移出", attributes: att), for: .normal)
                message.show()
                message.rightBtn.rx.tap.subscribe(onNext: { _ in
                    removeSubject.onNext(())
                }).disposed(by: self.rx.disposeBag)
            }.disposed(by: self.rx.disposeBag)
            self.tableView.tableFooterView = footer
        }).disposed(by: rx.disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            guard let self = self else { return }
            self.tableView.deselectRow(at: indexPath, animated: true)
            let model = self.items[indexPath.section].items[indexPath.row]
            switch model {
            case let .otherName(title: _, info):
                self.delegate?.otherUserInfoShowNameController(controller: self, id: self.viewModel.id, info: info)
            default:
                break
                
            }
            
        }).disposed(by: rx.disposeBag)
        
        let completion = {[weak self] in
            guard let self = self else { return }
            self.delegate?.otherUserDimiss(controller: self)
        }
        output.removeSuccess.bind(to: view.rx.mbHudText(completion: completion)).disposed(by: rx.disposeBag)
        output.removeSuccess.flatMap{_ in return Observable.just(())}.bind(to: removeRequest).disposed(by: rx.disposeBag)
        
        viewModel.loading.asObservable().bind(to: view.rx.mbHudLoaingForce).disposed(by: rx.disposeBag)
        viewModel.parsedError.bind(to: view.rx.toastError).disposed(by: rx.disposeBag)
        
    }

}


extension OtherUserInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12.uiX
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
        
    }
    
}
