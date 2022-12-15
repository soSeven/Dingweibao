//
//  PayListView.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/4.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PayListView: UIView {
    
    var collectionView: UICollectionView!
    
    var currentIndex: Int?
    
    let items = BehaviorRelay<[PayProductModel]>(value: [])

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 109.uiX, height: 138.uiX)
        layout.minimumLineSpacing = 8.uiX
        layout.minimumInteritemSpacing = 15.uiX
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.register(cellType: PayListCell.self)
        
        items.bind(to: collectionView.rx.items(cellIdentifier: PayListCell.reuseIdentifier, cellType: PayListCell.self)) { [weak self] (row, element, cell) in
            guard let self = self else { return }
            if let current = self.currentIndex , current == row {
                cell.bgView.borderColor = .init(hex: "#27CAB2")
                cell.bgView.borderWidth = 0.5
                cell.bgView.backgroundColor = .init(hex: "#DCFBF7")
            } else {
                cell.bgView.borderColor = .clear
                cell.bgView.borderWidth = 0
                cell.bgView.backgroundColor = .white
            }
            cell.bind(to: element)
        }.disposed(by: rx.disposeBag)
        
        collectionView.rx.itemSelected.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.currentIndex = index.row
            self.collectionView.reloadData()
        }).disposed(by: rx.disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
