//
//  UserAnnotationView.swift
//  Dingweibao
//
//  Created by LiQi on 2020/5/28.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserAnnotationView: MAAnnotationView {
    
    private var disposeBag = DisposeBag()
    
    let userImgView = UIImageView()
    private let bgImgView = UIImageView(image: UIImage.create("bg_position"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override init!(annotation: MAAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        addSubview(bgImgView)
        addSubview(userImgView)
        userImgView.backgroundColor = .systemPink
        userImgView.cornerRadius = 24.uiX
        
        bgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        userImgView.snp.makeConstraints { make in
            make.width.equalTo(48.uiX)
            make.height.equalTo(48.uiX)
            make.top.equalToSuperview().offset(10.uiX)
            make.centerX.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSelectedStatus(selected: Bool) {
        bgImgView.image = isSelected ? UIImage.create("bg_position2") : UIImage.create("bg_position")
    }
    
    func bind(to model: HomeUserItemCellViewModel) {
        disposeBag = DisposeBag()
        
        model.avatar.subscribe(onNext: { [weak self] avatar in
            guard let self = self else { return }
            self.userImgView.kf.setImage(with: URL(string: avatar), placeholder: UIImage.create("my_pic_headportrait"))
        }).disposed(by: disposeBag)
        
    }
    
}
