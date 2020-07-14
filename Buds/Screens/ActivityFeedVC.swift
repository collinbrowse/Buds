//
//  ActivityFeedVC.swift
//  Buds
//
//  Created by Collin Browse on 5/4/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class ActivityFeedVC: BudsDataLoadingVC {

    
    let tableView = UITableView()
    var activities : [Activity] = []
    var modelController : ModelController!
    var count = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureNavigationBar()
        configureTableView()
        getActivities()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    
    func configureNavigationBar() {
        
        let appearance = GreenNavigationBarAppearance(idiom: .unspecified)
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Buds"
    }
    
    
    func configureTableView() {
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ActivityCell.self, forCellReuseIdentifier: ActivityCell.reuseID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 74
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    
    func getActivities() {
        
        startLoadingView()
        Network.displayActivityFeed(userID: modelController.person.id) { [weak self] (result) in
            guard let self = self else { return }
            
            if self.containerView != nil {
                self.dismissLoadingView()
            }
            
            switch result {
            case .success(let activities):
                self.updateUI(with: activities)
            case .failure(let error):
                if case BudsError.noActivities = error {
                    self.showEmptyStateView(with: error.rawValue, in: self.view)
                } else {
                    self.presentBudsAlertOnMainThread(title: "Unable to get recent activity", message: error.rawValue, buttonTitle: "OK")
                }
            }
        }
    }
    
    
    func updateUI(with activities: [Activity]) {
        
        self.activities = activities
        DispatchQueue.main.async {
            self.tableView.separatorStyle = .singleLine
            self.tableView.reloadData()
            self.view.bringSubviewToFront(self.tableView)
        }
    }
    
}


extension ActivityFeedVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActivityCell.reuseID) as! ActivityCell
        cell.set(activity: activities[indexPath.row])
        cell.set(delegate: self)
        return cell
    }
    
}


extension ActivityFeedVC : StrainCollectionViewDelegate {
    
    func didTapStrain(for strain: Strain) {
        if self.containerView != nil {
            dismissLoadingView()
        }
        let destVC = StrainInfoVC()
        destVC.strain = strain
        destVC.modelController = modelController
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func startLoadingView() {
        showLoadingView()
    }
}
