//
//  FavoritesVC.swift
//  Buds
//
//  Created by Collin Browse on 5/14/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class FavoritesVC: BudsDataLoadingVC {
    
    var tableView = UITableView()
    var strains: [Strain] = []
    var sections: [String] = ["Highest Rated", "Most Activity"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureTableView()
        layoutUI()
        getAllStrains()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
        
        
    func configureNavigationBar() {
        
        let appearance = GreenNavigationBarAppearance(idiom: .unspecified)
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        title = "Favorites"
        navigationController?.navigationBar.tintColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
    
    
    func layoutUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
        }
        tableView.reloadData()
    }
}


extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID, for: indexPath) as! FavoriteCell
        cell.set(strains: strains)
        cell.set(delegate: self)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0
    }
}


extension FavoritesVC: StrainCollectionViewDelegate {
        
    func didTapStrain(for strain: Strain) {
        let destVC = StrainInfoVC()
        destVC.strain = strain
        navigationController?.pushViewController(destVC, animated: true)
    }
}
