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

    }
    
 
}

// Search Bar Methods
extension SearchViewController: UISearchResultsUpdating {
    
    /// Allows you to respond to changes in a searchController
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    
}



// Table View Methods
extension SearchViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchTableViewCell", for: indexPath)
        cell.textLabel?.text = "Strain"
        cell.detailTextLabel?.text = "Effect"
        return cell
    }
    
    
    
    
    
}

