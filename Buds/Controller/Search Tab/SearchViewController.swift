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
import SwiftyJSON

// A fantastic tutorial by Ray Wenderlich about implementing a search bar
// on a table view with a scope bar
// https://www.raywenderlich.com/4363809-uisearchcontroller-tutorial-getting-started

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Manage the user and their logged in state
    var modelController: ModelController!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchTableView: UITableView!
    
    var didSelectStrain: String?
    var searchController = UISearchController(searchResultsController: nil)
    var strains = [StrainModel]()
    var filteredStrains = [StrainModel]()
    var categories: [String] {
        var array = [String]()
        for category in Constants.categories() {
            array.append(category.rawValue)
        }
        return array
    }
    var races: [String] {
        var array = [String]()
        for race in Constants.races() {
            array.append(race.rawValue)
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
        searchTableView.delegate = self
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
        let navigationBar = navigationController!.navigationBar
        navigationBar.backgroundColor = .white
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        
        // Set up the Segmented Control
        segmentedControl.selectedSegmentIndex = 0
        
        // And finally lets populate our tableview with data
        Network.getAllStrains { (response) in
            self.decodeStrains(response)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(false, animated: true)

        for i in 0...races.count-1 {
            segmentedControl.setTitle(races[i], forSegmentAt: i)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // When the user navigates away the search controller should no long be active
        searchController.isActive = false
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    /// This function takes a Swifty JSON object and decodes it into a Strain Model Object. Then it translates it into
    /// an array of StrainModel objects for use in a tableview
    func decodeStrains(_ response: JSON) {
        if let jsonData = response.rawString()?.data(using: .utf8)! {
            let result = try! JSONDecoder().decode(StrainJSON.self, from: jsonData)
            var strainModel = StrainModel()
            for item in result.strain {
                strainModel.name = item.key
                strainModel.id = item.value.id
                strainModel.race = item.value.race
                strainModel.flavors = item.value.flavors
                strainModel.effects?.positive = item.value.effects?.positive
                strainModel.effects?.negative = item.value.effects?.negative
                strainModel.effects?.medical = item.value.effects?.medical
                self.strains.append(strainModel)
            }
        }
        self.filteredStrains = self.strains
        self.searchTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToStrainInfo" {
            let vc = segue.destination as! StrainInfoViewController
            vc.strain = didSelectStrain
            vc.modelController = modelController
        }
    }

    @IBAction func segmentedControlDidChange(_ sender: Any) {
        
        // Filter the data with the new Category
        let race = races[segmentedControl.selectedSegmentIndex]
        filterContent(searchController.searchBar.text!, searchRace: race)
        
        // Show the new data by reloading the table view
        searchTableView.reloadData()
    }
    
    
    func filterContent(_ searchText: String, searchRace: String? = nil) {
        
        filteredStrains = strains.filter({ (strain: StrainModel) -> Bool in
            let doesSegmendtedControlMatch = strain.race?.lowercased() == searchRace?.lowercased() || searchRace == "All"
            
            if isSearchBarEmpty {
                return doesSegmendtedControlMatch
            } else {
                return doesSegmendtedControlMatch && strain.name?.lowercased().contains(searchText.lowercased()) ?? false
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
        let race = races[segmentedControl.selectedSegmentIndex]
        filterContent(searchBar.text!, searchRace: race)
        
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
            cell.detailTextLabel?.text = filteredStrains[indexPath.row].race?.capitalized
        } else {
            cell.textLabel?.text = strains[indexPath.row].name
            cell.detailTextLabel?.text = strains[indexPath.row].race?.capitalized
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if isFiltering {
            didSelectStrain = filteredStrains[indexPath.row].name!
        } else {
            didSelectStrain = strains[indexPath.row].name!
        }
        self.performSegue(withIdentifier: "goToStrainInfo", sender: self)
    }
}

