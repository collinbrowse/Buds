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
    var highestRatedStrains = [Strain]()
    var mostUsedStrains = [Strain]()
    var strainsCountDictionary = [Strain: Int]()
    var strainsRatingDictionary = [Strain: Int]()
    var sections: [String] = ["Highest Rated", "Most Activity"]
    var modelController : ModelController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureTableView()
        layoutUI()
        getFavoriteStrains()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
        
        
    func configureNavigationBar() {
        
        let appearance = GreenNavigationBarAppearance(idiom: .unspecified)
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Favorites"
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
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
    
    
    func getFavoriteStrains() {
        
        //showLoadingView()
        Network.displayActivityFeed(userID: modelController.person.id) { [weak self] (activities) in
            guard let self = self else { return }
            self.getHighestRatedStrains(activities: activities)
            self.getMostUsedStrains(activities: activities)
        }

    }
    
    
    func getHighestRatedStrains(activities: [Activity]) {
        
        let dispatchGroup = DispatchGroup()
        var strainsRatings = [String : Int]()
        
        for i in 0...activities.count - 1 {
            
            if let strainName = activities[i].strain, let rating = activities[i].rating {
                
                dispatchGroup.enter()
                Network.getStrain(name: strainName) { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let resultJSON):
                        let strain = Strain(name: strainName, id: resultJSON[0]["id"].int, race: resultJSON[0]["race"].stringValue, flavors: nil, effects: nil)
                        strainsRatings = self.setRatingForStrain(strain: strain, rating: rating, strainsRatings: strainsRatings)
                    case .failure(let error):
                        print(error.localizedDescription) // Don't display strain if there was an error
                    }
                    
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            //self.dismissLoadingView()
            self.highestRatedStrains = Array(self.strainsRatingDictionary.keys).sorted(by: { self.strainsRatingDictionary[$0]! > self.strainsRatingDictionary[$1]! })
            self.tableView.reloadData()
        }
    }
    
    
    
    func setRatingForStrain(strain: Strain, rating: Int, strainsRatings: [String: Int]) -> [String: Int] {
        
        var strainsRatings = strainsRatings
        
        if strainsRatings.keys.contains(strain.name) && rating > strainsRatings[strain.name]! {
            strainsRatings[strain.name] = rating
            self.strainsRatingDictionary[strain] = rating
        } else {
            strainsRatings[strain.name] = rating
            self.strainsRatingDictionary[strain] = rating
        }
        
        return strainsRatings
    }
    
    
    
    func getMostUsedStrains(activities: [Activity]) {
        
        let dispatchGroup = DispatchGroup()
        var strainsCount = [String : Int]()
        
        for i in 0...activities.count - 1 {
            
            if let strainName = activities[i].strain {
                
                dispatchGroup.enter()
                Network.getStrain(name: strainName) { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let resultJSON):
                        let strain = Strain(name: strainName, id: resultJSON[0]["id"].int, race: resultJSON[0]["race"].stringValue, flavors: nil, effects: nil)
                        strainsCount = self.incrementStrainCount(strain: strain, strainsCount: strainsCount)
                    case .failure(let error):
                        print(error.localizedDescription)   // If there is an error we simply don't want to add the strain to the count
                    }
                    
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            //self.dismissLoadingView()
            self.mostUsedStrains = Array(self.strainsCountDictionary.keys).sorted(by: {self.strainsCountDictionary[$0]! > self.strainsCountDictionary[$1]!} )
            self.tableView.reloadData()
        }
    }
    
    
    func incrementStrainCount(strain: Strain, strainsCount: [String: Int]) -> [String: Int] {
        
        var strainsCount = strainsCount
        if strainsCount.keys.contains(strain.name) {
            let count = strainsCount[strain.name]
            strainsCount[strain.name] = count! + 1
            self.strainsCountDictionary[strain] = count! + 1
        } else {
            strainsCount[strain.name] = 1
            self.strainsCountDictionary[strain] = 1
        }
        return strainsCount
    }
    
}


    


extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 8, width:
        tableView.bounds.size.width, height: tableView.bounds.size.height))
        titleLabel.text = sections[section]
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.sizeToFit()
        
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID, for: indexPath) as! FavoriteCell
        
        if indexPath.section == 0 {
            cell.set(strains: highestRatedStrains)
        } else if indexPath.section == 1 {
            cell.set(strains: mostUsedStrains)
        }
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
