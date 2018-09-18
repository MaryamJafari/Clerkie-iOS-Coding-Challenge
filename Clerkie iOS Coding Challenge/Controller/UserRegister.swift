//
//  UserRegister.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 8/31/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class UserRegister: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var userName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UIColor(red:0.00, green:0.50, blue:0.93, alpha:1.8)
        view.backgroundColor = color
        userName.delegate = self
        pass.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBOutlet weak var dissmiss: CircleButton!
    @IBAction func dismiss(_ sender: Any) {
        navigationController?.popViewController(animated: true
        )
    }
    @IBOutlet weak var signUp: UIButton!
    
    @IBAction func signUpClick(_ sender: Any) {
        if userName.text != "" && pass.text != ""{
            AuthProvider.Instance.signUP(withEmail: userName.text!, password: pass.text!, loginHandler: { (message) in
                
                if message != nil  {
                    self.alertTheUser(title: "Problem With Creating User", message: message!)
                }
                else{
                    
                    let refreshAlert = UIAlertController(title: "You Register Successfully!", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)

                    print("Creating User Is completed")
                }
            })
        }
    }
    private func alertTheUser(title : String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction (title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
