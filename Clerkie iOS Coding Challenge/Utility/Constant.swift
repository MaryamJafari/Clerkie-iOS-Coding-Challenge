//
//  Constant.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 8/31/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import Foundation
import  UIKit
class Constant {
    let SHADOW_GRAY : CGFloat = 157.0/225.0
    let color = UIColor(red:0.00, green:0.50, blue:0.93, alpha:1.8)
        //UIColor(red:0.00, green:0.67, blue:0.93, alpha:1.0)
        //UIColor(red:0.00, green:0.50, blue:0.93, alpha:1.8)
    //let color2 =  UIColor(red: 0.0039, green: 0.451, blue: 0.6588, alpha: 1.0) /* #0173a8 */
let navigationColor = UIColor(red:0.00, green:0.52, blue:0.71, alpha:1.0)
     //messages
    static let TEXT = "text"
    static let PHOTO_URL = "photo_url"
    static let SENDER_ID = "sender_Id"
    static let SENDER_NAME = "sender_Name"
    static let RECIVER_ID = "reciver_Id"
    static let RECIVER_NAME = "reciver_Name"
    static let URL = "url"
    static let DATE = "DATE"
    static let SENDERPHOTOURL = "SenderPhotoUrl"
    static let RECIVERPHOTOURL = "RecieverPhotoUrl"
    
    // DB Provider
    static let EMAIL = "email"
    static let PASSWORD = "password"
    static let PROFILE = "profiles"
    static let HASPROFILE = "profiles"
    static let MESSAGES = "Messages"
    static let MEDIA_MESSAGES = "Media_Messages"
    static let IMAGE_STORAGE = "Image_Storage"
    static let VIDEO_STORAGE = "Video_Storage"
    static let DATA = "data"
}
