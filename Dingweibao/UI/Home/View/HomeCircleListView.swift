//
//  HomeCircleListView.swift
//  Dingweibao
//
//  Created by LiQi on 2020/5/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeCircleTableCell: TableViewCell {
    
    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#222222")
        l.font = .init(style: .regular, size: 15.uiX)
        return l
    }()
    lazy var numberLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#999999")
        l.font = .init(style: .regular, size: 12.uiX)
        l.text = "群号: 123456"
        return l
    }()
    lazy var arrowImgView: UIImageView = {
        let i = UIImageView(image: UIImage(named: "icon_hook"))
        return i
    }()
    lazy var imgView: UIImageView = {
        let i = UIImageView(image: UIImage(named: "icon_all"))
        return i
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(imgView)
        contentView.addSubview(arrowImgView)
        
        imgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15.uiX)
            make.size.equalTo(CGSize(width: 44.uiX, height: 44.uiX))
        }
        
        let stack = UIStackView(arrangedSubviews: [titleLbl, numberLbl], axis: .vertical, spacing: 5.uiX, alignment: .leading, distribution: .equalSpacing)
        contentView.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imgView.snp.right).offset(10.uiX)
        }
        
        arrowImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-18.uiX)
            make.size.equalTo(CGSize(width: 24.uiX, height: 24.uiX))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to model: CircleListCellViewModel) {
        
        cellDisposeBag = DisposeBag()
        
        model.isChecked.bind { [weak self] isChecked in
            guard let self = self else { return }
            if isChecked {
                self.arrowImgView.isHidden = false
                self.backgroundColor = .init(hex: "#E5FAF7")
            } else {
                self.arrowImgView.isHidden = true
                self.backgroundColor = .clear
            }
        }.disposed(by: rx.disposeBag)
        
        Observable.combineLatest(model.name, model.userCount).bind { [weak self] (name, userCount) in
            guard let self = self else { return }
            let text = "\(String(name))（\(String(userCount))人）"
            self.titleLbl.text = text
        }.disposed(by: rx.disposeBag)
        
        numberLbl.text = "群号: \(String(model.id))";
        
        model.avatar.bind { [weak self] avatar in
            guard let self = self else { return }
            self.imgView.kf.setImage(with: URL(string: avatar), placeholder: UIImage.create("icon_all"))
        }.disposed(by: rx.disposeBag)
        
    }
    
    
}

class HomeCircleListView: UIView {
    
    var tableView: UITableView!
    var titles: [CircleListCellViewModel]
    var selectRelay = PublishRelay<CircleListCellViewModel>()
    var addCircle = PublishRelay<Void>()
    var createCircle = PublishRelay<Void>()
    
    required init(frame: CGRect, titles: [CircleListCellViewModel]) {
        self.titles = titles
        super.init(frame: frame)
        setupUI()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 65.uiX
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.register(cellType: HomeCircleTableCell.self)
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        let v = UIView()
        v.backgroundColor = .white
        addSubview(v)
        v.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(66.uiX)
        }
        
        let btn1 = UIButton()
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#27CBB3"),
        ]
        btn1.cornerRadius = 18.uiX
        btn1.borderColor = .init(hex: "#27CBB3")
        btn1.borderWidth = 1
        btn1.setAttributedTitle(.init(string: "加入群组", attributes: att), for: .normal)
        btn1.rx.tap.bind(to: addCircle).disposed(by: rx.disposeBag)
        
        let btn2 = UIButton()
        let att2: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#ffffff"),
        ]
        btn2.cornerRadius = 18.uiX
        btn2.backgroundColor = .init(hex: "#27CBB3")
        btn2.setAttributedTitle(.init(string: "创建群组", attributes: att2), for: .normal)
        btn2.rx.tap.bind(to: createCircle).disposed(by: rx.disposeBag)
        
        v.addSubview(btn1)
        v.addSubview(btn2)
        btn1.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(36.uiX)
            make.size.equalTo(CGSize(width: 130.uiX, height: 36.uiX))
        }
        btn2.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-36.uiX)
            make.size.equalTo(CGSize(width: 130.uiX, height: 36.uiX))
        }
        
    }
    
    private func setupBinding() {
        
        Observable.just(titles).bind(to: tableView.rx.items(cellIdentifier: HomeCircleTableCell.reuseIdentifier, cellType: HomeCircleTableCell.self)) { (row, element, cell) in
            cell.bind(to: element)
        }.disposed(by: rx.disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            guard let self = self else { return }
            self.titles.forEach{$0.isChecked.accept(false)}
            let model = self.titles[indexPath.row]
            model.isChecked.accept(true)
            self.selectRelay.accept(model)
        }).disposed(by: rx.disposeBag)
    }
    

}
