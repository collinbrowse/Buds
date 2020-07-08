//
//  StrainCollectionView.swift
//  Buds
//
//  Created by Collin Browse on 5/14/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit


protocol StrainCollectionViewDelegate: class {
    func didTapStrain(for strain: Strain)
    func startLoadingView()
}


class StrainCollectionView: UICollectionView {

    enum Section { case main }
    var diffableDataSource: UICollectionViewDiffableDataSource<Section, Strain>!
    var data: [Strain] = []
    weak var navigationController: UINavigationController?
    weak var strainDelegate: StrainCollectionViewDelegate?
    var modelController: ModelController!
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configureCollectionView()
        configureDataSource()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureCollectionView() {
        delegate = self
        backgroundColor = .systemBackground
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        register(StrainCell.self, forCellWithReuseIdentifier: StrainCell.reuseID)
    }
    
    
    private func configureDataSource() {
        
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: self, cellProvider: { (collectionView, indexPath, strain) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StrainCell.reuseID, for: indexPath) as! StrainCell
            cell.set(strain: strain)
            
            return cell
        })
    }
    
    
    func updateData(on data: [Strain]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Strain>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        DispatchQueue.main.async {
            self.diffableDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }
        self.data = data
    }
    
    
    func set(data: [Strain]) {
        updateData(on: data)
    }
    
    
    func set(delegate: StrainCollectionViewDelegate) {
        self.strainDelegate = delegate
    }
    
}


extension StrainCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let strain = data[indexPath.row]
        
        if strainDelegate != nil {
            strainDelegate!.didTapStrain(for: strain)
        } else {
            let destVC = StrainInfoVC()
            destVC.strain = strain
            destVC.modelController = modelController
            navigationController?.pushViewController(destVC, animated: true)
        }
    }
}
