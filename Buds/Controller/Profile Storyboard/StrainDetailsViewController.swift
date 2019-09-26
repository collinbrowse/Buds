//
//  StrainDetailsViewController.swift
//  Buds
//
//  Created by Collin Browse on 9/26/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import UIKit

class StrainDetailsViewController: UIViewController {
    
    var modelController: ModelController! {
        willSet {
            print("Printing the Model Controller Person's name from ProfileVC: \(newValue.person.name)")
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBOutlet weak var strainBackgroundImage: UIImageView!
    @IBOutlet weak var youSaidLabel: UILabel!
    @IBOutlet weak var strainLabel: UILabel!
    var strainLabelText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        youSaidLabel.sizeToFit()
        // Set up background Picture
        for constraint in strainBackgroundImage.constraints {
            if constraint.identifier == "strainBackgroundImageHeightConstraint" {
                constraint.constant = self.view.frame.size.height / 3
            }
        }
        view.layoutIfNeeded()
                strainLabel.text = strainLabelText
        // Set up Strain Name
        
        // Same up text below
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
}
