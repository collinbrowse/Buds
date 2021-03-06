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
    var ratingLabel = BudsTitleLabel(textAlignment: .left, fontSize: 18)
    var consumptionMethodLabel = BudsTitleLabel(textAlignment: .left, fontSize: 18)
    var effectsLabel = BudsTitleLabel(textAlignment: .left, fontSize: 18)
    var locationLabel = BudsTitleLabel(textAlignment: .left, fontSize: 18)
    let brandLabel = BudsTitleLabel(textAlignment: .left, fontSize: 20)
    let brandTextField = UITextField(frame: .zero)
    let brandWrapperView = UIView()
    
    var distanceToMoveKeyboard : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureStrainIcon()
        configureStrainLabel()
        configureRaceLabel()
        configureNoteTextField()
        configureLabels()
        configureBrandTextField()
        layoutUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        removeNavigationBar()
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if brandTextField.isFirstResponder {
            guard let userInfo = notification.userInfo else {return}
            guard let keyboard = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
            let keyboardFrame = keyboard.cgRectValue
            let brandWrapperViewInFrame = view.convert(brandWrapperView.frame, from: labelsView)
            distanceToMoveKeyboard = ((brandWrapperViewInFrame.origin.y + brandWrapperView.frame.height) - keyboardFrame.origin.y)
            if self.view.frame.origin.y == 0 && distanceToMoveKeyboard > 0 {
                self.view.frame.origin.y -= distanceToMoveKeyboard
            }
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {

        if self.view.frame.origin.y != 0 && distanceToMoveKeyboard > 0 {
            self.view.frame.origin.y += distanceToMoveKeyboard
        }
    }
    
    
    @objc func addButtonTapped() {
        
        var activityDetailsDict                 = [String : Any]()
        activityDetailsDict["user"]             = modelController.person.id
        activityDetailsDict["time"]             = TimeHelper.getTodayString()
        activityDetailsDict["strain"]           = strainLabel.text
        activityDetailsDict["note"]             = noteTextField.text
        activityDetailsDict["race"]             = raceLabel.text?.lowercased()
        activityDetailsDict["brand"]            = brandTextField.text ?? ""
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(NewActivityVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewActivityVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    
    private func configureBrandTextField() {
        brandTextField.translatesAutoresizingMaskIntoConstraints = false
        brandTextField.font = UIFont.systemFont(ofSize: 17, weight: .light)
        brandTextField.textColor = .label
        brandTextField.attributedPlaceholder = NSAttributedString(string: "Who grew this strain?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        brandTextField.returnKeyType = .done
        brandTextField.delegate = self
        brandTextField.autocorrectionType = .no
    }
    
    
    private func configureNoteTextField() {
        noteTextField.translatesAutoresizingMaskIntoConstraints = false
        noteTextField.font = UIFont.systemFont(ofSize: 17, weight: .light)
        noteTextField.textColor = .label
        noteTextField.attributedPlaceholder = NSAttributedString(string: "How was it? Leave a note for later", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        noteTextField.returnKeyType = .done
        noteTextField.delegate = self
    }
    
    
    private func configureLabels() {
        labelsView.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.text = "Rating"
        consumptionMethodLabel.text = "Method"
        effectsLabel.text = "Effects"
        locationLabel.text = "Location"
        brandLabel.text = "Brand"
    }
    
    
    private func layoutUI() {
        
        view.addSubviews(strainIcon, strainLabel, raceLabel, noteTextField, labelsView)
        
        let padding : CGFloat = 12
        let labelsWidth : CGFloat = 75
        
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
            wrapperViews[i].addSubviews(labels[i], collectionView)
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
                labels[i].widthAnchor.constraint(equalToConstant: labelsWidth),
                
                collectionView.topAnchor.constraint(equalTo: wrapperViews[i].topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: labels[i].trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: wrapperViews[i].bottomAnchor),
                collectionView.trailingAnchor.constraint(equalTo: wrapperViews[i].trailingAnchor)
            ])
        }
        
        brandWrapperView.translatesAutoresizingMaskIntoConstraints = false
        brandWrapperView.addSubviews(brandLabel, brandTextField)
        labelsView.addSubview(brandWrapperView)
        
        NSLayoutConstraint.activate([
            brandWrapperView.leadingAnchor.constraint(equalTo: labelsView.leadingAnchor),
            brandWrapperView.topAnchor.constraint(equalTo: wrapperViews[3].bottomAnchor),
            brandWrapperView.trailingAnchor.constraint(equalTo: labelsView.trailingAnchor),
            brandWrapperView.heightAnchor.constraint(equalToConstant: 50),
            
            brandLabel.centerYAnchor.constraint(equalTo:    brandWrapperView.centerYAnchor),
            brandLabel.heightAnchor.constraint(equalTo:     brandWrapperView.heightAnchor),
            brandLabel.leadingAnchor.constraint(equalTo:    brandWrapperView.leadingAnchor),
            brandLabel.widthAnchor.constraint(equalToConstant: labelsWidth),
            
            brandTextField.topAnchor.constraint(equalTo:        brandWrapperView.topAnchor),
            brandTextField.leadingAnchor.constraint(equalTo:    brandLabel.trailingAnchor, constant: padding),
            brandTextField.bottomAnchor.constraint(equalTo:     brandWrapperView.bottomAnchor),
            brandTextField.trailingAnchor.constraint(equalTo:   brandWrapperView.trailingAnchor)
        ])
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
