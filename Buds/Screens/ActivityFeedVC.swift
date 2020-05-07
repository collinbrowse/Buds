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
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getActivities()
    }
    

    func configureViewController() {
        
        view.backgroundColor = .systemBackground
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
        showLoadingView()
        Network.displayActivityFeed(userID: modelController.person.id) { [weak self] (activities) in
            guard let self = self else { return }
            self.dismissLoadingView()
            self.activities = activities
            self.tableView.separatorStyle = .singleLine
            self.tableView.reloadData()
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
