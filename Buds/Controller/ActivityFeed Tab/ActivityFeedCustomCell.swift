//
//  ActivityFeedCustomCell.swift
//  Buds
//
//  Created by Collin Browse on 7/19/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import UIKit


class ActivityFeedCustomCell: UITableViewCell {
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeTextView: UITextView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var strainTextView: UITextView!
    @IBOutlet weak var ratingTextView: UITextView!
    @IBOutlet weak var smokingStyleTextView: UITextView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameTextView.text = ""
        timeTextView.text = ""
        locationLabel.text = ""
        noteTextView.text = ""
        strainTextView.text = ""
        ratingTextView.text = ""
        smokingStyleTextView.text = ""
    }
    
    
}

