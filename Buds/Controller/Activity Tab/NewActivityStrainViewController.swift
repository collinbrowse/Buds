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
    var searchController = UISearchController(searchResultsController: nil)
    var raceDict = [[String: String]]()
    lazy var filteredRaceDict = raceDict
    var dataToRetrieve: String?
    var delegate: ActivityDetailsDelegate?
    var races: [String] {
        return Constants.races().map { (race: Constants.Race) -> String in
            return race.rawValue
        }
    }
    var isSeearchBarEmpty: Bool {
         return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        let segmentedControlIsFiltering = segmentedControl.selectedSegmentIndex != 0
        return searchController.isActive || segmentedControlIsFiltering
    }
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Up TableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.size.height)
        
        // Set up the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Strains..."
        extendedLayoutIncludesOpaqueBars = true
        definesPresentationContext = true
        
        // Set Up Navigation Bar
        navigationItem.title = dataToRetrieve?.capitalized
        
        // Set up the Segmented Control
        segmentedControl.selectedSegmentIndex = 0
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        for i in 0...races.count-1 {
            segmentedControl.setTitle(races[i], forSegmentAt: i)
        }
    }

    @IBAction func segmentedControlDidChange(_ sender: Any) {
                
        filterContent(searchText: searchController.searchBar.text!, searchRace: races[segmentedControl.selectedSegmentIndex])
    }
    
    func filterContent(searchText: String, searchRace: String? = nil) {
        
        // Filter Strains using a segmented Control
        filteredRaceDict = raceDict.filter({ (dict: Dictionary) -> Bool in
            
            let race = dict.values.first
            let strain = dict.keys.first
            let doesSegmentedControlMatch = race?.lowercased() == searchRace?.lowercased() || searchRace?.lowercased() == Constants.Category.all.rawValue.lowercased()
            if isSeearchBarEmpty {
                return doesSegmentedControlMatch
            } else {
                return doesSegmentedControlMatch && strain?.lowercased().contains(searchText.lowercased()) ?? false
            }
            
        })
        
        tableView.reloadData()
    }
    
 
    func showAlert(alertMessage: String) {
        let alert = UIAlertController(title: "Unable to Register", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    
    func dismissSearchController() {
        self.searchController.isActive = false
        view.layoutIfNeeded()
    }
}


extension NewActivityStrainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredRaceDict.count
        } else {
            return raceDict.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)

        // Configure the cell...
        if isFiltering {
            cell.textLabel?.text = filteredRaceDict[indexPath.row].keys.first
            cell.detailTextLabel?.text = filteredRaceDict[indexPath.row].values.first
        } else {
            cell.textLabel?.text = raceDict[indexPath.row].keys.first
            cell.detailTextLabel?.text = raceDict[indexPath.row].values.first
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var selectedItem: String
        
        if isFiltering {
            selectedItem = Array(filteredRaceDict[indexPath.row])[0].key
        } else {
            selectedItem = Array(raceDict[indexPath.row])[0].key
        }
        dismissSearchController()
        self.searchController.searchBar.resignFirstResponder()
        self.searchController.resignFirstResponder()
        delegate?.setSelectedDetail(detail: dataToRetrieve!, value: selectedItem)
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
}

extension NewActivityStrainViewController: UISearchResultsUpdating, UISearchBarDelegate {
    

    /// Allows you to respond to changes in a searchController
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let currentRace = races[segmentedControl.selectedSegmentIndex]
        filterContent(searchText: searchBar.text!, searchRace: currentRace)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.segmentedControl.frame.origin.y = -self.segmentedControl.frame.size.height
                        self.tableView.frame.origin.y -= self.segmentedControl.frame.size.height
                        self.view.layoutIfNeeded()
        }, completion: nil)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.segmentedControl.frame.origin.y = 0
                        self.tableView.frame.origin.y = self.segmentedControl.frame.size.height
                        self.tableView.frame.size.height -= self.segmentedControl.frame.size.height
                        self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    
    
}

