//
//  ActivityViewController.swift
//  Buds
//
//  Created by Collin Browse on 7/1/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import UIKit

class ActivityViewController: UIViewController {
    
    // Hook Up Outlets
    @IBOutlet weak var currentNameTextView: UITextView!
    @IBOutlet weak var currentLocationTextView: UITextView!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var ratingTextView: UITextView!
    
    
    @IBOutlet var collectionOfTextViews: Array<UITextView>! // = [UIView]

    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Make sure user can't see the cursor when touching these textViews
        for view in collectionOfTextViews {
            view.tintColor = .clear
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSmokingStyle" {
//            if let destinationVC = tabBarViewController?.viewControllers![0] as? ProfileViewController {
//                destinationVC.username = self.username
//            }
            
        }
    }
    
    
    @IBAction func addBarButtonPressed(_ sender: Any) {
        // send off to firebase
    }
    
    @IBAction func smokingStylePressed(_ sender: Any) {
        performSegue(withIdentifier: "goToSmokingStyle", sender: Any?.self)
    }
    
    @IBAction func locationPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToLocation", sender: Any?.self)
    }
    
    @IBAction func ratingPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToRating", sender: Any?.self)
    }
    
    @IBAction func strainPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToStrain", sender: Any?.self)
    }
    
    
}
