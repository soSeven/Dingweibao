//
//  CircleInfoViewController.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/1.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift

protocol CircleInfoViewControllerDelegate: AnyObject {
    
    func circleInfoShowAuthController(controller: CircleInfoViewController, type: Int)
    func circleInfoShowNameController(controller: CircleInfoViewController, name: String, id: String)
    func circleInfoShowUserController(controller: CircleInfoViewController, circleId: String, user: CircleUserModel)
    func circleInfoDimiss(controller: CircleInfoViewController)
    
}

class CircleInfoViewController: ViewController {
    
    var viewModel: CircleInfoViewModel!
    var circleViewModel: CircleListCellViewModel?
    
    weak var delegate: CircleInfoViewControllerDelegate?
    
    var items: [SectionModel<String, CircleInfoType>] = []
    
    let requestChange = PublishRelay<(type: CircleInfoChangeType, value: String)>()
    let needRequest = PublishRelay<Void>()
    
    let removeRequest = PublishRelay<CircleListCellViewModel>()
    
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "群组资料"
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
        tableView.register(cellType: CircleInfoUserTableCell.self)
        tableView.register(cellType: CircleInfoAvatorTableCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        let removeSubject = PublishSubject<Void>()
        
        let input = CircleInfoViewModel.Input(request: needRequest.asObservable().startWith(()),
                                              requestChange: requestChange,
                                              removeCircle: removeSubject.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<String, CircleInfoType>>(configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .avator:
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CircleInfoAvatorTableCell.self)
                cell.bind(to: item)
                return cell
            case .groupAuth, .groupNumber, .groupName:
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CircleInfoTextTableCell.self)
                cell.bind(to: item)
                if dataSource.sectionModels[indexPath.section].items.count - 1 == indexPath.row {
                    cell.lineView.isHidden = true
                } else {
                    cell.lineView.isHidden = false
                }
                return cell
            case .user:
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CircleInfoUserTableCell.self)
                cell.bind(to: item)
                if dataSource.sectionModels[indexPath.section].items.count - 1 == indexPath.row {
                    cell.lineView.isHidden = true
                } else {
                    cell.lineView.isHidden = false
                }
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
            
            self.circleViewModel?.name.accept(dataItem.info.name)
            self.circleViewModel?.avatar.accept(dataItem.info.avatar)
            
            let footer = UIView(frame: .init(x: 0, y: 0, width: 0, height: 62.uiX))
            let btn = UIButton()
            let att: [NSAttributedString.Key:Any] = [
                .font: UIFont(style: .medium, size: 17.uiX),
                .foregroundColor: UIColor(hex: "#FF3434"),
            ]
            btn.backgroundColor = .white
            if dataItem.isCreater {
                btn.setAttributedTitle(.init(string: "解散本群", attributes: att), for: .normal)
            } else {
                btn.setAttributedTitle(.init(string: "退出该群", attributes: att), for: .normal)
            }
            footer.addSubview(btn)
            btn.snp.makeConstraints { make in
                make.bottom.left.right.equalToSuperview()
                make.height.equalTo(50.uiX)
            }
            btn.rx.tap.bind { _ in
                let message = MessageAlert()
                if dataItem.isCreater {
                    message.titleLbl.text = "温馨提示"
                    message.msgLbl.text = "是否确定解散本群？"
                    let att: [NSAttributedString.Key:Any] = [
                        .font: UIFont(style: .regular, size: 16.uiX),
                        .foregroundColor: UIColor(hex: "#FF5050"),
                    ]
                    message.rightBtn.setAttributedTitle(.init(string: "解散", attributes: att), for: .normal)
                } else {
                    message.titleLbl.text = "温馨提示"
                    message.msgLbl.text = "是否确定退出该群？"
                    let att: [NSAttributedString.Key:Any] = [
                        .font: UIFont(style: .regular, size: 16.uiX),
                        .foregroundColor: UIColor(hex: "#FF5050"),
                    ]
                    message.rightBtn.setAttributedTitle(.init(string: "退出", attributes: att), for: .normal)
                }
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
            case let .groupAuth(_, info, isCreated):
                if !isCreated {
                    return
                }
                self.delegate?.circleInfoShowAuthController(controller: self, type: info.joinAuth)
            case let .groupName(title: _, info: info, isCreated):
                if !isCreated {
                    return
                }
                self.delegate?.circleInfoShowNameController(controller: self, name: info.name, id: self.viewModel.id)
            case let .user(user):
                self.delegate?.circleInfoShowUserController(controller: self, circleId: self.viewModel.id, user: user)
            case let .avator(_, info, isCreated):
                if !isCreated {
                    return
                }
                let v = CircleAvatarsView(avatar: info.avatar)
                v.needDimiss = true
                v.completion = { [weak self] a in
                    guard let self = self else { return }
                    if let a = a {
                        self.requestChange.accept((.avatar, a))
                    }
                }
                v.show()
            default:
                break
            }
        }).disposed(by: rx.disposeBag)
        
        let completion = {[weak self] in
            guard let self = self else { return }
            self.delegate?.circleInfoDimiss(controller: self)
        }
        output.removeSuccess.bind(to: view.rx.mbHudText(completion: completion)).disposed(by: rx.disposeBag)
        if let v = circleViewModel {
            output.removeSuccess.flatMap{ _ in
                return Observable<CircleListCellViewModel>.just(v)
            }.bind(to: removeRequest).disposed(by: rx.disposeBag)
        }
        
        viewModel.loading.asObservable().bind(to: view.rx.mbHudLoaingForce).disposed(by: rx.disposeBag)
        viewModel.parsedError.bind(to: view.rx.toastError).disposed(by: rx.disposeBag)
        
    }

}


extension CircleInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let view = UIView()
        let l = UILabel()
        l.textColor = .init(hex: "#999999")
        l.text = self.items[section].model
        l.font = .init(style: .regular, size: 13.uiX)
        view.addSubview(l)
        l.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15.uiX)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
        
    }
}
