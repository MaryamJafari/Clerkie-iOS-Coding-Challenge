//
//  CircleButton.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 8/31/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import Foundation
import UIKit

class CircleButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
         let color = UIColor(red:0.00, green:0.50, blue:0.93, alpha:1.8)
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        imageView?.contentMode = .scaleAspectFit
       
       backgroundColor = UIColor.white
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        
    }
    
}
