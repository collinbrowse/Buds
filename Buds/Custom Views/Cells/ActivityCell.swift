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
    
    var strainIcon = UIImageView(frame: .zero)
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
        configure()
        configureStackView()
        configureDetailsLabel()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    
    func configure() {
        
        addSubviews(strainIcon, timeLabel, strainLabel, locationLabel, detailsLabel, iconsStackView)
        strainIcon.translatesAutoresizingMaskIntoConstraints = false
        iconsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 12
        let labelHeight : CGFloat = 20
        
        NSLayoutConstraint.activate([
            strainIcon.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            strainIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            strainIcon.heightAnchor.constraint(equalToConstant: 50),
            strainIcon.widthAnchor.constraint(equalToConstant: 50),

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
    
    func set(activity: Activity) {
                   
        strainIcon.image = Icons.defaultStrainIcon
        strainLabel.text = activity.strain
        locationLabel.text = activity.location + ""
        timeLabel.text = activity.date?.timeAgoString()
        detailsLabel.text = activity.note
        setIcons(activity: activity)
    }
    
    private func setIcons(activity: Activity) {
        iconsViewOne.setRating(withRating: String(activity.rating))
        iconsViewTwo.setConsumptionIcon(withConsumptionMethod: activity.consumptionMethod!)
        iconsViewThree.setEffects(withEffects: activity.effects ?? [])
    }
}
