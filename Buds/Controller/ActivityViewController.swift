//
//  ActivityViewController.swift
//  Buds
//
//  Created by Collin Browse on 7/1/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit

class ActivityViewController: UIViewController {
    
    // Hook Up Outlets
    @IBOutlet weak var currentNameTextView: UITextView!
    @IBOutlet weak var currentLocationTextView: UITextView!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var ratingTextView: UITextView!
    
    @IBOutlet weak var smokingStylePlaceholderTextView: UITextView!
    @IBOutlet weak var locationPlaceholderTextView: UITextView!
    @IBOutlet weak var ratingPlaceholderTextView: UITextView!
    @IBOutlet weak var strainPlaceholderTextView: UITextView!
    
    @IBOutlet var collectionOfTextViews: Array<UITextView>! // = [UIView]

    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var user: User?
    var selectedDetail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Auth.auth().addStateDidChangeListener { auth, user in
//            if let user = user {
//                self.user = user
//            } else {
//                // No User is signed in.
//            }
//        }
        if let viewControllers = self.navigationController?.viewControllers {
            for vc in viewControllers {
                if vc.isKind(of: TableViewController.classForCoder()) {
                    print("It is in stack")
                    //Your Process
                }
                else {
                    print("It is not in stack")
                }
            }
        }
        else {
            print("Unable to find the view controllers")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? TableViewController {
            nav.delegate = self
        }
        if segue.identifier == "goToSmokingStyle" {
            if let destinationVC = segue.destination as? TableViewController {
                destinationVC.dataToRetrieve = "smoking_styles"
            }
        }
        else if segue.identifier == "goToRating" {
            if let destinationVC = segue.destination as? TableViewController {
                destinationVC.dataToRetrieve = "rating"
            }
        }
        else if segue.identifier == "goToStrain" {
            if let destinationVC = segue.destination as? TableViewController {
                destinationVC.dataToRetrieve = "strain"
            }
        }
        else if segue.identifier == "goToLocation" {
            if let destinationVC = segue.destination as? TableViewController {
                destinationVC.dataToRetrieve = "location"
            }
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
extension ActivityViewController: ActivityDetailsDelegate {
    
    func setSelectedDetail(detail: String, value: String) {
        if detail == "smoking_styles" {
            smokingStylePlaceholderTextView.text = value
        }
        else if detail == "rating" {
            ratingPlaceholderTextView.text = value
        }
        else if detail == "strain" {
            strainPlaceholderTextView.text = value
        }
        else if detail == "location" {
            locationPlaceholderTextView.text = value
        }
        print(value)
    }
    
    
}
