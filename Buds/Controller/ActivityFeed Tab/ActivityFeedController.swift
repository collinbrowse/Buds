//
//  ActivityFeedController.swift
//  Buds
//
//  Created by Collin Browse on 7/19/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ActivityFeedController: UITableViewController {
    
    @IBOutlet weak var activityFeedTableView: UITableView!
    
    var handle: AuthStateDidChangeListenerHandle?
    var user: User?
    var ref: DatabaseReference!
    var activities = [Activity]()
    var activitiesDictionary = [String: Activity]()
    var modelController: ModelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UserDefaults.standard.set(false, forKey: "isSignIn")
        
        if Switcher.getUserDefaultsIsSignIn() {
            modelController = Switcher.getUserDefaultsModelController()
        } else {
            Switcher.updateRootViewController()
            return
        }
        
        // Get a reference to Firebase
        ref = Database.database().reference()

        navigationItem.title = "Activity"

         //Set up the Table View
        activityFeedTableView.delegate = self
        activityFeedTableView.dataSource = self
        activityFeedTableView.separatorStyle = .singleLine
        activityFeedTableView.register(UINib(nibName: "ActivityFeedCustomCell", bundle: nil), forCellReuseIdentifier: "customActivityCell")
        activityFeedTableView.tableFooterView = UIView(frame: .zero)
        activityFeedTableView.estimatedRowHeight = 100
        activityFeedTableView.rowHeight = UITableView.automaticDimension
        
//        Network.displayActivityFeed(userID: modelController.person.id) { (activities) in
//            self.activities = activities
//            self.activityFeedTableView.reloadData()
//        }
        
        let destVC = ActivityFeedVC()
        destVC.modelController = modelController
        navigationController?.pushViewController(destVC, animated: true)
        
    }
    
    // Check for User's Logged In State
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // Release the Handle when the view leaves
    override func viewWillDisappear(_ animated: Bool) {

    }
    
}

extension ActivityFeedController {
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customActivityCell") as! ActivityFeedCustomCell
        
        // Add information to each cell
        if activities.count > 0 {
            
            // Populate each cell with information
            cell.nameTextView.text = activities[indexPath.row].name
            cell.locationLabel.text = activities[indexPath.row].location
            cell.timeTextView.text = activities[indexPath.row].date?.timeAgoString()
            cell.strainTextView.text = activities[indexPath.row].strain
            cell.ratingTextView.text = String(activities[indexPath.row].rating)
            cell.smokingStyleTextView.text = activities[indexPath.row].smoking_style
            cell.noteTextView.text = activities[indexPath.row].note
            
            // Grab the Photo From Firebase Storage
            if let photoURL = activities[indexPath.row].profilePictureURL {
                
                let storageRef = Storage.storage().reference(forURL: photoURL)
                storageRef.getData(maxSize: 4*1024*1024, completion: { (data, error) in
                    
                    if let error = error {
                        print("There was an error getting the profile picture: \(error.localizedDescription)")
                        return
                    }
                    if let data = data {
                        // Now that we have our profile picture, we can set that remaining information
                        cell.profilePictureImageView.image = UIImage(data: data)
                    }
                })
            }
        }
        return cell
    }
    
    // How many rows should the table view have?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    // How tall is each row?
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

    

