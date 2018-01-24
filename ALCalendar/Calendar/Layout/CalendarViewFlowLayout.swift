//
//  CalendarViewFlowLayout.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 21.09.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit

open class CalendarFlowLayout: UICollectionViewFlowLayout {
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)?.map {
            attributes in
            let layoutAttributes = attributes.copy() as! UICollectionViewLayoutAttributes
            self.applyLayoutAttributes(layoutAttributes)
            return layoutAttributes
        }
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = super.layoutAttributesForItem(at: indexPath) {
            let layoutAttributes = attributes.copy() as! UICollectionViewLayoutAttributes
            self.applyLayoutAttributes(layoutAttributes)
            return layoutAttributes
        }
        return nil
    }
    
    func applyLayoutAttributes(_ attributes : UICollectionViewLayoutAttributes) {
        if attributes.representedElementKind != nil { return }
        if let collectionView = self.collectionView {
            
            let stride = (self.scrollDirection == .horizontal) ? collectionView.frame.size.width : collectionView.frame.size.height
            let offset = CGFloat((attributes.indexPath as NSIndexPath).section) * stride
            var xCellOffset : CGFloat = CGFloat((attributes.indexPath as NSIndexPath).item % 7) * self.itemSize.width
            var yCellOffset : CGFloat = CGFloat((attributes.indexPath as NSIndexPath).item / 7) * self.itemSize.height
            
            if self.scrollDirection == .horizontal {
                xCellOffset += offset;
            } else {
                yCellOffset += offset
            }
            attributes.frame = CGRect(x: xCellOffset, y: yCellOffset, width: self.itemSize.width, height: self.itemSize.height)
        }
        
    }
    
}
