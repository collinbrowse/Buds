//
//  TableViewCell.swift
//  Buds
//
//  Created by Collin Browse on 9/24/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    var collectionViewOffset: CGFloat {
        get { return collectionView.contentOffset.x }
        set { collectionView.contentOffset.x = newValue }
    }
    
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    
}
