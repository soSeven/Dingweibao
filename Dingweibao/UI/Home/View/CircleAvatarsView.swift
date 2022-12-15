//
//  CircleAvatarsView.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import SwiftEntryKit
import RxSwift
import RxCocoa
import MBProgressHUD
import SwifterSwift
import RxDataSources

class CircleAvatarsView: UIView {
    
    var collectionView: UICollectionView!
    let viewModel = CircleAvatarsViewModel()
    var needDimiss = false
    
    var avatar: String?
    var completion: ((String?)->())?
    
    init(avatar: String?) {
        super.init(frame: .zero)
        self.avatar = avatar
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        let topView = UIView()
        addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(53.uiX)
        }
        
        let lbl = UILabel()
        lbl.text = "群组图标"
        lbl.textColor = .init(hex: "#222222")
        lbl.textAlignment = .center
        lbl.font = .init(style: .medium, size: 18.uiX)
        topView.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let btn = UIButton()
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#999999"),
        ]
        btn.setAttributedTitle(.init(string: "取消", attributes: att), for: .normal)
        btn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            SwiftEntryKit.dismiss()
            self.completion?(self.avatar)
        }).disposed(by: rx.disposeBag)
        topView.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15.uiX)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = .init(hex: "#EDEDED")
        topView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.right.bottom.equalToSuperview()
        }
        
        let contentView = UIView()
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(475.uiX)
            make.top.equalTo(topView.snp.bottom)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 64.uiX, height: 64.uiX)
        layout.minimumLineSpacing = 15.uiX
        layout.minimumInteritemSpacing = 20.uiX
        layout.sectionInset = .init(top: 0, left: 15.uiX, bottom: 0, right: 15.uiX)
        layout.headerReferenceSize = .init(width: 200, height: 50.uiX)
        collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .clear
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 20.uiX, right: 0)
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().priority(.init(900))
        }
        
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: CircleAvatarHeaderView.self)
        collectionView.register(cellType: CircleAvatarCell.self)
        
        setupBinding()
  
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        let input = CircleAvatarsViewModel.Input(request: Observable<Void>.just(()))
        let output = viewModel.transform(input: input)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, CircleAvatarModel>>(configureCell: { (dataSource, collectionView, indexPath, model) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CircleAvatarCell.self)
            cell.bind(to: model)
            if let a = self.avatar, a == model.avatar {
                cell.checkView.isHidden = false
                cell.imgView.borderColor = .init(hex: "#27CBB3")
                cell.imgView.borderWidth = 2.uiX
            } else {
                cell.checkView.isHidden = true
                cell.imgView.borderColor = .clear
                cell.imgView.borderWidth = 0
            }
            return cell
        }, configureSupplementaryView: { data, collection, title, index -> UICollectionReusableView in
            let head = collection.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: index, viewType: CircleAvatarHeaderView.self)
            let section = data.sectionModels[index.section]
            head.lbl.text = section.model
            return head
        })
        
        output.items.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)
        collectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            let model = output.items.value[indexPath.section].items[indexPath.row]
            if self.avatar == model.avatar {
                return
            }
            self.avatar = model.avatar
            self.collectionView.reloadData()
            self.completion?(model.avatar)
            if self.needDimiss {
                SwiftEntryKit.dismiss()
            }
        }).disposed(by: rx.disposeBag)
        
        viewModel.loading.asObservable().bind(to: rx.mbHudLoaing).disposed(by: rx.disposeBag)
        viewModel.parsedError.bind(to: rx.toastError).disposed(by: rx.disposeBag)
        
    }


    // MARK: - Show
    
    func show() {
        
        var attributes = EKAttributes.bottomToast
        
        attributes.screenBackground = .color(color: .init(.init(white: 0, alpha: 0.6)))
        attributes.entryBackground = .color(color: .white)
        attributes.screenInteraction = .absorbTouches
        attributes.entryInteraction = .absorbTouches
        attributes.displayDuration = .infinity
        attributes.scroll = .disabled
        
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        
        SwiftEntryKit.display(entry: self, using: attributes)
    }

}
