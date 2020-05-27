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
        configureTableView()
        getActivities()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    func configureViewController() {
        
        view.backgroundColor = .systemBackground
        title = "Buds"
        navigationController?.navigationBar.tintColor = .systemGreen
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
        
        Network.displayActivityFeed(userID: modelController.person.id) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let activities):
                self.activities = activities
                self.tableView.separatorStyle = .singleLine
                self.tableView.reloadData()
            case .failure(let error):
                self.presentBudsAlertOnMainThread(title: "Unable to get recent activity", message: error.rawValue, buttonTitle: "OK")
            }
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
        return cell
    }
    
}
