//
//  IndexPathExtension.swift
//  LandeoCalendar
//
//  Created by sebastian on 13.12.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import Foundation

extension IndexPath {
    
    public func isLessThan(_ indexPath: IndexPath) -> Bool {
        if self < indexPath {
            return true
        }
        return false
    }
    
    func increaseRowByOne(sectionEnd: Int) -> IndexPath {
        var row = self.row
        var section = self.section
        if row < sectionEnd {
            row += 1
        } else {
            row = 0
            section += 1
        }
        return IndexPath(row: row, section: section)
    }
    
}
