//
//  RoundButton.swift
//  Dave Social App2
//
//  Created by Dave Hofmann on 7/9/17.
//  Copyright © 2017 DaveApps. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.0
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        imageView?.contentMode = .scaleAspectFit
        // layer.cornerRadius = 90.0
        
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
//        layer.shadowOpacity = 0.0
//        layer.shadowRadius = 5.0
//        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    
        layer.cornerRadius = self.frame.width / 2
    }
    
    
    
}
