//
//  RoundShadowView.swift
//  Dingweibao
//
//  Created by LiQi on 2020/5/27.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class RoundShadowView: UIView {
    
    private var lastBounds: CGRect = .zero
  
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let sc = shadowColor, lastBounds != bounds {
            layer.sublayers?.forEach{$0.removeFromSuperlayer()}
            addShadow(ofColor: sc, radius: shadowRadius, offset: shadowOffset, opacity: shadowOpacity)
            lastBounds = bounds
        }
        
    }
}

class RoundShadowButton: UIButton {
    
    private var lastBounds: CGRect = .zero
  
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let sc = shadowColor, lastBounds != bounds {
//            layer.sublayers?.forEach{$0.removeFromSuperlayer()}
            addShadow(ofColor: sc, radius: shadowRadius, offset: shadowOffset, opacity: shadowOpacity)
            lastBounds = bounds
        }
        
    }
}


