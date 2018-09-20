//
//  RoundedView.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 9/1/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//


import Foundation
import UIKit

class CircleView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let color = Constant().color
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
      
        
        backgroundColor = UIColor.white
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        
    }
    
}
