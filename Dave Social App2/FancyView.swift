//
//  FancyView.swift
//  Dave Social App2
//
//  Created by Dave Hofmann on 7/9/17.
//  Copyright © 2017 DaveApps. All rights reserved.
//

import UIKit

class FancyView: UIView {

    // add some shadowing
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.0
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        
        
    }
    
}
