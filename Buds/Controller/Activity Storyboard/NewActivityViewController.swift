//
//  ActivityViewController.swift
//  Buds
//
//  Created by Collin Browse on 7/1/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import UIKit
import SVProgressHUD

class NewActivityViewController: UIViewController {
    
    // Hook Up Outlets
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var ratingTextView: UITextView!
    @IBOutlet weak var smokingStylePlaceholderTextView: UITextView!
    @IBOutlet weak var locationPlaceholderTextView: UITextView!
    @IBOutlet weak var ratingPlaceholderTextView: UITextView!
    @IBOutlet weak var strainPlaceholderTextView: UITextView!
    @IBOutlet var collectionOfTextViews: Array<UITextView>! // = [UIView]
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var wrappingDetailsView: UIView!
    
    // Instance Variables
    var selectedDetail: String?
    var ref: DatabaseReference?
    
    // Observed Properties
    var modelController: ModelController! {
        willSet {
            print("Printing the Model Controller Person's name from ProfileVC: \(newValue.person.name)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the Description Text View to the appropriate height
        noteTextView.delegate = self
        textViewDidChange(noteTextView)
        
        // Pull the user's data from the Model, not the network
        if modelController.person.profilePicture != nil {
            self.setUpNavbar(modelController.person.profilePicture!)
        } else {
            // Make a network call to find the profile picture
            Network.getProfilePicture(userID: modelController.person.id) { (profilePicture) in
                self.modelController.person.profilePicture = profilePicture
                self.setUpNavbar(profilePicture)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    
    // Add the User's profile picture to the navigation bar
    func setUpNavbar(_ image: UIImage) {
        
        // Alter the Navigation Bar
        let navigationBar = navigationController!.navigationBar
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        
        // Set up/Gain Access to everything we will need
        let navController = navigationController!
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        let titleView = UIView()
        let profileImageView = UIImageView(image: image)
        
        
        // Create the View in the Title Bar and add the image
        titleView.frame = CGRect(x: 0, y: 0, width: bannerWidth, height: bannerHeight)
        titleView.addSubview(profileImageView)
        
        // Style & Position Image within the titleView
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Finally set the titleView of the nav bar to our new title view
        navigationItem.titleView = titleView
        SVProgressHUD.dismiss()
    }
    
    // Method to show a popup alert to the user if they are unable to register
    func showAlert(success: Bool, alertMessage: String) {
        var title: String
        if success {
            title = "Added Activity"
        }
        else {
            title = "Unable to Add Activity"
        }
        let alert = UIAlertController(title: title, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    // Set up some information when a segue is called
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? NewActivityTableViewController {
            nav.delegate = self
        
            if segue.identifier == "goToSmokingStyle" {
                if let destinationVC = segue.destination as? NewActivityTableViewController {
                    destinationVC.dataToRetrieve = "smoking_styles"
                }
            }
            else if segue.identifier == "goToRating" {
                if let destinationVC = segue.destination as? NewActivityTableViewController {
                    destinationVC.dataToRetrieve = "rating"
                }
            }
            else if segue.identifier == "goToStrain" {
                if let destinationVC = segue.destination as? NewActivityTableViewController {
                    destinationVC.dataToRetrieve = "strain"
                }
            }
        }
        else if let nav = segue.destination as? NewActivityLocationController {
            nav.locationDelegate = self
        }
    }
    
    // send off to firebase
    @IBAction func addBarButtonPressed(_ sender: Any) {
        
        // Add the Details of the Smoking Activity
        var activityDetailsDict = [String : String]()
        activityDetailsDict["user"] = modelController.person.id
        activityDetailsDict["time"] = TimeHelper.getTodayString()
        activityDetailsDict["smoking_style"] = smokingStylePlaceholderTextView.text
        activityDetailsDict["rating"] = ratingPlaceholderTextView.text
        activityDetailsDict["strain"] = strainPlaceholderTextView.text
        activityDetailsDict["location"] = locationPlaceholderTextView.text
        activityDetailsDict["note"] = noteTextView.text
        let userID = modelController.person.id 
        
        // Submit the Activity
        let didAddActivity = Network.addNewActivity(userID: userID, activityDetails: activityDetailsDict)
        
        // Show Alert With Success status
        if (didAddActivity) {
            showAlert(success: didAddActivity, alertMessage: "Your Smoking Activity has been saved in the database!")
            smokingStylePlaceholderTextView.text = ""
            ratingPlaceholderTextView.text = ""
            strainPlaceholderTextView.text = ""
            locationPlaceholderTextView.text = ""
            noteTextView.text = ""
        }
        else {
            showAlert(success: didAddActivity, alertMessage: "Please Try Again")
        }
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
    
    // Helper Function to get the current Date/Time as a String
    func getTodayString() -> String {
        
        // Current time
        let now = Date()
        
        // Let's set the format of date we will be using throughout the app
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // Let's change our date object to that string with that format
        let formattedDateString = formatter.string(from: now)
        
        return formattedDateString
        
    }
    
}
extension NewActivityViewController: ActivityDetailsDelegate {
    
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
    }
    
    
}

extension NewActivityViewController: LocationSearchDelegate {
    
    func setSelectedLocation(location: String) {
        locationPlaceholderTextView.text = location
    }
    
    
}

extension NewActivityViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let heightOfTextView = textView.frame.size.height
        let positionOfTextView = textView.frame.origin.y
        let bottomOfTextView = heightOfTextView + positionOfTextView
        
        if bottomOfTextView > (wrappingDetailsView.frame.size.height - 33) {
            // Text View is off the screen
            textView.isScrollEnabled = true
            print("Scroll Enabled")
            let bottom = NSMakeRange(textView.text.count - 1, 1)
            textView.scrollRangeToVisible(bottom)
            
        }
        else {
            let size = CGSize(width: view.frame.width-40, height: .infinity)
            let estimatedSize = textView.sizeThatFits(size)

            // Loop through the constraints of the textView to find the height
            textView.constraints.forEach { (constraint) in
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
}
