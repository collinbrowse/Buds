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
    let headerTitle = BudsStrainTitleLabel(textAlignment: .right, fontSize: 34)
    var strainDescriptionLabel = BudsBodyLabel(textAlignment: .natural)
    
    let strainDescriptionContainerVC = BudsDataLoadingVC()
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var strain : Strain!
    
    var modelController : ModelController!
    
    
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
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    @objc func addButtonTapped() {
        let destVC = NewActivityVC()
        destVC.strain = strain
        destVC.modelController = modelController
        navigationController?.pushViewController(destVC, animated: true)
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
        
        showLoadingView()
        
        Network.getStrainDescription(strainID: strain.id!) { [weak self] (resultJSON) in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            guard let description = resultJSON["desc"].string else {
                let message = "Sorry, we couldn't find any details for " + self.headerTitle.text!
                self.showEmptyStateView(with: message, in: self.contentView)
                return
            }
            
            self.strainDescriptionLabel.text = description
        }
    }
    
    
    
}
