//
//  CustomeView.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 9/17/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit

class CustomeView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        let color = UIColor.gray /* #336298 */

        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 3.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    

}
