//
//  CalendarViewDateSelection.swift
//  LandeoCalendar
//
//  Created by sebastian on 22.12.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import Foundation
import UIKit
    
public extension CalendarView {
        
    fileprivate func selectDate(_ date : Date) {
        guard let indexPath = self.indexPathForDate(date) else { return }
        self.collectionView!.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
        self.collectionView(collectionView!, didSelectItemAt: indexPath)
    }
    
    fileprivate func deselectDate(_ date : Date) {
        guard let indexPath = self.indexPathForDate(date) else { return }
        self.collectionView!.deselectItem(at: indexPath, animated: false)
        self.collectionView(collectionView!, didSelectItemAt: indexPath)
    }
        
}


