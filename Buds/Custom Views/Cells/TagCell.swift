//
//  TagCell.swift
//  Buds
//
//  Created by Collin Browse on 5/7/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {
    
    
    static let reuseID = String(describing: TagCell.self)
    
    var label = UILabel()
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                backgroundColor = .systemGreen
                label.textColor = .label
            }
            else {
                backgroundColor = .systemGray5
                label.textColor = .systemGreen
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        configureLabel()
        layoutUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureCell() {
        layer.cornerRadius = 10
        backgroundColor = .systemGray5
    }
    
    
    private func configureLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .systemGreen
    }
    
    
    private func layoutUI() {
        
        let padding : CGFloat = 5
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: padding - 2),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding * 2),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding * 2),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding + 2)
        ])
    }
    
    
    func set(labelText: String) {
        label.text = labelText
    }
    
}
