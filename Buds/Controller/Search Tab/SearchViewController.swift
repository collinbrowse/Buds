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
    
    var searchController = UISearchController(searchResultsController: nil)
    var strains = Strain.strains()
    var effects = ["All", "Dizzy", "Hungry", "Happy"]
    var filteredStrains: [Strain] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Make sure the user is logged in
        if Switcher.getUserDefaultsIsSignIn() {
            modelController = Switcher.getUserDefaultsModelController()
        } else {
            Switcher.updateRootViewController()
        }
        
        // Set up the table view
        searchTableView.dataSource = self
    
        // Set up the search Controller
        // Inform this class of changes in the search bar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Strains, Effects..."
        navigationItem.searchController = searchController
        // Closes the search bar if the user navigates away
        definesPresentationContext = false

        // Set up scope bar
        searchController.searchBar.scopeButtonTitles = effects
        searchController.searchBar.delegate = self
    }
    
    func filterContent(_ searchText: String, searchEffect: String? = nil) {
        
        filteredStrains = strains.filter({ (strain: Strain) -> Bool in
            let doesScopeBarMatch = strain.effect.rawValue == searchEffect
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
        
        filterContent(searchBar.text!, searchEffect: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
        
    }
    
    
}

// Scope Bar Methods
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let effect = searchBar.scopeButtonTitles![selectedScope]
        filterContent(searchBar.text!, searchEffect: effect)
    }
}



// Table View Methods
extension SearchViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredStrains.count
        } else {
            return strains.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchTableViewCell", for: indexPath)
        
        if isFiltering {
            cell.textLabel?.text = filteredStrains[indexPath.row].name
            cell.detailTextLabel?.text = filteredStrains[indexPath.row].effect.rawValue
        } else {
            cell.textLabel?.text = strains[indexPath.row].name
            cell.detailTextLabel?.text = strains[indexPath.row].effect.rawValue
        }
        
        return cell
    }
    
    
    
    
    
}

