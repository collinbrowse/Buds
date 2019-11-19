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
import Alamofire

// A fantastic tutorial by Ray Wenderlich about implementing a search bar
// on a table view with a scope bar
// https://www.raywenderlich.com/4363809-uisearchcontroller-tutorial-getting-started

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Manage the user and their logged in state
    var modelController: ModelController!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchTableView: UITableView!
    
    var searchController = UISearchController(searchResultsController: nil)
    var strains = Strain.strains()
    var effects = ["All", "Dizzy", "Hungry", "Happy"]
    var someStrains = ["Strain  1", "Strain 2", "Strain 3"]
    var filteredStrains: [Strain] = []
    lazy var filteredArray = effects
    var randomEffects = [String]()
    var randomEffectsWithRelatedStrains = [[String]]()
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

        // Make sure the user is logged in
        if Switcher.getUserDefaultsIsSignIn() {
            modelController = Switcher.getUserDefaultsModelController()
        } else {
            Switcher.updateRootViewController()
        }
                
        // Set up the table view
        searchTableView.dataSource = self
        searchTableView.tableHeaderView = searchController.searchBar
        searchTableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.size.height);
        
        // Set up the search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Strains, Effects..."
        definesPresentationContext = true
        
        // Set up the Navigation bar
        navigationController?.navigationBar.backgroundColor = .white
        let navigationBar = navigationController!.navigationBar
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        
        // Set up the Segmented Control
        segmentedControl.selectedSegmentIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for i in 0...categories.count-1 {
            segmentedControl.setTitle(categories[i], forSegmentAt: i)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }
    

    @IBAction func segmentedControlDidChange(_ sender: Any) {
        
        // Filter the data with the new Category
        let category = categories[segmentedControl.selectedSegmentIndex]
        filterContent(searchController.searchBar.text!, searchCategory: category)
        
        // Show the new data by reloading the table view
        searchTableView.reloadData()
    }
    
    
    func filterContent(_ searchText: String, searchCategory: String? = nil) {
        
        // Filter Strains using a segmented Control
        filteredStrains = strains.filter({ (strain: Strain) -> Bool in
            let doesSegmentedControlMatch = strain.category.rawValue == searchCategory || searchCategory == Strain.Category.all.rawValue
            
            if isSearchBarEmpty {
                return doesSegmentedControlMatch
            } else {
                return doesSegmentedControlMatch && strain.name.lowercased().contains(searchText.lowercased())
            }
        })
        
        searchTableView.reloadData()
    }
}


// Search Bar Methods
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    /// Allows you to respond to changes in a searchController
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        let category = categories[segmentedControl.selectedSegmentIndex]
        filterContent(searchBar.text!, searchCategory: category)
        
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.segmentedControl.frame.origin.y = -self.segmentedControl.frame.size.height
                        self.searchTableView.frame.origin.y -= self.segmentedControl.frame.size.height
                        self.view.layoutIfNeeded()
        }, completion: nil)
        print(-self.segmentedControl.frame.size.height)
        
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        var topBarHeight = CGFloat(0.0)
        if #available(iOS 13.0, *) {
             topBarHeight = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            topBarHeight = (self.navigationController?.navigationBar.frame.size.height)!
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.segmentedControl.frame.origin.y = topBarHeight
                        self.searchTableView.frame.origin.y = self.segmentedControl.frame.size.height + topBarHeight
                        self.view.layoutIfNeeded()
        }, completion: nil)
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

