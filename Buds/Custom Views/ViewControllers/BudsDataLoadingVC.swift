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
    
    func showLoadingView(with bounds: CGRect) {
        
    }
    
    func showLoadingView() {
        
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        if #available(iOS 13.0, *)  { containerView.backgroundColor = .systemBackground }
        else                        { containerView.backgroundColor = .white }
        containerView.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 0.25
        }
        
        let activityIndicator = UIActivityIndicatorView()
        if #available(iOS 13.0, *)  { activityIndicator.style = .large }
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
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
    

}
