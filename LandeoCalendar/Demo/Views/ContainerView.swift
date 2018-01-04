//
//  ContainerView.swift
//  LandeoCalendar
//
//  Created by sebastian on 21.12.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit

class ContainerView: UIView {

    var shadowLayer: CAShapeLayer!
    var shadowAdded: Bool = false

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if shadowAdded { return }
        shadowAdded = true
        
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = layer.cornerRadius > 0
        
        let shadowLayer = UIView(frame: self.frame)
        shadowLayer.backgroundColor = UIColor.clear
        shadowLayer.layer.shadowColor = UIColor.darkGray.cgColor
        shadowLayer.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.layer.cornerRadius).cgPath
        shadowLayer.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        shadowLayer.layer.shadowOpacity = 0.5
        shadowLayer.layer.shadowRadius = 2
        shadowLayer.layer.masksToBounds = true
        shadowLayer.clipsToBounds = false
        
        self.superview?.addSubview(shadowLayer)
        self.superview?.bringSubview(toFront: self)
        
        
    }

}
