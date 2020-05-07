//
//  NewActivityVC.swift
//  Buds
//
//  Created by Collin Browse on 5/7/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit


class NewActivityVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    var strain : Strain!
    
    var strainIcon = UIImageView(frame: .zero)
    var strainLabel = BudsTitleLabel(textAlignment: .left, fontSize: 20)
    var raceLabel = BudsSecondaryLabel(fontSize: 16, weight: .medium)
    var noteTextField = UITextField(frame: .zero)
    var labelsView = UIView()
    var ratingLabel = BudsTitleLabel(textAlignment: .left, fontSize: 20)
    var consumptionMethodLabel = BudsTitleLabel(textAlignment: .left, fontSize: 20)
    var effectsLabel = BudsTitleLabel(textAlignment: .left, fontSize: 20)
    var locationLabel = BudsTitleLabel(textAlignment: .left, fontSize: 20)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureViewController()
        configureStrainIcon()
        configureStrainLabel()
        configureRaceLabel()
        configureNoteTextField()
        configureLabels()
        layoutUI()
    }
    
    
    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGreen
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        title = "New Activity"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
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
        noteTextField.textColor = .systemGray
        noteTextField.attributedPlaceholder = NSAttributedString(string: "How was it? Leave a note for later", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])


    }
    
    
    private func configureLabels() {
        labelsView.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.text = "Rating"
        consumptionMethodLabel.text = "Consumption Method"
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
            noteTextField.heightAnchor.constraint(equalToConstant: 50),
            
            labelsView.topAnchor.constraint(equalTo: noteTextField.bottomAnchor),
            labelsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            labelsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            labelsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
        let labels = [ratingLabel, consumptionMethodLabel, effectsLabel, locationLabel]
        
        for label in labels {
            labelsView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: labelsView.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: labelsView.trailingAnchor),
                label.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: labelsView.topAnchor),
            consumptionMethodLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor),
            effectsLabel.topAnchor.constraint(equalTo: consumptionMethodLabel.bottomAnchor),
            locationLabel.topAnchor.constraint(equalTo: effectsLabel.bottomAnchor)
        ])
        
    }
}



