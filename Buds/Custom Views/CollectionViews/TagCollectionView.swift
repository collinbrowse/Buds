//
//  HorizontalCollectionView.swift
//  Buds
//
//  Created by Collin Browse on 5/12/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit
import MapKit


protocol LocationPermissionDelegate: class {
    func askForLocationPermissionAgain()
}


class TagCollectionView: UICollectionView {

    
    enum Section { case main }
    var diffableDataSource: UICollectionViewDiffableDataSource<Section, String>!
    var data: [String] = []
    var currentTag: TagTypes!
    var selectedData: Set<String> = []
    var locationManager = CLLocationManager()
    let indicator = UIActivityIndicatorView()
    weak var locationPermissionDelegate : LocationPermissionDelegate?
    
    convenience init(frame: CGRect, tag: TagTypes, delegate: LocationPermissionDelegate) {
        self.init(frame: frame, collectionViewLayout: UIHelper.createTagsFlowLayout())
        currentTag = tag
        locationPermissionDelegate = delegate
        configureCollectionView()
        configureDataSource()
        addActivityIndicator()
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
    
    
    func getData() {
        switch currentTag {
        case .effect:
            getEffectData()
        case .location:
            getLocationData()
        case .method:
            updateData(on: TagValues.methods)
        case .rating:
            updateData(on: TagValues.ratings)
        default:
            break
        }
    }
    
    
    func getLocationData() {
        
        // check the permission status
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
            indicator.startAnimating()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        case .restricted, .denied:
            locationPermissionDelegate?.askForLocationPermissionAgain()
            
        @unknown default:
            print("Fatal Error")
        }
        
    }
    
    
    func addActivityIndicator() {
        
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: topAnchor),
            indicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            indicator.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicator.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    
    func getEffectData() {
        allowsMultipleSelection = true
        
        indicator.startAnimating()
        Network.getEffectsFromAPI { [weak self] (effectsDict) in
            guard let self = self else { return }
            
            if let effectsDict = effectsDict {
                let effectsArray = effectsDict.map { $0.keys.first! }
                self.updateData(on: effectsArray)
            }
        }
    }
    
    
    func setLocationTags(placemark: CLPlacemark) {
        var locationData = Set<String>()
        
        // Add the parts of the placemark that are not nil
        if let locality = placemark.locality { locationData.insert(locality) }
        if let subLocality = placemark.subLocality { locationData.insert(subLocality) }
        if let subAdministrativeArea = placemark.subAdministrativeArea { locationData.insert(subAdministrativeArea) }
        if let administrativeArea = placemark.administrativeArea { locationData.insert(administrativeArea) }
        if let name = placemark.name { locationData.insert(name) }
        
        self.updateData(on: Array(locationData))
    }
    
    
    func updateData(on data: [String]) {
        indicator.stopAnimating()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        DispatchQueue.main.async {
            self.diffableDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }
        self.data = data
    }
    
}

extension TagCollectionView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedData.insert(data[indexPath.row])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        selectedData.remove(data[indexPath.row])
    }
    
}


extension TagCollectionView: CLLocationManagerDelegate {
 
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        
        NetworkManager.shared.getReverseGeocodeLocation(fromLocation: location) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let placemark):
                self.setLocationTags(placemark: placemark)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed with error: \(error)")
    }
}

