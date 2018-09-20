//
//  Searching.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 8/31/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import  UIKit
import  FirebaseAuth

class Searching: UIViewController,  UITableViewDelegate, UITableViewDataSource, FetchData{
    var menuShowing = false
    let searchController = UISearchController(searchResultsController: nil)
    var notificationToken : String!
    var reciverID : String!
    var receiverName : String!
    var email : String!
    var photURL : URL!
    var recieverPhoto : String?
    var senderPhoto : String?
    var inSearchableMode = false
    var newProfile = [Profile]()
    var filterProfile = [Profile]()
    private var profiles = [Profile]()
    var pickerData : [String] = [String]()
    
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:Constant().navigationColor]
        self.navigationItem.title = "Contacts"
        table.delegate = self
        table.dataSource = self
        DBProvider.Instance.delegate = self
        DBProvider.Instance.getProfiles()
        searchController.searchResultsUpdater =   self
        definesPresentationContext = true
        table.tableHeaderView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["Name"]
        searchController.searchBar.delegate = self
        
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 23)!]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:Constant().navigationColor]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        
    }
  
    
    func dataRecieved(contacts : [Profile]){
        self.profiles = contacts
        for contact in contacts{
            if contact.id == AuthProvider.Instance.userID(){
                AuthProvider.Instance.username = contact.email
            }
        }
        for profile in profiles{
            if (profile.id != Auth.auth().currentUser?.uid ){
                newProfile.append(profile)
            }
        }
        table.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchController.isActive && searchController.searchBar.text != ""){
            return filterProfile.count
        }
        return newProfile.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ProfileCell
        var profile : Profile!
        
        
        if(searchController.isActive && searchController.searchBar.text != ""){
            profile = filterProfile[indexPath.row]
            
            
        }
        else{
            profile = newProfile[indexPath.row]
            
        }
     
        cell?.configureCell(profile:profile)
        return cell!
    }
    
    @IBAction func logOut(_ sender: Any) {
        if AuthProvider.Instance.logOut(){
            navigationController?.popToRootViewController(animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.recieverPhoto =  newProfile[indexPath.row].imageURl
        
        receiverName = newProfile[indexPath.row].email
   
        performSegue(withIdentifier: "Chat", sender: newProfile[indexPath.row].id)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "Chat"{
            
            if let destination = segue.destination as? Chat{
                if let id = sender as? String{
                    destination.reciverId = id
                    destination.ReciverName = receiverName
                    if let photo = Auth.auth().currentUser?.photoURL{
                        destination.senderPhotURL = photo
                    }
                    destination.recieverPhotURL = recieverPhoto
                   
                    
                }
            }
        }
    }
    
    func searching(searchText : String, scope : String ){
        var newScope = scope
        if newScope == "Name" {
            filterProfile = newProfile.filter{profile in
                return   profile.email.lowercased().contains(searchText.lowercased())
                
            }
        }

        table.reloadData()
    }
}

extension Searching : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchbar = searchController.searchBar
        let scope = searchbar.scopeButtonTitles![searchbar.selectedScopeButtonIndex]
        
        searching(searchText: searchController.searchBar.text!, scope: scope)
    }
}

extension Searching : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searching(searchText: searchController.searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}


