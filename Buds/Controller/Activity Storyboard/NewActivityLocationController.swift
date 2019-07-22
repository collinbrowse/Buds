//
//  NewActivityLocationController.swift
//  Buds
//
//  Created by Collin Browse on 7/22/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class NewActivityLocationController: UITableViewController {
    
    // Search bar & Table UI Items
    @IBOutlet weak var newActivityLocationTableView: UITableView!
    @IBOutlet weak var newActivityLocationSearchBar: UISearchBar!
    
    // MapKit AutoCompleter
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    // Delegate to receive the location data
    var locationDelegate: LocationSearchDelegate?
    
    
    override func viewDidLoad() {
        searchCompleter.delegate = self
        newActivityLocationSearchBar.delegate = self
        searchCompleter.filterType = .locationsOnly
        newActivityLocationSearchBar.becomeFirstResponder()
        newActivityLocationTableView.separatorStyle = .none
    }
}



// Extension for the Search Bar
// Says that this class conforms to the UISearchBar Protocol
extension NewActivityLocationController: UISearchBarDelegate {

    // What should we do when the text of the search bar changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            // Record that text
            searchCompleter.queryFragment = searchText
            print(searchText)
        }
    }
}

// Handles functions for the LocalSearchCompleter
extension NewActivityLocationController: MKLocalSearchCompleterDelegate {
    
    // Use this function to update your app with the new search results
    // Called when the specified search completer updates its array of search completions.
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        newActivityLocationTableView.reloadData()
    }
    
    // Method to handle an error
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("There was an error")
    }
}



// Extension for the Table View methods
extension NewActivityLocationController {
    
    // How many items should we show?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    // What should we put in each cell?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Use a default cell of type .subtitle
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    // What happens if we select a row?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set the Placeholder Text Field in the previous view controller
        locationDelegate?.setSelectedLocation(location: searchResults[indexPath.row].title)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Head back to view controller that got us here
        self.navigationController?.popViewController(animated: true)
    }
}
