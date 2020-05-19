//
//  UIViewController+Ext.swift
//  Buds
//
//  Created by Collin Browse on 5/19/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit


extension UIViewController {
    
    func presentBudsAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        
        DispatchQueue.main.async {
            let alertVC = BudsAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
}
