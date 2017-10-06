//
//  ViewControllerExtension.swift
//  LandeoCalendar
//
//  Created by sebastian on 06.10.2017.
//  Copyright © 2017 AppLandeo. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(_ message: String) {
        showAlert(message, andTitle: "")
    }
    
    func showAlert(_ message: String, andTitle title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
