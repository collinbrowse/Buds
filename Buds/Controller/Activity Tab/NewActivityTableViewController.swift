//
//  TableViewController.swift
//  Buds
//
//  Created by Collin Browse on 7/2/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class NewActivityTableViewController: UITableViewController {
    
    var ref: DatabaseReference!
    var detailsListArray: [String] = []
    var effectsDict = [String: String]()
    var dataToRetrieve: String?
    var delegate: ActivityDetailsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Set Up Navigation Bar
        navigationItem.title = dataToRetrieve?.capitalized
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        ref = Database.database().reference()
        
        // Get all of the information from Firebase in ViewDidLoad
        // Small amount of information should be negligible on performance
        if dataToRetrieve != nil {
            ref.child(dataToRetrieve!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.exists() {

                    for child in snapshot.children.allObjects as! [DataSnapshot] {

                        if self.dataToRetrieve == "strain" {
                            self.detailsListArray.append(child.key)
                        } else if self.dataToRetrieve == "effects" {
                            self.detailsListArray.append(child.key)
                            self.effectsDict[child.key] = child.value as? String
                        }
                        else {
                            self.detailsListArray.append(child.value as! String)
                        }
                    }
                    self.tableView.reloadData()
                } else {
                    self.showAlert(alertMessage: "Unable to access Smoking Styles")
                }
            })
        }
    }

    
 
    func showAlert(alertMessage: String) {
        let alert = UIAlertController(title: "Unable to Register", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
}
extension NewActivityTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsListArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)

        // Configure the cell...
        if detailsListArray.count > 0 {
            cell.textLabel?.text = "\(detailsListArray[indexPath.row])"
            cell.detailTextLabel?.text = effectsDict[detailsListArray[indexPath.row]]
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selecteditem = detailsListArray[indexPath.row]
        delegate?.setSelectedDetail(detail: dataToRetrieve!, value: selecteditem)
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
}

