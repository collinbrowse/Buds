//
//  ActivityFeedController.swift
//  Buds
//
//  Created by Collin Browse on 7/19/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import UIKit
import Firebase

class ActivityFeedController: UITableViewController {
    
    @IBOutlet weak var activityFeedTableView: UITableView!
    
    var handle: AuthStateDidChangeListenerHandle?
    var user: User?
    var ref: DatabaseReference!
    var activities = [ActivityModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get a reference to Firebase
        ref = Database.database().reference()
        
        navigationItem.title = "Activity"
        
        // Set up the Table View
        activityFeedTableView.delegate = self
        activityFeedTableView.dataSource = self
        activityFeedTableView.separatorStyle = .singleLine
        activityFeedTableView.register(UINib(nibName: "ActivityFeedCustomCell", bundle: nil), forCellReuseIdentifier: "customActivityCell")
        activityFeedTableView.tableFooterView = UIView(frame: .zero)
        
        
    }
    
    // Check for User's Logged In State
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener{ (auth, user) in
            // If we get a user object back
            if let user = user {
                self.user = user
                self.displayActivityFeed()
            }
            else {
                print("Unable to log in the user")
            }
        }
    }
    
    // Release the Handle when the view leaves
    override func viewWillDisappear(_ animated: Bool) {
        if handle != nil {
            Auth.auth().removeStateDidChangeListener(handle!)
        }
        else {
            // User was never logged in so we don't have to worry about it
        }
    }
    
    func displayActivityFeed() {
        
        // Reset our list of activities
        // This requires downloading all activites from firebase each time ths view is loaded
        // There is likely a better way
        activities.removeAll()
        if (user?.email != nil) {
            print("User is logged in")
            ref.child("activity").observe(.childAdded) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    
                    // Here we are creating an arrary of ActivityModel Objects.
                    // This is the best way to structure the information from firebase as we need
                    // an array to populate the table view
                    let activity = ActivityModel()
                    
                    // Firebase has all the information besides the User's actual name. Let's add that as well
                    activity.setValuesForKeys(dictionary)
                    activity.name = self.user?.displayName
                    self.activities.append(activity)
                    
                    // Since we are currently in a completion handler and UI is done on main thread,
                    // We have to use this method to perform an async call on the main thread
                    DispatchQueue.main.async{ [weak self] in
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
    
}

extension ActivityFeedController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "customActivityCell") as! ActivityFeedCustomCell
        
        
        // Add information to each cell
        if activities.count > 0 {
            cell.nameTextView.text = activities[indexPath.row].name
            cell.locationTextView.text = activities[indexPath.row].location
            cell.timeTextView.text = activities[indexPath.row].time
            cell.strainTextView.text = activities[indexPath.row].strain
            cell.ratingTextView.text = activities[indexPath.row].rating
            cell.smokingStyleTextView.text = activities[indexPath.row].smoking_style
        }
        
        return cell
    }
    
    // How many rows should the table view have?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    // How tall is each row?
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

    
