//
//  NewActivityStrainViewController.swift
//  Buds
//
//  Created by Collin Browse on 11/14/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD
import Alamofire
import SwiftyJSON

class NewActivityStrainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var ref: DatabaseReference!
    var raceDict = [[String: String]]()
    lazy var filteredRaceDict = raceDict
    var dataToRetrieve: String?
    var delegate: ActivityDetailsDelegate?
    var race = ["All", "Sativa", "Indica", "Hybrid"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Up TableView
        tableView.dataSource = self
        tableView.delegate = self
        
        // Set Up Navigation Bar
        navigationItem.title = dataToRetrieve?.capitalized
        self.segmentedControl.selectedSegmentIndex = 0
        
        
        SVProgressHUD.show()
        if UserDefaults.standard.value(forKey: "raceDict") != nil {
            self.filteredRaceDict = UserDefaults.standard.value(forKey: "raceDict") as! [[String : String]]
            self.raceDict = self.filteredRaceDict
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        } else {
            Network.getRaceFromAPI { (raceDict) in
                self.filteredRaceDict = raceDict
                self.raceDict = raceDict
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
                
    }

    @IBAction func segmentedControlDidChange(_ sender: Any) {
                
        filterContent(searchCategory: race[segmentedControl.selectedSegmentIndex])
    }
    
    func filterContent(searchCategory: String) {
        
        // Filter Strains using a segmented Control
        filteredRaceDict = raceDict.filter({ (dict: Dictionary) -> Bool in
            
            let category = dict.values.first
            let doesSegmentedControlMatch = category?.lowercased() == searchCategory.lowercased() || searchCategory.lowercased() == Strain.Category.all.rawValue.lowercased()
            
            return doesSegmentedControlMatch
        })
        
        tableView.reloadData()
    }
    
 
    func showAlert(alertMessage: String) {
        let alert = UIAlertController(title: "Unable to Register", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
}


extension NewActivityStrainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRaceDict.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)

        // Configure the cell...
        if filteredRaceDict.count > 0 {
            cell.textLabel?.text = filteredRaceDict[indexPath.row].keys.first
            cell.detailTextLabel?.text = filteredRaceDict[indexPath.row].values.first
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selecteditem = Array(filteredRaceDict[indexPath.row])[0].key
        delegate?.setSelectedDetail(detail: dataToRetrieve!, value: selecteditem)
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
}

