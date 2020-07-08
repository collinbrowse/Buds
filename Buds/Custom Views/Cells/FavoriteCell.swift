//
//  FavoriteCell.swift
//  Buds
//
//  Created by Collin Browse on 5/15/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

    static let reuseID = String(describing: FavoriteCell.self)
    
    var modelController : ModelController!
    let collectionView = StrainCollectionView(frame: .zero, collectionViewLayout: UIHelper.createHorizontalFlowLayout())
    let indicator = UIActivityIndicatorView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addActivityIndicator()
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func startLoadingIndicator() {
        indicator.startAnimating()
    }
    
    
    func stopLoadingIndicator() {
        indicator.stopAnimating()
    }
    
    
    func set(modelController: ModelController) {
        self.modelController = modelController
    }
    
    
    func set(strains: [Strain]) {
        collectionView.set(data: strains)
    }
    
    
    func set(delegate: StrainCollectionViewDelegate) {
        collectionView.set(delegate: delegate)
    }
    
    
    private func addActivityIndicator() {
        
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: topAnchor),
            indicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            indicator.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicator.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    
    private func configure() {

        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: padding / 2),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding / 2)
        ])
        
    }

}
