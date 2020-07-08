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
    
    var strainIcon = BudsStrainImageView(frame: .zero)
    var strainAcronym = BudsStrainTitleLabel(textAlignment: .center, fontSize: 16)
    var strainLabel = BudsTitleLabel(textAlignment: .left, fontSize: 18)
    var locationLabel = BudsSecondaryLabel(fontSize: 14, weight: .medium)
    var timeLabel = BudsSecondaryLabel(fontSize: 14, weight: .medium)
    var detailsLabel = BudsBodyLabel(textAlignment: .left)
    var iconsStackView = UIStackView()
    var iconsViewOne = BudsIconView()
    var iconsViewTwo = BudsIconView()
    var iconsViewThree = BudsIconView()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureStrainIcon()
        configureStrainLabel()
        configureStackView()
        configureDetailsLabel()
        layoutUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(activity: Activity) {
        setRaceColor(race: activity.race!)
        setStrainAcronym(strain: activity.strain)
        strainLabel.text = activity.strain
        locationLabel.text = activity.location
        timeLabel.text = activity.date?.timeAgoString()
        detailsLabel.text = activity.note
        setIcons(activity: activity)
    }
    
    
    func set(delegate: StrainCollectionViewDelegate) {
        self.strainDelegate = delegate
    }
    
    
    private func setIcons(activity: Activity) {
        iconsViewOne.setRating(withRating: String(activity.rating))
        iconsViewTwo.setConsumptionIcon(withConsumptionMethod: activity.consumptionMethod!)
        iconsViewThree.setEffects(withEffects: activity.effects ?? [])
    }
    
    
    private func setRaceColor(race: String) {
        if      race.lowercased() == "hybrid" { self.strainIcon.setBackgroundColor(with: RaceColors.hybrid) }
        else if race.lowercased() == "indica" { self.strainIcon.setBackgroundColor(with: RaceColors.indica) }
        else if race.lowercased() == "sativa" { self.strainIcon.setBackgroundColor(with: RaceColors.sativa) }
    }
    
    
    private func setStrainAcronym(strain: String) {
        strainAcronym.text = strain.getAcronymForStrain()
    }
    
    
    @objc func strainLabelTapped() {
        
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
    
    
    private func configureStrainIcon() {
        strainIcon.backgroundColor = .red
        strainIcon.layer.cornerRadius = 10
    }
    
    
    private func configureStrainLabel() {
        strainLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(strainLabelTapped))
        strainLabel.addGestureRecognizer(tap)
    }
    

    private func configureStackView() {
        iconsStackView.axis = .horizontal
        iconsStackView.distribution = .fillProportionally
        iconsStackView.addArrangedSubview(iconsViewOne)
        iconsStackView.addArrangedSubview(iconsViewTwo)
        iconsStackView.addArrangedSubview(iconsViewThree)
    }
    
    
    private func configureDetailsLabel() {
        detailsLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    
    private func layoutUI() {
        
        addSubviews(strainIcon, strainAcronym, timeLabel, strainLabel, locationLabel, detailsLabel, iconsStackView)
        strainIcon.translatesAutoresizingMaskIntoConstraints = false
        iconsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 12
        let labelHeight : CGFloat = 20
        
        NSLayoutConstraint.activate([
            strainIcon.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            strainIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            strainIcon.heightAnchor.constraint(equalToConstant: 50),
            strainIcon.widthAnchor.constraint(equalToConstant: 50),
            
            strainAcronym.topAnchor.constraint(equalTo: strainIcon.topAnchor),
            strainAcronym.leadingAnchor.constraint(equalTo: strainIcon.leadingAnchor),
            strainAcronym.trailingAnchor.constraint(equalTo: strainIcon.trailingAnchor),
            strainAcronym.bottomAnchor.constraint(equalTo: strainIcon.bottomAnchor),

            timeLabel.topAnchor.constraint(equalTo: strainIcon.topAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            timeLabel.widthAnchor.constraint(equalToConstant: 38),
            timeLabel.heightAnchor.constraint(equalToConstant: labelHeight),

            strainLabel.topAnchor.constraint(equalTo: strainIcon.topAnchor),
            strainLabel.leadingAnchor.constraint(equalTo: strainIcon.trailingAnchor, constant: padding),
            strainLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -padding),
            strainLabel.heightAnchor.constraint(equalToConstant: labelHeight),

            locationLabel.topAnchor.constraint(equalTo: strainLabel.bottomAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: strainIcon.trailingAnchor, constant: padding),
            locationLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -padding),
            locationLabel.heightAnchor.constraint(equalToConstant: labelHeight),

            iconsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            iconsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            iconsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            iconsStackView.heightAnchor.constraint(equalToConstant: labelHeight),
            
            detailsLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            detailsLabel.leadingAnchor.constraint(equalTo: strainIcon.trailingAnchor, constant: padding),
            detailsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            // Min height must have detailsLabelHeight+locationLabelHeight+strainLabelHeight = strainIconHeight
            detailsLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: labelHeight),
            detailsLabel.bottomAnchor.constraint(equalTo: iconsStackView.topAnchor, constant: -6)
        ])
    }
}
