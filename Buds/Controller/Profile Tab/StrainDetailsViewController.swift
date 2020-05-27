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
    
    var modelController: ModelController!
    
    @IBOutlet weak var strainBackgroundImage: UIImageView!
    @IBOutlet weak var youSaidLabel: UILabel!
    @IBOutlet weak var strainLabel: UILabel!
    @IBOutlet weak var youDidntLikeDescriptionText: UILabel!
    @IBOutlet weak var youLikedDescriptionText: UILabel!
    @IBOutlet weak var generalNotesText: UILabel!
    var strainLabelText: String?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
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
        
        let strainLabelTextWithUnderscores = strainLabelText!.lowercased().replacingOccurrences(of: " ", with: "_")
        
        // Get the user generated data for that strain
//        Network.getStrainDetailsForUser(userID: modelController.person.id, strain: strainLabelTextWithUnderscores) { (userStrainData) in
//            
//            
//            // Info is contained in userStrainData as [String : String]
//            if let desc = userStrainData["personal_positive_experience"] {
//                    self.youLikedDescriptionText.text = desc
//            } else {
//                self.youLikedDescriptionText.text = "You didn't add anything you liked"
//            }
//            if let desc = userStrainData["personal_negative_experience"] {
//                self.youDidntLikeDescriptionText.text = desc
//            } else {
//                self.youDidntLikeDescriptionText.text = "You didn't add anything you liked"
//            }
//            if let desc = userStrainData["general_notes"] {
//                    self.generalNotesText.text = desc
//            } else {
//                self.generalNotesText.text = "You didn't add anything you liked"
//            }
//        }
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
}
