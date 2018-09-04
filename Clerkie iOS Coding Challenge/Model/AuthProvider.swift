//
//  AuthProvider.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 8/31/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import Firebase
import GoogleSignIn
import FirebaseAuth


typealias LoginHandler = (_ msg: String?) -> Void

struct LoginErrorCode{
    static let WRONG_PASSWORD = "Wrong Password"
    static let INVALID_EMAIL = "Invalid Email Address"
    static let USER_NOT_FOUND = "User not Found, Please Register"
    static let EMAIL_ALREADY_IN_USE = "Email Already In Use, Please Use Another Email"
    static let WEAK_PASS = "Password Should be At Least 6 Character Long"
    static let PROBLEM_CONECTING = "Problem Connecting to Database Please Try Later"
}

class AuthProvider {
    private static let _instance = AuthProvider();
    private init(){}
    static var Instance : AuthProvider{
        return _instance
    }
    var username = ""
    
    func userID ()->String{
        return (Auth.auth().currentUser?.uid)!
    }
    
    func logIn(withEmail : String, password : String, loginHandler : LoginHandler?){
        Auth.auth().signIn(withEmail: withEmail   , password: password, completion : {(user, error) in
            if error != nil {
                self.handleErrors(err : error! as NSError, loginHandler : loginHandler)
            }
            else{
                loginHandler?(nil)
            }
        });
    }
    
    func signUP(withEmail : String, password : String, loginHandler : LoginHandler?){
        Auth.auth().createUser(withEmail: withEmail  , password: password, completion :{(user, error) in
            if error != nil {
                self.handleErrors(err : error! as NSError, loginHandler : loginHandler)
            }
            else{
                // Store User
                let photoURL = Auth.auth().currentUser?.photoURL

                DBProvider.Instance.saveUser(withID: self.userID(), email: withEmail, password: password, image:  "https://lh3.googleusercontent.com/-tUQB3Dsk-CA/AAAAAAAAAAI/AAAAAAAAAAA/APUIFaPgyTfT06HN4e-r6WbWlnfFwYc1PQ/s96-c/photo.jpg"
                )
                
                // LogIn
                if self.userID() != nil{
                    self.logIn(withEmail: withEmail, password: password, loginHandler: loginHandler)
                }
            }
            
        })
    }
    
    func logOut() -> Bool{
        if Auth.auth().currentUser != nil{
            do{
                try Auth.auth().signOut()
                GIDSignIn.sharedInstance().signOut()
                return true
            }catch{
                return false
            }
        }
        return true
        
    }
    
    
    private func handleErrors(err : NSError, loginHandler : LoginHandler?){
        if let errcode = AuthErrorCode(rawValue: err.code){
            switch errcode{
            case .wrongPassword :
                loginHandler?(LoginErrorCode.WRONG_PASSWORD)
                break
            case .invalidEmail :
                loginHandler?(LoginErrorCode.INVALID_EMAIL)
                break
            case .userNotFound :
                loginHandler?(LoginErrorCode.USER_NOT_FOUND)
                break
            case .emailAlreadyInUse :
                loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE)
                break
            case .weakPassword :
                loginHandler?(LoginErrorCode.WEAK_PASS)
                break
            default :
                loginHandler?(LoginErrorCode.PROBLEM_CONECTING)
                break
            }
        }
    }
}
