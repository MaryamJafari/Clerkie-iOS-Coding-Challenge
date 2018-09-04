//
//  ProfileCell.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 9/1/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit

import FirebaseAuth

class ProfileCell: UITableViewCell {
    let color = UIColor(red: 0.2, green: 0.3843, blue: 0.5961, alpha: 1.0) /* #336298 */
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    
    func configureCell(profile : Profile){
        
        let url = URL(string:profile.imageURl)
        let data = try? Data(contentsOf: url!)
        let image: UIImage = UIImage(data: data!)!
        name.text = profile.email.capitalized
        profileImage.image = image

        
    }
    
}


