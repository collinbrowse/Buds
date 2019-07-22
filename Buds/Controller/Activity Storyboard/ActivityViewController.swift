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

class ActivityViewController: UIViewController {
    
    // Hook Up Outlets
    @IBOutlet weak var profilePictureImageView: UIImageView!
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
    
    var handle: AuthStateDidChangeListenerHandle?
    var user: User?
    var selectedDetail: String?
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show()
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.user = user
                self.ref = Database.database().reference()
                self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.width / 2
                self.profilePictureImageView.clipsToBounds = true
                self.loadUser()
            } else {
                // No User is signed in.
                SVProgressHUD.dismiss()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if handle != nil {
            Auth.auth().removeStateDidChangeListener(handle!)
        }
    }
    
    func loadUser() {
        if user?.email != nil {
            ref!.child("users").child(user!.uid).observeSingleEvent(of: .value) { (snapshot) in
                // Get the Profile Picture, Name, Location
                if let dictionary = snapshot.value as? NSDictionary {
                    self.currentNameTextView.text = dictionary["name"] as? String
                    self.currentLocationTextView.text = dictionary["location"] as? String
                    
                    if let profilePictureURL = dictionary["profilePicture"] as? String {
                        let firebaseStorageRef = Storage.storage().reference(forURL: profilePictureURL)
                        firebaseStorageRef.getData(maxSize: 4*1024*1024, completion: { (data, error) in
                            if let error = error {
                                print("There was an error getting this data \(error.localizedDescription)")
                                // Profile Picture already has a default value
                                return
                            }
                            if let data = data {
                                self.profilePictureImageView.image = UIImage(data: data)
                                
                                SVProgressHUD.dismiss()
                            }
                        })
                    }
                }
            }
        }
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
        if let nav = segue.destination as? SmokingActivityTableViewController {
            nav.delegate = self
        
            if segue.identifier == "goToSmokingStyle" {
                if let destinationVC = segue.destination as? SmokingActivityTableViewController {
                    destinationVC.dataToRetrieve = "smoking_styles"
                }
            }
            else if segue.identifier == "goToRating" {
                if let destinationVC = segue.destination as? SmokingActivityTableViewController {
                    destinationVC.dataToRetrieve = "rating"
                }
            }
            else if segue.identifier == "goToStrain" {
                if let destinationVC = segue.destination as? SmokingActivityTableViewController {
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
        activityDetailsDict["user"] = user?.uid 
        activityDetailsDict["time"] = getTodayString()
        activityDetailsDict["smoking_style"] = smokingStylePlaceholderTextView.text
        activityDetailsDict["rating"] = ratingPlaceholderTextView.text
        activityDetailsDict["strain"] = strainPlaceholderTextView.text
        activityDetailsDict["location"] = locationPlaceholderTextView.text
        activityDetailsDict["note"] = noteTextField.text
        let userID = user?.uid ?? ""
        
        // Submit the Activity
        let didAddActivity = Network.addNewActivity(userID: userID, activityDetails: activityDetailsDict)
        
        // Show Alert With Success status
        if (didAddActivity) {
            showAlert(success: didAddActivity, alertMessage: "Your Smoking Activity has been saved in the database!")
            smokingStylePlaceholderTextView.text = ""
            ratingPlaceholderTextView.text = ""
            strainPlaceholderTextView.text = ""
            locationPlaceholderTextView.text = ""
            noteTextField.text = ""
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
    func getTodayString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        
        return today_string
        
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
    }
    
    
}

extension ActivityViewController: LocationSearchDelegate {
    
    func setSelectedLocation(location: String) {
        locationPlaceholderTextView.text = location
    }
    
    
}
