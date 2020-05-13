//
//  HorizontalCollectionView.swift
//  Buds
//
//  Created by Collin Browse on 5/12/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class HorizontalCollectionView: UICollectionView {

    
    enum Section { case main }
    var diffableDataSource : UICollectionViewDiffableDataSource<Section, String>!
    
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, collectionViewLayout: UIHelper.createHorizontalFlowLayout())
    }
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configureCollectionView()
        configureDataSource()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureCollectionView() {
        backgroundColor = .systemBackground
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseID)
    }
    
    
    private func configureDataSource() {
        
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: self, cellProvider: { (collectionView, indexPath, someLabelString) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseID, for: indexPath) as! TagCell
            cell.set(labelText: someLabelString)
            
            return cell
        })
    }
    
    
    func updateData(on data: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        DispatchQueue.main.async {
            self.diffableDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }
    }
}

