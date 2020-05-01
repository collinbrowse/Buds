//
//  SearchVC.swift
//  Buds
//
//  Created by Collin Browse on 4/24/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit
import Alamofire

class SearchVC: BudsDataLoadingVC {

    enum Section { case main }
    var collectionView : UICollectionView!
    var dataSource : UICollectionViewDiffableDataSource<Section, Strain>!
    var strains : [Strain] = []
    var filteredStrains : [Strain] = []
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureSearchController()
        configureCollectionView()
        configureDataSource()
        getAllStrains()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Strains"
    }
    
    
    func configureViewController() {
        
        view.backgroundColor = .systemBackground
  
    }
    
    
    func configureSearchController() {
        
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a strain"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    
    func configureCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(StrainCell.self, forCellWithReuseIdentifier: StrainCell.reuseID)
        collectionView.delegate = self
    }
    
    
    func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, strain) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StrainCell.reuseID, for: indexPath) as! StrainCell
            cell.set(strain: strain)
            
            return cell
        })
    }
    
    func getAllStrains() {
        
        Network.getAllStrains { (response) in
            
            let result = try! JSONDecoder().decode(StrainJSON.self, from: response.rawData())
            
            for item in result.strain {
                var strainModel = Strain(name: item.key)
                strainModel.id = item.value.id
                strainModel.race = item.value.race
                strainModel.flavors = item.value.flavors
                strainModel.effects?.positive = item.value.effects?.positive
                strainModel.effects?.negative = item.value.effects?.negative
                strainModel.effects?.medical = item.value.effects?.medical
                self.strains.append(strainModel)
            }
            self.updateData(on: self.strains)
        }
    }
    
    
//    func getStrainsByName() {
//
//        Alamofire.request(StrainAPI.baseAPI + StrainAPI.APIKey + StrainAPI.searchForStrainsByName + "Tangie").validate().responseJSON { (response) in
//
//            if response.result.isSuccess {
//
//                do {
//                    let decoder = JSONDecoder()
//                    self.strains = try decoder.decode([Strain].self, from: response.data!)
//                    self.updateData(on: self.strains)
//                } catch {
//                    //completed(.failure(.invalidData))
//                    print(error)
//                }
//
//            } else {
//                print("Unable to parse strains")
//            }
//
//        }
//
//    }
    
    
    func updateData(on strains: [Strain]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Strain>()
        snapshot.appendSections([.main])
        snapshot.appendItems(strains)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }
    }

}


extension SearchVC : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let activeArray = isSearching ? filteredStrains : strains
        let strain = activeArray[indexPath.row]
        
        let destVC = StrainInfoVC()
        destVC.strain = strain
        navigationController?.pushViewController(destVC, animated: true)
    }
}


extension SearchVC : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // Goal: Grab the text from the search bar and update the view
        //searchController.searchBar.text
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredStrains.removeAll()
            isSearching = false
            updateData(on: strains)
            return
        }
        
        isSearching = true
        filteredStrains = strains.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        updateData(on: filteredStrains)
    }

}
