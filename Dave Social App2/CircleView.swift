//
//  CircleView.swift
//  Dave Social App2
//
//  Created by Dave Hofmann on 8/11/17.
//  Copyright © 2017 DaveApps. All rights reserved.
//

import UIKit

class CircleView: UIImageView {


    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
        
    

    
        
        
        
    
}
