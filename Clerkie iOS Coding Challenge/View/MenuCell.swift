//
//  MenuCell.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 9/17/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    let color = UIColor(red: 0.2, green: 0.3843, blue: 0.5961, alpha: 1.0) /* #336298 */
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
        
    }
    override func awakeFromNib() {
     
    }
    func configureCell(image : String, cellneme : String){
      profileImage.image = UIImage(named: image)
        self.name.text = cellneme
        
        
    }
    
}


