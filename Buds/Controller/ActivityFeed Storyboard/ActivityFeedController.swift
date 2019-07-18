//
//  ActivityFeedController.swift
//  Buds
//
//  Created by Collin Browse on 7/17/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import UIKit
import Firebase

class ActivityFeedController: UITableViewController {
    
    @IBOutlet weak var activityFeedTableView: UITableView!
    
    var handle: AuthStateDidChangeListenerHandle?
    var user: User?
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad()")
        activityFeedTableView.delegate = self
        ref = Database.database().reference()
        
        
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
        if (user?.email != nil) {
            print("User is logged in")
            ref.child("activity").observeSingleEvent(of: .value) { (snapshot) in
                for childSnap in  snapshot.children.allObjects {
                    let snap = childSnap as! DataSnapshot
                    if let snapshotValue = snapshot.value as? NSDictionary, let snapVal = snapshotValue[snap.key] as? AnyObject {
                        print("val" , snapVal)
                    }
                }
            }
        }
    }
    
}
