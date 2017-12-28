//
//  SelectionButtons.swift
//  LandeoCalendar
//
//  Created by sebastian on 21.12.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit

class SelectionButtons: UIButton {

    override var isSelected: Bool {
        didSet {
            setSelection()
        }
    }
    
    override func awakeFromNib() {
        setStyling()
    }
    
    func setStyling() {
        self.layer.cornerRadius = 9
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    func setSelection() {
        if isSelected {
            setTitleColor(UIColor.black, for: .selected)
        }
    }
    
}
