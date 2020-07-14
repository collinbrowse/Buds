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
    
    
    func showTabBarController(person: Person) {
        let modelController = ModelController()
        modelController.person = person
        Switcher.setUserDefaultsIsSignIn(true)
        Switcher.setUserDefaultsDidSignOut(true)
        Switcher.setUserDefaultsModelController(modelController: modelController)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = BudsTabBarController()
        appDelegate.window?.makeKeyAndVisible()
    }
    
    
    func moveToActivityFeedVC(index: Int) {
        DispatchQueue.main.async {
            let navC = self.tabBarController?.viewControllers![index] as! UINavigationController
            let destVC = navC.viewControllers.first as! ActivityFeedVC
            destVC.showLoadingView()
            destVC.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            destVC.tableView.reloadData()
            self.tabBarController?.selectedViewController = navC
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}
