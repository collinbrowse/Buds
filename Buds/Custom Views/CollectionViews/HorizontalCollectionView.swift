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
    var data : [String] = []
    var currentTag : TagTypes!
    var selectedData : Set<String> = []
    
    convenience init(frame: CGRect, tag: TagTypes) {
        self.init(frame: frame, collectionViewLayout: UIHelper.createHorizontalFlowLayout())
        currentTag = tag
        configureCollectionView()
        configureDataSource()
        getData()
    }
    
    
    private override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureCollectionView() {
        delegate = self
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
        self.data = data
    }
    
    
    func getData() {
        switch currentTag {
        case .effect:
            allowsMultipleSelection = true
            Network.getEffectsFromAPI { (effectsDict) in
                let effectsArray = effectsDict.map { $0.keys.first! }
                self.updateData(on: effectsArray)
            }
        case .location:
            print()
        case .method:
            updateData(on: TagValues.methods)
        case .rating:
            updateData(on: TagValues.ratings)
        default:
            break
        }
    }
    
}

extension HorizontalCollectionView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedData.insert(data[indexPath.row])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        selectedData.remove(data[indexPath.row])
    }
    
}

