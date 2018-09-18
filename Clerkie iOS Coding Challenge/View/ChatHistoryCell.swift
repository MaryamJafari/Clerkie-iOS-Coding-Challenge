//
//  ChatHistoryCell.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 8/31/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit
import  FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class ChatHistoryCell: UITableViewCell {
    var myImage: UIImage?
    let color = UIColor(red: 0.2, green: 0.3843, blue: 0.5961, alpha: 1.0) /* #336298 */
    let gold = UIColor(red: 0.6431, green: 0.5373, blue: 0.1647, alpha: 1.0) /* #a4892a */
    var chatPartnerImage : String?
    var partnerName : String?
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
        
    }
    override func awakeFromNib() {
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
    }
    
    func configureCell( message : Message){
        
        if message.senderId == Auth.auth().currentUser?.uid{
            chatPartnerImage = message.reciverImageURL
        }
        else{
            chatPartnerImage = message.imageURl
        }
        let timeStampe = NSDate(timeIntervalSince1970: message.date.doubleValue)
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        
        
        time.text = formatter.string(from: timeStampe as Date)
        
        
        let url = URL(string:chatPartnerImage!)
        
        let data = try? Data(contentsOf: url!)
        myImage = UIImage(data: data!)!
        
        
        if (message.senderId == Auth.auth().currentUser?.uid){
            partnerName = message.receiverName
        }
        else {
            partnerName = message.senderName
        }
        name.text = partnerName?.capitalized
        profileImage.image = myImage
        messageLabel.text = message.message
        
    }
    
}

