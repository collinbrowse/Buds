//
//  ActivityCell.swift
//  Buds
//
//  Created by Collin Browse on 5/5/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {
    
    static let reuseID = String(describing: ActivityCell.self)
    weak var strainDelegate: StrainCollectionViewDelegate?
    
    let cardView = UIView()
    var strainIcon = BudsStrainImageView(frame: .zero)
    var strainAcronymLabel = BudsStrainTitleLabel(textAlignment: .center, fontSize: 16)
    var strainLabel = BudsTitleLabel(textAlignment: .center, fontSize: 18)
    var locationLabel = BudsSecondaryLabel(fontSize: 14, weight: .medium)
    var timeLabel = BudsSecondaryLabel(fontSize: 14, weight: .medium)
    var raceLabel = BudsSecondaryLabel(fontSize: 14, weight: .medium)
    var detailsLabel = BudsBodyLabel(textAlignment: .center)
    var ratingCategoryLabel = BudsSecondaryLabel(fontSize: 14, weight: .medium)
    var effectsCategoryLabel = BudsSecondaryLabel(fontSize: 14, weight: .medium)
    var typeCategoryLabel = BudsSecondaryLabel(fontSize: 14, weight: .medium)
    var ratingLabel = BudsSecondaryLabel(fontSize: 14, weight: .medium)
    var effectsLabel = BudsSecondaryLabel(fontSize: 14, weight: .medium)
    var typeLabel = BudsSecondaryLabel(fontSize: 14, weight: .medium)
    var line = UIView()
    
    var effectsScrollView = UIScrollView()
    let effectsContentView = UIView()
    var categoriesStackView = UIStackView()
    var descriptorsStackView = UIStackView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
        configureStrainIcon()
        configureStrainLabel()
        configureLocationLabel()
        configureDetailsLabel()
        configureLine()
        configureCategoriesStackView()
        configureDescriptorsStackView()
        layoutUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(activity: Activity) {
        strainLabel.text = activity.strain
        locationLabel.text = activity.location
        timeLabel.text = activity.date?.timeAgoString()
        detailsLabel.text = activity.note
        ratingLabel.text = String(activity.rating)
        setRace(race: activity.race!)
        setStrainAcronym(strain: activity.strain)
        setType(activity: activity)
        setEffects(activity: activity)
    }
    
    
    func set(delegate: StrainCollectionViewDelegate) {
        self.strainDelegate = delegate
    }
    
    
    private func setRace(race: String) {
        if race.lowercased() == "hybrid" {
            self.strainIcon.setBackgroundColor(with: RaceColors.hybrid)
            raceLabel.textColor = RaceColors.hybrid
        }
        else if race.lowercased() == "indica" {
            self.strainIcon.setBackgroundColor(with: RaceColors.indica)
            raceLabel.textColor = RaceColors.indica
        }
        else if race.lowercased() == "sativa" {
            self.strainIcon.setBackgroundColor(with: RaceColors.sativa)
            raceLabel.textColor = RaceColors.sativa
        }
        
        raceLabel.text = race.capitalizeFirstLetter()
    }
    
    
    private func setStrainAcronym(strain: String) {
        strainAcronymLabel.text = strain.getAcronymForStrain()
    }
    
    
    private func setType(activity: Activity) {
        
        switch activity.consumptionMethod {
        case .joint:
            typeLabel.text = "Joint"
        case .blunt:
            typeLabel.text = "Blunt"
        case .bowl:
            typeLabel.text = "Bowl"
        case .bong:
            typeLabel.text = "Bong"
        case .concentrate:
            typeLabel.text = "Concentrate"
        case .edible:
            typeLabel.text = "Edible"
        case .vape:
            typeLabel.text = "Vape"
        case .none:
            typeLabel.text = ""
        }
    }
    
    
    private func setEffects(activity: Activity) {
        
        var allEffects = ""
        if activity.effects != nil {
            for effect in activity.effects {
                allEffects +=  ", " + effect
            }
            effectsLabel.text = allEffects[2...]
        } else {
            effectsLabel.text = ""
        }
    }
    
    
    @objc func strainTapped() {
        
        strainDelegate?.startLoadingView()
        Network.getStrain(name: strainLabel.text!) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let resultJSON):
                let strain = Strain(name: self.strainLabel.text!, id: resultJSON[0]["id"].int, race: resultJSON[0]["race"].stringValue, flavors: nil, effects: nil)
                self.strainDelegate?.didTapStrain(for: strain)
            case .failure(let error):
                print(error.localizedDescription) // Don't display strain if there was an error
            }
        }
    }
    
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setCardViewStyling()
    }
    
    
    private func setCardViewStyling() {
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            cardView.backgroundColor = .systemBackground
            cardView.layer.shadowColor = UIColor.gray.cgColor
            cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            cardView.layer.shadowRadius = 5.0
            cardView.layer.shadowOpacity = 0.7
        case .dark:
            cardView.backgroundColor = .secondarySystemBackground
            cardView.layer.shadowColor = nil
            cardView.layer.shadowOffset = .zero
            cardView.layer.shadowRadius = 0
            cardView.layer.shadowOpacity = 0
        @unknown default:
            cardView.backgroundColor = .systemBackground
        }
    }
    
    
    private func configureCell() {
        
        setCardViewStyling()
        cardView.layer.cornerRadius = 15.0
        cardView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cardView)
    }
    
    
    private func configureStrainIcon() {
        strainIcon.isUserInteractionEnabled = true
        strainIcon.backgroundColor = .red
        strainIcon.layer.cornerRadius = 10
        let tap = UITapGestureRecognizer(target: self, action: #selector(strainTapped))
        strainIcon.addGestureRecognizer(tap)
    }
    
    
    private func configureStrainLabel() {
        strainLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(strainTapped))
        strainLabel.addGestureRecognizer(tap)
    }
    
    
    private func configureLocationLabel() {
        locationLabel.textAlignment = .center
    }
    
    
    private func configureDetailsLabel() {
        detailsLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    
    private func configureLine() {
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .lightGray
    }
    
    
    private func configureCategoriesStackView() {
        categoriesStackView.translatesAutoresizingMaskIntoConstraints = false
        effectsCategoryLabel.text = "Effects"
        ratingCategoryLabel.text = "Rating"
        typeCategoryLabel.text = "Type"
        categoriesStackView.axis = .vertical
        categoriesStackView.distribution = .fillProportionally
        categoriesStackView.addArrangedSubview(ratingCategoryLabel)
        categoriesStackView.addArrangedSubview(effectsCategoryLabel)
        categoriesStackView.addArrangedSubview(typeCategoryLabel)
    }
    
    
    private func configureDescriptorsStackView() {
        descriptorsStackView.translatesAutoresizingMaskIntoConstraints = false
        descriptorsStackView.axis = .vertical
        descriptorsStackView.distribution = .fillProportionally
        effectsScrollView.translatesAutoresizingMaskIntoConstraints = false
        effectsContentView.translatesAutoresizingMaskIntoConstraints = false
        descriptorsStackView.addArrangedSubview(ratingLabel)
        descriptorsStackView.addArrangedSubview(effectsLabel)
        descriptorsStackView.addArrangedSubview(typeLabel)
    }
    
    private func layoutUI() {
        
        addSubviews(timeLabel, raceLabel, strainIcon, strainAcronymLabel,  strainLabel, locationLabel, detailsLabel, categoriesStackView, descriptorsStackView, line)
        strainIcon.translatesAutoresizingMaskIntoConstraints = false

        let padding: CGFloat = 12
        let labelHeight : CGFloat = 20
        
        NSLayoutConstraint.activate([
            
            cardView.topAnchor.constraint(equalTo: topAnchor, constant: padding*2),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding*2),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding*2),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            
            timeLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: padding),
            timeLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding),
            timeLabel.widthAnchor.constraint(equalToConstant: 38),
            timeLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            raceLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: padding),
            raceLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            raceLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            raceLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: padding),
            
            strainIcon.topAnchor.constraint(equalTo: timeLabel.bottomAnchor),
            strainIcon.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            strainIcon.heightAnchor.constraint(equalToConstant: 50),
            strainIcon.widthAnchor.constraint(equalToConstant: 50),
            
            strainAcronymLabel.topAnchor.constraint(equalTo: strainIcon.topAnchor),
            strainAcronymLabel.leadingAnchor.constraint(equalTo: strainIcon.leadingAnchor),
            strainAcronymLabel.trailingAnchor.constraint(equalTo: strainIcon.trailingAnchor),
            strainAcronymLabel.bottomAnchor.constraint(equalTo: strainIcon.bottomAnchor),
            
            strainLabel.topAnchor.constraint(equalTo: strainIcon.bottomAnchor, constant: padding/2),
            strainLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            strainLabel.widthAnchor.constraint(equalTo: cardView.widthAnchor),
            strainLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            locationLabel.topAnchor.constraint(equalTo: strainLabel.bottomAnchor, constant: padding/4),
            locationLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            locationLabel.widthAnchor.constraint(equalTo: cardView.widthAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            detailsLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: padding/2),
            detailsLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            detailsLabel.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.9),
            detailsLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: labelHeight),
            
            line.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: padding),
            line.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding*3),
            line.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding*3),
            line.heightAnchor.constraint(equalToConstant: 1),
            
            categoriesStackView.topAnchor.constraint(equalTo: line.bottomAnchor, constant: padding),
            categoriesStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding*3),
            categoriesStackView.widthAnchor.constraint(equalToConstant: 70),
            categoriesStackView.heightAnchor.constraint(equalToConstant: 70),
            categoriesStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -padding),
            
            descriptorsStackView.topAnchor.constraint(equalTo: line.bottomAnchor, constant: padding),
            descriptorsStackView.leadingAnchor.constraint(equalTo: categoriesStackView.trailingAnchor, constant: padding),
            descriptorsStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding),
            descriptorsStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -padding)
        ])
    }
}
