//
//  SearchVC.swift
//  Buds
//
//  Created by Collin Browse on 4/24/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchVC: BudsDataLoadingVC {

    var modelController : ModelController!
    var strainCollectionView : StrainCollectionView!
    var strains : [Strain] = []
    var filteredStrains : [Strain] = []
    var isSearching = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureSearchController()
        configureCollectionView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Strains"
        configureNavigationBar()
        getAllStrains()
    }
    
    
    func getAllStrains() {
        
        if strains.isEmpty {
        
            Network.getAllStrains { [weak self] (result) in
                guard let self = self else { return }
                
                switch result {
                case .success(let responseJSON):
                    self.setStrainData(json: responseJSON)
                case .failure(let error):
                    self.presentBudsAlertOnMainThread(title: "Unable to load Strains", message: error.rawValue, buttonTitle: "OK")
                }
            }
        }
    }
    
    
    func setStrainData(json: JSON) {
        
        let result = try! JSONDecoder().decode(StrainJSON.self, from: json.rawData())
        
        for item in result.strain {
            var strainModel = Strain(name: item.key)
            strainModel.id = item.value.id
            strainModel.race = item.value.race
            strainModel.flavors = item.value.flavors
            strainModel.effects?.positive = item.value.effects?.positive
            strainModel.effects?.negative = item.value.effects?.negative
            strainModel.effects?.medical = item.value.effects?.medical
            strains.append(strainModel)
        }
        strainCollectionView.set(data: strains)
    }
    
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController!.navigationBar.shadowImage = nil
        navigationController!.navigationBar.tintColor = nil
    }
    
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a strain"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    
    private func configureCollectionView() {
        strainCollectionView = StrainCollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        strainCollectionView.set(delegate: self)
        view.addSubview(strainCollectionView)
    }
    
}


extension SearchVC : StrainCollectionViewDelegate {
    
    func didTapStrain(for strain: Strain) {
        
        let destVC = StrainInfoVC()
        destVC.strain = strain
        destVC.modelController = self.modelController
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    func startLoadingView() {
        
    }

}


extension SearchVC : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredStrains.removeAll()
            isSearching = false
            strainCollectionView.set(data: strains)
            return
        }
        
        isSearching = true
        filteredStrains = strains.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        strainCollectionView.set(data: filteredStrains)
    }

}
