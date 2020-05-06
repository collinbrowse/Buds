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
        tableView.rowHeight = 80 // This will have to be variable some how
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ActivityCell.self, forCellReuseIdentifier: ActivityCell.reuseID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 74
    }
    
    
    func getActivities() {
        
        Network.displayActivityFeed(userID: modelController.person.id) { (activities) in
            self.activities = activities
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
