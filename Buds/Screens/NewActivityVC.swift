//
//  NewActivityVC.swift
//  Buds
//
//  Created by Collin Browse on 5/7/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit


class NewActivityVC: BudsDataLoadingVC {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    var modelController: ModelController!
    var strain : Strain!
    
    var strainIcon = UIImageView(frame: .zero)
    var strainLabel = BudsTitleLabel(textAlignment: .left, fontSize: 20)
    var raceLabel = BudsSecondaryLabel(fontSize: 16, weight: .medium)
    
    var noteTextField = UITextField(frame: .zero)
    var labelsView = UIView()
    var collectionViews : [TagCollectionView] = []
    var ratingLabel = BudsTitleLabel(textAlignment: .left, fontSize: 20)
    var consumptionMethodLabel = BudsTitleLabel(textAlignment: .left, fontSize: 20)
    var effectsLabel = BudsTitleLabel(textAlignment: .left, fontSize: 20)
    var locationLabel = BudsTitleLabel(textAlignment: .left, fontSize: 20)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureStrainIcon()
        configureStrainLabel()
        configureRaceLabel()
        configureNoteTextField()
        configureLabels()
        layoutUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        removeNavigationBar()
    }
    
    
    @objc func addButtonTapped() {
        
        var activityDetailsDict                 = [String : Any]()
        activityDetailsDict["user"]             = modelController.person.id
        activityDetailsDict["time"]             = TimeHelper.getTodayString()
        activityDetailsDict["strain"]           = strainLabel.text
        activityDetailsDict["note"]             = noteTextField.text
        activityDetailsDict["race"]             = raceLabel.text?.lowercased()
        
        for collectionView in collectionViews {
            guard !collectionView.selectedData.isEmpty else {
                presentBudsAlertOnMainThread(title: "You have fields that are empty", message: "Please make sure a tag is selected for each field", buttonTitle: "OK")
                return
            }
            
            switch collectionView.currentTag {
            case .effect:
                activityDetailsDict[collectionView.currentTag.value] = Array(collectionView.selectedData)
            case .location:
                activityDetailsDict[collectionView.currentTag.value] = collectionView.selectedData.first
            case .method:
                activityDetailsDict["smoking_style"] = collectionView.selectedData.first
            case .rating:
                activityDetailsDict[collectionView.currentTag.value] = setSelectedRating(rating: collectionView.selectedData.first!)
            default:
                break
            }
        }
        
        addActivity(activityDetails: activityDetailsDict)
    }
    
    
    private func addActivity(activityDetails: [String: Any]) {
        
        showLoadingView()
        Network.addNewActivity(userID: modelController.person.id, activityDetails: activityDetails) { [weak self] (error) in
            guard let self = self else { return }
            if self.containerView != nil {
                self.dismissLoadingView()
            }
            
            if error == nil {
                self.moveToActivityFeedVC(index: TabBarIndices.ActivityFeedVC)
            } else {
                self.presentBudsAlertOnMainThread(title: "Unable to add Activity", message: error!.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    
    private func setSelectedRating(rating: String) -> Int {
        
        if rating == "⭐️5" {
            return 5
        } else if rating == "⭐️4" {
            return 4
        } else if rating == "⭐️3" {
            return 3
        } else if rating == "⭐️2" {
            return 2
        } else {
            return 1
        }
    }
    
    
    
    
    private func configureNavigationBar() {
        
        let appearance = GreenNavigationBarAppearance()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        title = "New Activity"
        navigationController?.navigationBar.tintColor = .white
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    private func removeNavigationBar() {
        navigationItem.standardAppearance = nil
        navigationItem.scrollEdgeAppearance = nil
    }
    
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }

    
    private func configureStrainIcon() {
        strainIcon.image = Icons.defaultStrainIcon
        strainIcon.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func configureStrainLabel() {
        strainLabel.text = strain.name.capitalizeFirstLetter()
    }
    
    
    private func configureRaceLabel() {
        raceLabel.text = strain.race!.capitalizeFirstLetter()
    }
    
    
    private func configureNoteTextField() {
        noteTextField.translatesAutoresizingMaskIntoConstraints = false
        noteTextField.placeholder = "How was it? Leave a note for later"
        noteTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        noteTextField.textColor = .label
        noteTextField.attributedPlaceholder = NSAttributedString(string: "How was it? Leave a note for later", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        noteTextField.becomeFirstResponder()
        noteTextField.returnKeyType = .done
        noteTextField.delegate = self
    }
    
    
    private func configureLabels() {
        labelsView.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.text = "Rating"
        consumptionMethodLabel.text = "Method"
        effectsLabel.text = "Effects"
        locationLabel.text = "Location"
    }
    
    
    
    private func layoutUI() {
        
        view.addSubviews(strainIcon, strainLabel, raceLabel, noteTextField, labelsView)
        
        let padding : CGFloat = 12
        
        NSLayoutConstraint.activate([
    
            strainIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            strainIcon.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            strainIcon.heightAnchor.constraint(equalToConstant: 50),
            strainIcon.widthAnchor.constraint(equalToConstant: 50),
            
            strainLabel.topAnchor.constraint(equalTo: strainIcon.topAnchor),
            strainLabel.leadingAnchor.constraint(equalTo: strainIcon.trailingAnchor, constant: padding),
            strainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            strainLabel.heightAnchor.constraint(equalToConstant: 26),
            
            raceLabel.topAnchor.constraint(equalTo: strainLabel.bottomAnchor),
            raceLabel.leadingAnchor.constraint(equalTo: strainIcon.trailingAnchor, constant: padding),
            raceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            raceLabel.heightAnchor.constraint(equalToConstant: 24),
            
            noteTextField.topAnchor.constraint(equalTo: strainIcon.bottomAnchor, constant: padding),
            noteTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            noteTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            noteTextField.heightAnchor.constraint(equalToConstant: 75),
            
            labelsView.topAnchor.constraint(equalTo: noteTextField.bottomAnchor),
            labelsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            labelsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            labelsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let wrapperViews = [UIView(), UIView(), UIView(), UIView()]
        let labels = [ratingLabel, consumptionMethodLabel, effectsLabel, locationLabel]
        let tagTypes = TagTypes.allCases
        
        for i in 0...3 {
            
            let collectionView = TagCollectionView(frame: wrapperViews[i].frame, tag: tagTypes[i], delegate: self)
            collectionViews.append(collectionView)
            labelsView.addSubview(wrapperViews[i])
            wrapperViews[i].addSubview(labels[i])
            wrapperViews[i].addSubview(collectionView)
            wrapperViews[i].translatesAutoresizingMaskIntoConstraints = false
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            
            if i == 0 {
                wrapperViews[i].topAnchor.constraint(equalTo: labelsView.topAnchor).isActive = true
            } else {
                wrapperViews[i].topAnchor.constraint(equalTo: wrapperViews[i-1].bottomAnchor).isActive = true
            }
            
            NSLayoutConstraint.activate([
                wrapperViews[i].leadingAnchor.constraint(equalTo: labelsView.leadingAnchor),
                wrapperViews[i].trailingAnchor.constraint(equalTo: labelsView.trailingAnchor),
                wrapperViews[i].heightAnchor.constraint(equalToConstant: 50),
                
                labels[i].centerYAnchor.constraint(equalTo: wrapperViews[i].centerYAnchor),
                labels[i].heightAnchor.constraint(equalTo: wrapperViews[i].heightAnchor),
                labels[i].leadingAnchor.constraint(equalTo: wrapperViews[i].leadingAnchor),
                labels[i].widthAnchor.constraint(equalToConstant: labels[i].intrinsicContentSize.width + 6),
                
                collectionView.topAnchor.constraint(equalTo: wrapperViews[i].topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: labels[i].trailingAnchor, constant: padding),
                collectionView.bottomAnchor.constraint(equalTo: wrapperViews[i].bottomAnchor),
                collectionView.trailingAnchor.constraint(equalTo: wrapperViews[i].trailingAnchor)
            ])
        }
    }
    
}


extension NewActivityVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



extension NewActivityVC : LocationPermissionDelegate {
    
    func askForLocationPermissionAgain() {
        let alertController = UIAlertController(title: "Unable to find your location", message: "Buds requires your location so you can add a new activity", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
             }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
