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
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var strain : Strain!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        layoutUI()
        getStrainDescription()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }

    
    func configureViewController() {
        
        if #available(iOS 13.0, *)  { view.backgroundColor = .systemBackground }
        else                        { view.backgroundColor = .white }

        headerTitle.text = strain.name
        headerTitle.numberOfLines = 2
        headerTitle.lineBreakMode = .byTruncatingTail
    }
    
    
    func configureNavigationBar() {
        
        navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.navigationBar.tintColor = .white
        
    }
    
    
    func layoutUI() {
        
        view.addSubview(headerImage)
        view.addSubview(headerTitle)
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(strainDescriptionLabel)
        
        let padding: CGFloat = 20
        let headerImageHeight: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 175 : 300
        
        NSLayoutConstraint.activate([
            headerImage.topAnchor.constraint(equalTo: view.topAnchor),
            headerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerImage.heightAnchor.constraint(equalToConstant: headerImageHeight),
            
            headerTitle.bottomAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: -padding),
            headerTitle.leadingAnchor.constraint(equalTo: headerImage.leadingAnchor, constant: padding),
            headerTitle.trailingAnchor.constraint(equalTo: headerImage.trailingAnchor, constant: -padding),
            headerTitle.heightAnchor.constraint(equalToConstant: 40),
            
            scrollView.topAnchor.constraint(equalTo: headerImage.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            strainDescriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            strainDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            strainDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            strainDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
        
    }
    
    
    private func getStrainDescription() {
        
        strainDescriptionContainerVC.showLoadingView()
        
        Network.getStrainDescription(strainID: strain.id!) { (resultJSON) in
            guard let description = resultJSON["desc"].string else {
                // Ghost Bubba
                return
            }
            self.strainDescriptionLabel.text = resultJSON["desc"].stringValue
            self.strainDescriptionContainerVC.dismissLoadingView()
        }
    }
    
    
}
