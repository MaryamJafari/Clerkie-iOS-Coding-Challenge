//
//  Message.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 8/31/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import Foundation
class Message{
    private var _senderName = ""
    private var _receiverName = ""
    private var _recieverId = ""
    private var _senderId = ""
    private var _ImageURL = ""
    private var _reciverImageURL = ""
    private var _date : NSNumber? = nil
    private var _message = ""
    private var _notificationToken = ""
    init(senderName : String, receiverName : String , recieverid : String, imageURL: String, senderId: String, message: String, date : NSNumber, reciverImageURL: String){
        _senderName = senderName
        _receiverName = receiverName
        _ImageURL = imageURL
        _recieverId = recieverid
        _senderId = senderId
        _message = message
        _date = date
        _reciverImageURL = reciverImageURL
     
        
    }
    var senderName : String{
        get{
            return _senderName
        }
        set{
            _senderName = newValue
        }
    }
    var reciverImageURL : String{
        get{
            return _reciverImageURL
        }
        set{
            _reciverImageURL = newValue
        }
    }
    var notificationToken : String{
        get{
            return _notificationToken
        }
        set{
            _notificationToken = newValue
        }
    }
    var receiverName : String{
        get{
            return _receiverName
        }
        set{
            _receiverName = newValue
        }
    }
    
    var recieverId : String{
        get{
            return _recieverId
        }
        set{
            _recieverId = newValue
        }
    }
    var date : NSNumber{
        get{
            return _date!
        }
        set{
            _date = newValue
        }
    }
    
    var senderId : String{
        get{
            return _senderId
        }
        set{
            _senderId = newValue
        }
    }
    var message : String{
        get{
            return _message
        }
        set{
            _message = newValue
        }
    }
    
    var imageURl : String{
        set { _ImageURL = newValue}
        get{
            return _ImageURL
        }
        
    }
    
}


