//
//  LocationSearchBarController.swift
//  Buds
//
//  Created by Collin Browse on 7/16/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationSearchBarController: UITableViewController {
    
    // Search Bar & Table UI Items
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MapKit AutoCompleter
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    // Delegate to send back location data
    var locationDelegate: LocationSearchDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        
        let backgroundImage = UIImage(named: "weed_background")
        let backgroundView = UIImageView(image: backgroundImage)
        searchResultsTableView.backgroundView = backgroundView
        searchResultsTableView.separatorStyle = .none
    }
}


// Extension for the Search Bar
// Says that this class conforms to the UISearchBar Protocol
extension LocationSearchBarController: UISearchBarDelegate {
    
    // What should we do when the text of the search bar changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            searchCompleter.queryFragment = searchText
        }
    }
}


// Extension for MKLocalSearchCompleter
// An MKLocalSearchCompleter object allows you to retreive autocomplete suggestions
// for your own map-based controls. As the user types text, you feed the current text
// string into the search completer object, which delivers possible string completions
// that match locations or points of interest
extension LocationSearchBarController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    
    // Method to handle an error
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("There was an error")
    }
}


// Extension for TableView Methods
extension LocationSearchBarController {
    
    // How many items should we show?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    // What should each cell look like?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Pass the location back to RegisterViewController using the delegate/protocol we created
        locationDelegate?.setSelectedLocation(location: searchResults[indexPath.row].title)
        
        self.dismiss(animated: true, completion: nil)
        
    }
}

