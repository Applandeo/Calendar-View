//
//  CollectionViewExtension.swift
//  Calendar
//
//  Created by Sebastian Grabiński on 07.10.2017.
//  Copyright © 2017 AppLandeo. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func scrollToIndexpathByShowingHeader(_ indexPath: IndexPath) {
        let sections = self.numberOfSections
        
        if indexPath.section <= sections{
            guard let attributes = self.layoutAttributesForSupplementaryElement(ofKind: UICollectionElementKindSectionHeader, at: indexPath) else { return }
            let topOfHeader = CGPoint(x: 0, y: attributes.frame.origin.y - self.contentInset.top)
            self.setContentOffset(topOfHeader, animated:false)
        }
    }
}
