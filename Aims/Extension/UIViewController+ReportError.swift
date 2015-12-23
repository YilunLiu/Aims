//
//  UIViewController+ReportError.swift
//  Aims
//
//  Created by Yilun Liu on 12/22/15.
//  Copyright © 2015 Yilun Liu. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    func displayError(error: NSError){
        let alertController = UIAlertController(title: "Error", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}