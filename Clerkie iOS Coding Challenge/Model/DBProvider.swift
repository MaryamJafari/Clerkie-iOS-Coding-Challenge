//
//  DBProvider.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 8/31/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//


import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol FetchData : class{
    func dataRecieved (contacts : [Profile]);
    
}
protocol FetchDatafromMessages : class{
    func messageRecieved (contacts : [Message]);
    
}
class DBProvider {
    weak var delegate : FetchData?
    private static let _instance = DBProvider();
    
    private init(){}
    static var Instance : DBProvider{
        return _instance
    }
    
    var dbRef : DatabaseReference {
        return Database.database().reference()
    }
    var contactsRef : DatabaseReference{
        return dbRef.child(Constant.PROFILE)
    }
    var messagessRef : DatabaseReference{
        return dbRef.child(Constant.MESSAGES)
    }
    
    var messageRef : DatabaseReference{
        return dbRef.child(Constant.MESSAGES)
    }
    var mediamessageRef : DatabaseReference{
        return dbRef.child(Constant.MEDIA_MESSAGES)
    }
    var storageRef : StorageReference{
        return Storage.storage().reference(forURL: "gs://clerkie-e614f.appspot.com")
    }
    
    var imageStorageRef : StorageReference{
        return storageRef.child(Constant.IMAGE_STORAGE)
    }
  
    var videoStorageRef : StorageReference{
        return storageRef.child(Constant.VIDEO_STORAGE)
    }
    func userExists(userId : String, completion: @escaping (Bool) -> Void){
        var x = false
        contactsRef.observeSingleEvent(of: DataEventType.value) { (snapshot : DataSnapshot) in
            if let mycontacts = snapshot.value as? NSDictionary{
                for (key, _) in mycontacts{
                    let id1 = key as! String
                    if (id1 == userId){
                        x = true
                        
                    }
                }
                
            }
            completion(x )
        }
        
    }
    
    func saveUser (withID : String, email : String, image : String ){
        let data : Dictionary<String, Any> = [Constant.EMAIL : email, Constant.PASSWORD : "", Constant.PHOTO_URL : image]
        contactsRef.child(withID).setValue(data)
    }
    func saveUser (withID : String, email : String, password : String, image : String = "https://lh3.googleusercontent.com/-tUQB3Dsk-CA/AAAAAAAAAAI/AAAAAAAAAAA/APUIFaPgyTfT06HN4e-r6WbWlnfFwYc1PQ/s96-c/photo.jpg"){
        let data : Dictionary<String, Any> = [Constant.EMAIL : email, Constant.PASSWORD : Constant.PASSWORD, Constant.PHOTO_URL :image]
        contactsRef.child(withID).setValue(data)
    }
    func getProfiles(){
        contactsRef.observeSingleEvent(of: DataEventType.value) { (snapshot : DataSnapshot) in
            var contacts = [Profile]()
            if let mycontacts = snapshot.value as? NSDictionary{
                for (key, value) in mycontacts{
                    if let contactData = value as?NSDictionary{
                        if let email = contactData[Constant.EMAIL] as? String {
                            let id = key as! String
                            let imageUrl = contactData[Constant.PHOTO_URL] as? String
                            let newContact = Profile(email: email, imageURL: imageUrl!, id: id)
                            
                            contacts.append(newContact)
                        }
                        
                    }
                    
                }
                
                
                
            }
            self.delegate?.dataRecieved(contacts: contacts)
        }
        
    }
    
}
