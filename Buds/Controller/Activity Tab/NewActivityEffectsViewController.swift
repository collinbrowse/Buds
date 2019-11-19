//
//  NewActivityEffectsViewController.swift
//  Buds
//
//  Created by Collin Browse on 11/13/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD
import Alamofire
import SwiftyJSON

class NewActivityEffectsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var ref: DatabaseReference!
    var searchController = UISearchController(searchResultsController: nil)
    var effectsDict = [[String: String]]()
    lazy var filteredEffectsDict = effectsDict
    var dataToRetrieve: String?
    var delegate: ActivityDetailsDelegate?
    var categories: [String] {
        var array = [String]()
        for category in Strain.categories() {
            array.append(category.rawValue)
        }
        return array
    }
    var isSearchBarEmpty: Bool {
        let isEmpty = searchController.searchBar.text?.isEmpty ?? true
        return isEmpty
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
        tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.size.height);
        
        // Set up the search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Effects..."
        extendedLayoutIncludesOpaqueBars = true
        definesPresentationContext = true
        
        // Set Up Navigation Bar
        navigationItem.title = dataToRetrieve?.capitalized
        
        // Set up the Segmented Control
        segmentedControl.selectedSegmentIndex = 0
        
        SVProgressHUD.show()
        if UserDefaults.standard.value(forKey: "effects") != nil {
            self.effectsDict = UserDefaults.standard.value(forKey: "effects") as! [[String : String]]
            self.filteredEffectsDict = self.effectsDict
            self.tableView.reloadData()
            SVProgressHUD.dismiss()

        } else {
            Network.getEffectsFromAPI { (effectsDict) in
                self.filteredEffectsDict = effectsDict
                self.effectsDict = effectsDict
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
            
    }

    @IBAction func segmentedControlDidChange(_ sender: Any) {
                
        filterContent(searchText: searchController.searchBar.text!, searchCategory: categories[segmentedControl.selectedSegmentIndex])
    }
    
    func filterContent(searchText: String, searchCategory: String? = nil) {
        
        // Filter Strains using a segmented Control
        filteredEffectsDict = effectsDict.filter({ (dict: Dictionary) -> Bool in
            
            let category = dict.values.first
            let strain = dict.keys.first
            let doesSegmentedControlMatch = category?.lowercased() == searchCategory?.lowercased() || searchCategory?.lowercased() == Strain.Category.all.rawValue.lowercased()
            if isSearchBarEmpty {
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
}


extension NewActivityEffectsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredEffectsDict.count
        } else {
            return effectsDict.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)

        // Configure the cell...
        if isFiltering {
            cell.textLabel?.text = filteredEffectsDict[indexPath.row].keys.first
            cell.detailTextLabel?.text = filteredEffectsDict[indexPath.row].values.first
        } else {
            cell.textLabel?.text = effectsDict[indexPath.row].keys.first
            cell.detailTextLabel?.text = effectsDict[indexPath.row].values.first
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var selectedItem: String
        if isFiltering {
            selectedItem = Array(filteredEffectsDict[indexPath.row])[0].key
        } else {
            selectedItem = Array(effectsDict[indexPath.row])[0].key
        }
        delegate?.setSelectedDetail(detail: dataToRetrieve!, value: selectedItem)
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
}


// Search Bar Methods
extension NewActivityEffectsViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    /// Allows you to respond to changes in a searchController
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        let category = categories[segmentedControl.selectedSegmentIndex]
        filterContent(searchText: searchBar.text!, searchCategory: category)
        
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

