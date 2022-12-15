//
//  MyViewController.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/5.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift
import YPImagePicker

protocol MyViewControllerDelegate: AnyObject {
    func myShowUserType(controller: MyViewController, type: MyCellType)
}

class MyViewController: ViewController {
    
    var viewModel: MyViewModel!
    
    weak var delegate: MyViewControllerDelegate?
    
    var items: [SectionModel<String, MyCellType>] = []
    
    let requestChange = PublishRelay<(type: CircleInfoChangeType, value: String)>()
    let needRequest = PublishRelay<Void>()
    
    let removeSubject = PublishSubject<Void>()
    
    let imageRelay = PublishRelay<UIImage>()
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "我的资料"
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
        
        let footer = UIView(frame: .init(x: 0, y: 0, width: 0, height: 62.uiX))
        let btn = UIButton()
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .medium, size: 17.uiX),
            .foregroundColor: UIColor(hex: "#FF3434"),
        ]
        btn.backgroundColor = .white
        btn.setAttributedTitle(.init(string: "退出登录", attributes: att), for: .normal)
        btn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let message = MessageAlert()
            message.titleLbl.text = "温馨提示"
            message.msgLbl.text = "是否确定退出登录？"
            message.show()
            message.rightBtn.rx.tap.subscribe(onNext: { _ in
                self.removeSubject.onNext(())
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        footer.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(50.uiX)
        }
        tableView.tableFooterView = footer
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        let input = MyViewModel.Input(request: needRequest.asObservable(),
                                      requestRemove: removeSubject.asObserver(),
                                      saveImage: imageRelay.asObservable())
        
        let output = viewModel.transform(input: input)
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<String, MyCellType>>(configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .avator:
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CircleInfoAvatorTableCell.self)
                cell.bind(to: item)
                return cell
            case .name, .phone:
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CircleInfoTextTableCell.self)
                cell.bind(to: item)
                if dataSource.sectionModels[indexPath.section].items.count - 1 == indexPath.row {
                    cell.lineView.isHidden = true
                } else {
                    cell.lineView.isHidden = false
                }
                return cell
            }
            
        })
        
        output.items.bind(to: tableView.rx.items(dataSource: datasource)).disposed(by: rx.disposeBag)
        output.items.bind { [weak self] items in
            guard let self = self else { return }
            print(items)
            self.items = items
        }.disposed(by: rx.disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            guard let self = self else { return }
            self.tableView.deselectRow(at: indexPath, animated: true)
            let model = self.items[indexPath.section].items[indexPath.row]
            switch model {
            case .avator:
                var config = YPImagePickerConfiguration()
                config.albumName = "定位宝"
                config.targetImageSize = .cappedTo(size: 1024)
                let picker = YPImagePicker(configuration: config)
                picker.didFinishPicking { [unowned picker, weak self] items, _ in
                    guard let self = self else { return }
                    if let photo = items.singlePhoto {
                        self.imageRelay.accept(photo.image)
                    }
                    picker.dismiss(animated: true, completion: nil)
                }
                self.present(picker, animated: true, completion: nil)
            case let .phone(_, info):
                if let m = info.mobile, !m.isEmpty {
                    break
                } else {
                    self.delegate?.myShowUserType(controller: self, type: model)
                }
            default:
                self.delegate?.myShowUserType(controller: self, type: model)
            }
            
        }).disposed(by: rx.disposeBag)
        
        output.showSuccess.bind(to: view.rx.mbHudText).disposed(by: rx.disposeBag)
        
        viewModel.loading.asObservable().bind(to: view.rx.mbHudLoaingForce).disposed(by: rx.disposeBag)
        viewModel.parsedError.bind(to: view.rx.toastError).disposed(by: rx.disposeBag)
        
    }

}
