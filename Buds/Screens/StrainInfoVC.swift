//
//  StrainInfoVC.swift
//  Buds
//
//  Created by Collin Browse on 4/17/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class StrainInfoVC: BudsDataLoadingVC {

    let headerImage = BudsHeaderImageView(image: Images.defaultHeaderImageView)
    let headerTitle = BudsTitleLabel(textAlignment: .right, fontSize: 34)
    var strainDescriptionLabel = BudsBodyLabel(textAlignment: .natural)
    let strainDescriptionContainerVC = BudsDataLoadingVC()
    var strain : StrainModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureNavigationBar()
        layoutUI()
        getStrainDescription()
    }

    
    func configureViewController() {
        
        if #available(iOS 13.0, *)  { view.backgroundColor = .systemBackground }
        else                        { view.backgroundColor = .white }

        headerTitle.text = strain.name
    }
    
    func configureNavigationBar() {
        navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.navigationBar.isTranslucent = true
        navigationController!.navigationBar.tintColor = .white
    }
    
    
    func layoutUI() {
        
        view.addSubview(headerImage)
        view.addSubview(headerTitle)
        view.addSubview(strainDescriptionLabel)
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            headerImage.topAnchor.constraint(equalTo: view.topAnchor),
            headerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerImage.heightAnchor.constraint(equalToConstant: 300),
            
            headerTitle.bottomAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: -padding),
            headerTitle.leadingAnchor.constraint(equalTo: headerImage.leadingAnchor, constant: padding),
            headerTitle.trailingAnchor.constraint(equalTo: headerImage.trailingAnchor, constant: -padding),
            headerTitle.heightAnchor.constraint(equalToConstant: 40),
            
            strainDescriptionLabel.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: padding),
            strainDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            strainDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            strainDescriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
    
    
    private func getStrainDescription() {
        
        strainDescriptionContainerVC.showLoadingView()
        
        Network.getStrainDescription(strainID: (strain?.id)!) { (resultJSON) in
            self.strainDescriptionLabel.text = resultJSON["desc"].stringValue
            self.strainDescriptionContainerVC.dismissLoadingView()
        }
    }
    
    
}
