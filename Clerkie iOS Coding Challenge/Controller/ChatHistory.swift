//
//  ChatHistory.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 8/31/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//


import UIKit
import  FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ChatHistory: UIViewController,  UITableViewDelegate, UITableViewDataSource, ChatHistoryDelegate{
    var updatedText : Message?
    var  partnerImage : String?
    var notificationToken : String!
    var partnerName : String?
    var menuShowing = false
    let searchController = UISearchController(searchResultsController: nil)
    var partnerId : String?
    var ID : String!
    var receverID: String?
    var receiverName : String!
    var email : String!
    var photURL : URL!
    var inSearchableMode = false
    var newMessage = [Message]()
    var msgDictionary = [String : Message]()
    var filterMessge = [Message]()
    private var messges = [Message]()
    var allMessages = [Message]()
    var pickerData : [String] = [String]()
    var chatPartenrId : String?
    var notification : String?
    @IBOutlet weak var table: UITableView!
    var newPartnerId : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UIColor(red: 0.0039, green: 0.451, blue: 0.6588, alpha: 1.0) /* #0173a8 */
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:color]
        
        table.delegate = self
        table.dataSource = self
        observeUserMessages()
        observeMediaUserMessages()
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        table.tableHeaderView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["Name","Chat History"]
        searchController.searchBar.delegate = self
        table.allowsMultipleSelectionDuringEditing = true
    }
    
    func messageRecieved(contacts: [Message]) {
        self.newMessage = contacts
        
    }
    func chatHistoryUpdateRecieved(data: Message?) {
        updatedText = data
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let message = self.newMessage[indexPath.row]
        
        
        if (message.senderId == Auth.auth().currentUser?.uid){
            partnerId = message.recieverId
        }
        else {
            partnerId = message.senderId
        }
        Database.database().reference().child("user_messages").child(uid).child(partnerId!).removeValue { (error , ref) in
            if error != nil{
                print (error)
                return
            }
            self.msgDictionary.removeValue(forKey: self.partnerId!)
            DispatchQueue.main.async {
                self.table.reloadData()
            }
            
        }
    }
    func observeUserMessages(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user_messages").child(uid)
        ref.observe(DataEventType.childAdded, with: { (snapshot : DataSnapshot)  in
            
            let messageId = snapshot.key
            let messageRef =  Database.database().reference().child("Messages").child(messageId)
            
            messageRef.observeSingleEvent(of: .value , with: { (snapshot ) in
                
                if let data = snapshot.value as? NSDictionary {
                    if let senderID = data[Constant.SENDER_ID] as? String{
                        if let senderName = data[Constant.SENDER_NAME] as? String{
                            if let recieverName = data[Constant.RECIVER_NAME] as? String{
                                if let  date = data[Constant.DATE] as? NSNumber{
                                    if let senderImageUrl = data[Constant.SENDERPHOTOURL] as? String{
                                        if let receiverImageUrl = data[Constant.RECIVERPHOTOURL] as? String{
                                            if let text = data[Constant.TEXT] as? String{
                                                if let reciverId = data[Constant.RECIVER_ID] as? String{
                                                    let message = Message(senderName: senderName, receiverName: recieverName, recieverid: reciverId, imageURL: senderImageUrl, senderId: senderID, message: text, date: date, reciverImageURL: receiverImageUrl)
                                                    
                                                    self.allMessages.append(message)
                                                    var partnerId : String?
                                                    
                                                    if (senderID == Auth.auth().currentUser?.uid){
                                                        partnerId = reciverId
                                                    }
                                                    else {
                                                        partnerId = senderID
                                                    }
                                                    self.msgDictionary[partnerId!] = message
                                                    self.newMessage =  Array(self.msgDictionary.values)
                                                    self.newMessage.sort(by: { (msg1, msg2) -> Bool in
                                                        return  msg1.date.intValue > msg2.date.intValue
                                                    })
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
        ref.observeSingleEvent(of: .childRemoved , with: { (snapshot) in
            self.msgDictionary.removeValue(forKey: snapshot.key)
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }, withCancel: nil)
    }
    
    func observeMediaUserMessages(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user_messages").child(uid)
        ref.observe(DataEventType.childAdded, with: { (snapshot : DataSnapshot)  in
            
            let messageId = snapshot.key
            let messageRef =  Database.database().reference().child("Media_Messages").child(messageId)
            
            messageRef.observeSingleEvent(of: .value , with: { (snapshot ) in
                
                if let data = snapshot.value as? NSDictionary {
                    if let senderID = data[Constant.SENDER_ID] as? String{
                        if let senderName = data[Constant.SENDER_NAME] as? String{
                            if let recieverName = data[Constant.RECIVER_NAME] as? String{
                                if let  date = data[Constant.DATE] as? NSNumber{
                                    if let senderImageUrl = data[Constant.SENDERPHOTOURL] as? String{
                                        if let receiverImageUrl = data[Constant.RECIVERPHOTOURL] as? String{
                                            if let reciverId = data[Constant.RECIVER_ID] as? String{
                                                let message = Message(senderName: senderName, receiverName: recieverName, recieverid: reciverId, imageURL: senderImageUrl, senderId: senderID, message: "Image or Video", date: date, reciverImageURL: receiverImageUrl)
                                                
                                                var partnerId : String?
                                                
                                                if (senderID == Auth.auth().currentUser?.uid){
                                                    partnerId = reciverId
                                                }
                                                else {
                                                    partnerId = senderID
                                                }
                                                self.msgDictionary[partnerId!] = message
                                                self.newMessage =  Array(self.msgDictionary.values)
                                                self.newMessage.sort(by: { (msg1, msg2) -> Bool in
                                                    return  msg1.date.intValue > msg2.date.intValue
                                                })
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                }
                
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
        ref.observeSingleEvent(of: .childRemoved , with: { (snapshot) in
            self.msgDictionary.removeValue(forKey: snapshot.key)
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }, withCancel: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchController.isActive && searchController.searchBar.text != ""){
            return filterMessge.count
        }
        return newMessage.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ChatHistoryCell
        
        var msg : Message!
        
        if(searchController.isActive && searchController.searchBar.text != ""){
            
            msg = filterMessge[indexPath.row]
            cell?.configureCell( message : (msg))
            
            
        }
        else{
            if updatedText != nil {
                cell?.configureCell( message : (updatedText)!)
            }
            msg = newMessage[indexPath.row]
            cell?.configureCell( message : (msg))
            
        }
        
        return cell!
    }
    
    @IBAction func logOut(_ sender: Any) {
        if AuthProvider.Instance.logOut(){
            navigationController?.popToRootViewController(animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        receiverName =  newMessage[indexPath.row].receiverName

        if (newMessage[indexPath.row].senderId == Auth.auth().currentUser?.uid){
          
                self.newPartnerId = self.newMessage[indexPath.row].recieverId
                self.partnerImage = self.newMessage[indexPath.row].reciverImageURL
                self.partnerName = self.newMessage[indexPath.row].receiverName
                self.performSegue(withIdentifier: "FromChatHistorytoChat", sender: self.newPartnerId)
                
            
            
        }
        else {
    
                self.newPartnerId = self.newMessage[indexPath.row].senderId
                self.partnerImage = self.newMessage[indexPath.row].imageURl
                self.partnerName = self.newMessage[indexPath.row].senderName
                self.performSegue(withIdentifier: "FromChatHistorytoChat", sender: self.newPartnerId)
                
            
            
        }
  
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "FromChatHistorytoChat"{
            if let destination = segue.destination as? Chat{
                if let id = sender as? String{
                    destination.reciverId = id
                    destination.ReciverName = partnerName
                    var photo = URL(string: "https://lh3.googleusercontent.com/-tUQB3Dsk-CA/AAAAAAAAAAI/AAAAAAAAAAA/APUIFaPgyTfT06HN4e-r6WbWlnfFwYc1PQ/s96-c/photo.jpg")
                    
                    if let image = Auth.auth().currentUser?.photoURL{
                        photo = image
                    }
                    destination.senderPhotURL = photo
                    destination.recieverPhotURL = partnerImage
                    destination.SenderName = Auth.auth().currentUser?.email
                    destination.delegate = self
                    destination.notificationToken = notification
                    
                }
            }
            
            if segue.identifier == "Chat"{
                if let destination = segue.destination as? Chat{
                    if let id = sender as? String{
                        destination.reciverId = id
                        destination.ReciverName = receiverName
                        
                    }
                }
            }
        }
    }
    
    func searching(searchText : String, scope : String ){
        let newScope = scope
        if newScope == "Name" {
            filterMessge = newMessage.filter{name in
                return   name.receiverName.contains(searchText.lowercased())
                
            }
        }
            
        else if newScope == "Chat History" {
            
            filterMessge = allMessages.filter{msg in
                return   msg.message.lowercased().contains(searchText.lowercased())
                
            }
        }
        
        table.reloadData()
    }
}

extension ChatHistory : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchbar = searchController.searchBar
        let scope = searchbar.scopeButtonTitles![searchbar.selectedScopeButtonIndex]
        
        searching(searchText: searchController.searchBar.text!, scope: scope)
    }
}

extension ChatHistory : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searching(searchText: searchController.searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
