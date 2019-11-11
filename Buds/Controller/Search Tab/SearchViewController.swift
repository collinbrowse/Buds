//
//  SearchViewController.swift
//  Buds
//
//  Created by Collin Browse on 11/6/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import UIKit
import MapKit

// A fantastic tutorial by Ray Wenderlich about implementing a search bar
// on a table view with a scope bar
// https://www.raywenderlich.com/4363809-uisearchcontroller-tutorial-getting-started

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Observed Properties
    var modelController: ModelController!
    
    @IBOutlet var searchTableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var searchController = UISearchController(searchResultsController: nil)
    var strains = Strain.strains()
    var effects = ["All", "Dizzy", "Hungry", "Happy"]
    var categories = ["All", "Positive", "Negative"]
    var someStrains = ["Strain  1", "Strain 2", "Strain 3"]
    var filteredStrains: [Strain] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    lazy var filteredArray = effects
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Make sure the user is logged in
        if Switcher.getUserDefaultsIsSignIn() {
            modelController = Switcher.getUserDefaultsModelController()
        } else {
            Switcher.updateRootViewController()
        }
                
        // Set up the table view
        //searchTableView.dataSource = self
    
        tableView.dataSource = self
        // Set up the search Controller
        // Inform this class of changes in the search bar
        //searchController.searchResultsUpdater = self
        //searchController.obscuresBackgroundDuringPresentation = false
        //searchController.searchBar.placeholder = "Search Strains, Effects..."
        //if #available(iOS 13, *) {}
        //else { navigationItem.searchController = searchController }
        navigationItem.title = "Strain Data"
        navigationController?.navigationBar.prefersLargeTitles = true
        // Closes the search bar if the user navigates away
        definesPresentationContext = false

        // Set up scope bar
        //searchController.searchBar.scopeButtonTitles = categories
        //searchController.searchBar.delegate = self
        
        
        segmentedControl.selectedSegmentIndex = 0
    }
    @IBAction func segmentedControlDidChange(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            filteredArray = effects
        case 1:
            filteredArray = categories
        case 2:
            filteredArray = someStrains
        default:
            filteredArray = effects
        }
        
        tableView.reloadData()
    }
    
    func swiped() {
        print("swiped")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //if #available(iOS 13, *) {
        //    navigationItem.searchController = searchController
        //}
    }
    
    func filterContent(_ searchText: String, searchCategory: String? = nil) {
        
        filteredStrains = strains.filter({ (strain: Strain) -> Bool in
            let doesScopeBarMatch = strain.category.rawValue == searchCategory || searchCategory == "All"
            if isSearchBarEmpty {
                return doesScopeBarMatch
            } else {
                return doesScopeBarMatch && strain.name.lowercased().contains(searchText.lowercased())
            }
        })
        
        searchTableView.reloadData()
        
    }
}

// Search Bar Methods
extension SearchViewController: UISearchResultsUpdating {
    
    /// Allows you to respond to changes in a searchController
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        filterContent(searchBar.text!, searchCategory: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
        
    }
    
    
}

// Scope Bar Methods
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let category = searchBar.scopeButtonTitles![selectedScope]
        filterContent(searchBar.text!, searchCategory: category)
    }
}



// Table View Methods
extension SearchViewController {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == searchTableView {
            if isFiltering {
                return filteredStrains.count
            } else {
                return strains.count
            }
        } else if tableView == self.tableView {
            return filteredArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == searchTableView {
            let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchTableViewCell", for: indexPath)
            
            if isFiltering {
                cell.textLabel?.text = filteredStrains[indexPath.row].name
                cell.detailTextLabel?.text = filteredStrains[indexPath.row].effect.rawValue
            } else {
                cell.textLabel?.text = strains[indexPath.row].name
                cell.detailTextLabel?.text = strains[indexPath.row].effect.rawValue
            }
            return cell
        } else if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
            cell.textLabel?.text = filteredArray[indexPath.row]
            return cell
        } else {
            return UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
            
    }
    
    
    
    
    
}

