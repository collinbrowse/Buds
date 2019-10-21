//
//  RegisterViewController.swift
//  Buds
//
//  Created by Collin Browse on 6/25/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import SVProgressHUD
import CryptoSwift
import MapKit

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //Pre-linked IBOutlets
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var birthdayTextfield: UITextField! // This will be converted to a date picked in the future
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    private var datePicker: UIDatePicker?
    var username: String!
    
    var ref: DatabaseReference!
    var modelController: ModelController!
    
    //Location Search MapKit
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    // Location Search UI elements
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firebase Realtime Database
        ref = Database.database().reference()
        
        // Set up a DatePicker Field for the birthday
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self,
                              action: #selector(RegisterViewController.dateChanged(datePicker:)),
                              for: .valueChanged)
        
        // Add a Tap Gesture Recognizer to close the date picker if the user touches away
        let datePickerTapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(RegisterViewController.viewTapped(gestureRecognizer: )))
        view.addGestureRecognizer(datePickerTapGesture)
        birthdayTextfield.inputView = datePicker
        
        
        // Add a Tap Gesture to allow the user to select a profile image
        let profilePictureTapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(profilePictureTapped))
        profilePictureImageView.addGestureRecognizer(profilePictureTapGesture)
        
    }
    
    func application(_ application: UIApplication,
                        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    // Selector: Action to perform when user touches away from date picker
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // Selector: Action to perform when the date changes
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        birthdayTextfield.text = dateFormatter.string(from: datePicker.date)
    }
    
    // Selector: Action to perform when the profile image is clicked
    @objc func profilePictureTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        }
        if let originalImage = info[.originalImage] as? UIImage  {
            selectedImage = originalImage
        }
        
        if let image = selectedImage {
            profilePictureImageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Show/Hide the Password field
    @IBAction func viewIconClicked(_ sender: Any) {
        passwordTextfield.isSecureTextEntry.toggle()
    }
    
    // Respond to user pressing register button.
    @IBAction func registerPressed(_ sender: AnyObject) {
        SVProgressHUD.show()
        let email = emailTextfield.text
        var password = passwordTextfield.text
        let username = usernameTextfield.text
        let name = nameTextfield.text
        let location = locationTextField.text
        let birthday = birthdayTextfield.text
        passwordTextfield.text = nil
        
        if (!email!.isEmpty && !password!.isEmpty && !username!.isEmpty
            && !name!.isEmpty && !location!.isEmpty && !birthday!.isEmpty
            && isValidEmail(emailID: email!)) {
            //password = passwordHash(username: username!, password: password!)
            registerUser(name: name!, location: location!, birthday: birthday!, username: username!, email: email!, password: password!)
            password = nil 
        }
        else {
            SVProgressHUD.dismiss()
            self.showAlert(alertMessage: "All Fields Must Be Filled Out")
        }
       
    }
    
    // If user starts editing the location field, send them to Location Search Controller
    @IBAction func locatonFieldDidBeginEditing(_ sender: Any) {
        performSegue(withIdentifier: "goToLocationSearch", sender: self)
        
    }
    
    // Method to show a popup alert to the user if they are unable to register
    func showAlert(alertMessage: String) {
        let alert = UIAlertController(title: "Unable to Register", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    
    // Let's Handle some tasks before we perform the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // If the user tried to log in....
        if segue.identifier == "goToHomeFromRegister" {
            let tabBarViewController = segue.destination as? UITabBarController
            if let destinationVC = tabBarViewController?.viewControllers![0] as? ProfileViewController {
                destinationVC.username = self.username
                destinationVC.modelController = modelController
                print("RegisterViewController.modelController -> ProfileViewController")
            }
        }
        // If the user wants to enter a locations...
        else if segue.identifier == "goToLocationSearch" {
            // Let LocationSearchBarController know that this class will handle any responses it has
            if let destinationVC = segue.destination as? LocationSearchBarController {
                destinationVC.locationDelegate = self
            }
        }
        
    }
    
    // This function registers a user with Firebase Authentication
    // If sucessful we then log them in/authenticate them
    // Then we send the rest of their data to Realtime Database
    func registerUser(name: String, location: String, birthday: String, username: String, email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (createUserAuthResult, createUserError) in
            if createUserError == nil {
                Auth.auth().signIn(withEmail: email, password: password, completion: { (signedInAuthResult, signedInError) in
                    if signedInError == nil {
                        
                        
                        // Send their Picture to Firebase Storage
                        // Add each profile picture to the 'profile_pictures' folder wth a random ID as the filename
                        let storageRef = Storage.storage().reference(withPath: "/images/profile_pictures/\(username)/profile_picture.jpg")
                        
                        // Create the binary data from the UIImageView
                        guard let imageData = self.profilePictureImageView.image?.jpegData(compressionQuality: 0.5) else { return }
                        
                        // Add Some MetaData so that Firebase has more information that this is a picture
                        let uploadMetaData = StorageMetadata.init()
                        uploadMetaData.contentType = "image/jpeg"
                        
                        // Send off to Firebase Storage
                        storageRef.putData(imageData, metadata: uploadMetaData, completion: { (storageMetaData, error) in
                            if let error = error {
                                print("There was an error uploading to Firebase Storage: \(error.localizedDescription)")
                            }
                            else {
                                // You can access the download URL after upload.
                                storageRef.downloadURL { (url, error) in
                                    guard let downloadURL = url else { return }
                                    // Send their data to Realtime Database
                                    let userData = ["name": name, "location": location, "birthday": birthday, "username": username, "email": email, "profilePictureURL": downloadURL.absoluteString]
                                    self.ref.child("users").child((createUserAuthResult?.user.uid)!).setValue(userData)
                                    
                                    // Once Data is in Realtime Database let's update the user profile in
                                    // Firebase Auth
                                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                    changeRequest?.displayName = name
                                    changeRequest?.photoURL = downloadURL.absoluteURL
                                    changeRequest?.commitChanges { (error) in
                                        if let error = error {
                                            self.showAlert(alertMessage: "Unable to Register User: \(error.localizedDescription)")
                                        }
                                        else {
                                            // If we are here all firebase storage is a success and we can move on
                                            
                                            var person = Person(id: Auth.auth().currentUser!.providerID, name: name, email: email, location: location, birthday: birthday, profilePictureURL: "self.profilePictureImageView.image!")
                                            person.profilePicture = self.profilePictureImageView.image!
                                            self.modelController.person = person
                                            SVProgressHUD.dismiss()
                                            self.performSegue(withIdentifier: "goToHomeFromRegister", sender: self)
                                        }
                                    }
                                    
                                    
                                }
                                
                            }
                        })
                    } else {
                        self.showAlert(alertMessage: signedInError!.localizedDescription)
                    }
                })
            }
            else {
                self.showAlert(alertMessage: createUserError!.localizedDescription)
            }
        }
    }
    
    // Regex to validate an email
    func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
    
    
}

extension RegisterViewController: LocationSearchDelegate {
    
    // Will Set the Location Field to the response from
    // LocationSearchController
    func setSelectedLocation(location: String) {
        locationTextField.text = location
        birthdayTextfield.becomeFirstResponder()
    }
    
    
}
