//
//  SearchVC.swift
//  Buds
//
//  Created by Collin Browse on 4/24/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class SearchVC: BudsDataLoadingVC {

    enum Section { case main }
    var collectionView : UICollectionView!
    var dataSource : UICollectionViewDiffableDataSource<Section, StrainModel>!
    var strains : [StrainModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureSearchController()
        configureCollectionView()
        configureDataSource()
        getStrains()
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
    
    
    func getStrains() {
        // And finally lets populate our tableview with data
        Network.getAllStrains { (response) in
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
            self.updateData(on: self.strains)
        }
    }
    
    func updateData(on strain: [StrainModel]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, StrainModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(strains)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }
    }

}


extension SearchVC : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // if filtering
        let strain = strains[indexPath.row]
        let destVC = StrainInfoVC()
        destVC.strain = strain
        navigationController?.pushViewController(destVC, animated: true)
    }
}


extension SearchVC : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // Goal: Grab the text from the search bar and update the view
        //searchController.searchBar.text
    }

}
