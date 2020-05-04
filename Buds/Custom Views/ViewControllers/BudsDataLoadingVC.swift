//
//  BudsDataLoadingVC.swift
//  Buds
//
//  Created by Collin Browse on 4/21/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class BudsDataLoadingVC: UIViewController {

    
    var containerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func showLoadingView() {
        
        containerView = UIView(frame: view.bounds)
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        view.addSubview(containerView)

        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 0.25
        }
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
        
    }
    
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
    
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = BudsEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    

}
