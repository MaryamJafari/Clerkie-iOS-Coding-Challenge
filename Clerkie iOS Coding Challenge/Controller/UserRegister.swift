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
import PCLBlurEffectAlert

class UserRegister: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var userName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constant().color
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
                    if message == LoginErrorCode.EMAIL_ALREADY_IN_USE || message == LoginErrorCode.INVALID_EMAIL{
                        let animation = CABasicAnimation(keyPath: "position")
                        animation.duration = 0.07
                        animation.repeatCount = 4
                        animation.autoreverses = true
                        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.userName.center.x - 10, y: self.userName.center.y))
                        animation.toValue = NSValue(cgPoint: CGPoint(x: self.self.userName.center.x + 10, y: self.self.userName.center.y))
                        
                        self.userName.layer.add(animation, forKey: "position")
                    }
                    else if message == LoginErrorCode.WRONG_PASSWORD || message == LoginErrorCode.WEAK_PASS{
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
                    
                    
                    let alert = PCLBlurEffectAlert.Controller(title: "Congradulations!", message: "You Register Successfully", effect: UIBlurEffect(style: .extraLight), style: .actionSheet)
                    let alertBtn = PCLBlurEffectAlert.Action(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(alertBtn)
                    alert.configure(cornerRadius:  25)
                    alert.configure(titleColor: Constant().navigationColor)
                    alert.configure(textFieldBorderColor: Constant().color)
                    alert.configure(messageColor: UIColor.gray)
                    alert.configure(buttonHeight: 50)
                    alert.show()
                    
                }
            })
        }
    }
    private func alertTheUser(title : String, message : String){
        
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
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
