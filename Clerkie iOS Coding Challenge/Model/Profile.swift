//
//  Profile.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 9/1/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import Foundation
import Foundation
class Profile{
    private var _email = ""
    private var _ImageURL = ""
    private var _id = ""
    
    init(email : String, imageURL: String, id : String ){
        _email = email
        _ImageURL = imageURL
        _id = id
    }
    var email : String{
        get{
            return _email
        }
    }
    var imageURl : String{
        set { _ImageURL = newValue}
        get{
            return _ImageURL
        }
    }
    var id : String{
        get{
            return _id
        }
        
        
    }
    
}
