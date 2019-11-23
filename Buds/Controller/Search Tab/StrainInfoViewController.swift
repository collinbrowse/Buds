//
//  StrainInfoViewController.swift
//  Buds
//
//  Created by Collin Browse on 11/22/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import UIKit

class StrainInfoViewController: UIViewController {
    
    var modelController: ModelController!

    @IBOutlet weak var strainBackgroundImage: UIImageView!
    @IBOutlet weak var strainLabel: UILabel!
    var strain: String?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make sure the user is signed in
        if Switcher.getUserDefaultsIsSignIn() {
           modelController = Switcher.getUserDefaultsModelController()
        } else {
            Switcher.updateRootViewController()
        }
        
        
        // Let's hide the navigation Bar
        self.navigationController?.isNavigationBarHidden = true

        // Add the strain's name
        strainLabel.text = strain
        
        // Let's make the image 1/3 the height of the view
        for constraint in strainBackgroundImage.constraints {
            if constraint.identifier == "strainBackgroundImageHeightConstraint" {
                constraint.constant = self.view.frame.size.height / 3
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
