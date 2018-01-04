//
//  UIViewExtension.swift
//  LandeoCalendar
//
//  Created by sebastian on 15.12.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addShadowView() {
        
        
        
        //Create new shadow view with frame
        let shadowView = UIView(frame: frame)
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 2)
        shadowView.layer.masksToBounds = false
        
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowPath = UIBezierPath(rect: frame).cgPath
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        shadowView.layer.shouldRasterize = true
        
        superview?.insertSubview(shadowView, belowSubview: self)
    }
    
}
