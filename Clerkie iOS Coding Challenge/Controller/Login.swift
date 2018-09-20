//
//  ViewController.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 8/31/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit
import Firebase 
import GoogleSignIn
import FirebaseAuth
import PCLBlurEffectAlert
class Login: UIViewController , UIViewControllerTransitioningDelegate, GIDSignInUIDelegate, GIDSignInDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var signInButton: GIDSignInButton!
    let transition =  Animation()
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var goToRegister: CircleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pass.text = ""
        userName.text = ""
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        signInButton.style = .iconOnly
        signInButton.layer.cornerRadius = 60
        signInButton.layer.shadowColor = Constant().color.cgColor
        signInButton.layer.shadowOpacity = 0.4
        signInButton.layer.shadowRadius = 2.0
        signInButton.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.navigationController?.delegate = self
        userName.delegate = self
        pass.delegate = self
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 23)!]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:Constant().navigationColor]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    
    func userID ()->String{
        return (Auth.auth().currentUser?.uid)!
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        pass.text = ""
        userName.text = ""
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    @IBAction func RegisterNewUser(_ sender: Any) {
        performSegue(withIdentifier: "FromLoginToRegister", sender: "")
    }
    // test
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode =  .present
        transition.startingPoint = goToRegister.center
        transition.color = goToRegister.backgroundColor!
        
        
        return transition
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode =  .present
        transition.startingPoint = goToRegister.center
        transition.color = goToRegister.backgroundColor!
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode =  .dissmiss
        transition.startingPoint = goToRegister.center
        transition.color = goToRegister.backgroundColor!
        return transition
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromLoginToRegister"{
            let registerController = segue.destination as! UserRegister
            registerController.transitioningDelegate = self
            registerController.modalPresentationStyle = .custom
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        userName.text = ""
        pass.text = ""
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let user = Auth.auth().currentUser
            print(user?.email)
            print(user?.uid)
            let photoURL = user?.photoURL
            DBProvider.Instance.saveUser(withID: user!.uid, email : (user?.email)!, image : String(describing: photoURL!) )
            self.performSegue(withIdentifier: "FromLoginToChatHistory", sender: "")
            
            
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBOutlet weak var login: UIButton!
    @IBAction func logInClick(_ sender: Any) {
        if userName.text != "" && pass.text != ""{
            AuthProvider.Instance.logIn(withEmail: userName.text!, password: pass.text!, loginHandler: {(message) in
                if message != nil {
                    self.alertTheUser(title: "Problem With Authentication", message: message!)
                    
                    if message == LoginErrorCode.INVALID_EMAIL || message == LoginErrorCode.USER_NOT_FOUND {
                        let animation = CABasicAnimation(keyPath: "position")
                        animation.duration = 0.07
                        animation.repeatCount = 4
                        animation.autoreverses = true
                        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.userName.center.x - 10, y: self.userName.center.y))
                        animation.toValue = NSValue(cgPoint: CGPoint(x: self.self.userName.center.x + 10, y: self.self.userName.center.y))
                        
                        self.userName.layer.add(animation, forKey: "position")
                    }
                    else if message == LoginErrorCode.WRONG_PASSWORD{
                        let animation = CABasicAnimation(keyPath: "position")
                        animation.duration = 0.07
                        animation.repeatCount = 4
                        animation.autoreverses = true
                        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.pass.center.x - 10, y: self.pass.center.y))
                        animation.toValue = NSValue(cgPoint: CGPoint(x: self.self.pass.center.x + 10, y: self.self.pass.center.y))
                        
                        self.pass.layer.add(animation, forKey: "position")
                    }
                }
                else{
                    self.userName.text = ""
                    self.pass.text = ""
                    
                    DBProvider.Instance.userExists(userId: self.userID()){(userExist) in
                        
                        if (userExist){
                            
                            self.performSegue(withIdentifier: "FromLoginToChatHistory", sender: self.userName.text)
                            
                        }
                        else {
                            self.alertTheUser(title: "User Does not Exist, Please Register First", message: message!)
                            
                        }
                        
                    }
                    
                    
                }
            })
        }
    }
    private func alertTheUser(title : String, message : String) {
        
        let alert = PCLBlurEffectAlert.Controller(title: title, message: message, effect: UIBlurEffect(style: .extraLight), style: .actionSheet)
        let alertBtn = PCLBlurEffectAlert.Action(title: "OK", style: .cancel, handler: nil)
        alert.addAction(alertBtn)
        alert.configure(cornerRadius:  25)
        alert.configure(titleColor: Constant().navigationColor)
        alert.configure(textFieldBorderColor: Constant().color)
        alert.configure(messageColor: UIColor.gray)
        alert.configure(buttonHeight: 50)
        alert.show() 
        
    }
    
}

