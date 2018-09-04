//
//  RoundedTextBox.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 8/31/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import Foundation
import UIKit
class RoundedTextBox: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: Constant().SHADOW_GRAY, green: Constant().SHADOW_GRAY, blue: Constant().SHADOW_GRAY, alpha: 0.9).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        let color = UIColor(red:0.00, green:0.50, blue:0.93, alpha:1.8)
        layer.borderColor = color.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 25
        layer.masksToBounds = true
    }
    
    
}
