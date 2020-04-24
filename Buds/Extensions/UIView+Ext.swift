//
//  UIView+Ext.swift
//  Buds
//
//  Created by Collin Browse on 4/24/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
