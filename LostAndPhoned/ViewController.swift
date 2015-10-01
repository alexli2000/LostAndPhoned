//
//  ViewController.swift
//  LostAndPhoned
//
//  Created by Alexander Li on 2015-09-26.
//  Copyright © 2015 Alexander Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            let homeViewController = HomeViewController()
            self.presentViewController(homeViewController, animated: true, completion: nil)
        } else {
            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissTextFields"))
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()

        }
        
        return true
    }
    
    func dismissTextFields() {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    @IBAction func loginButtonTapped(sender: AnyObject) {
        dismissTextFields()
        self.view.userInteractionEnabled = false

        if loginTextField.text?.utf16.count == 5 && passwordTextField.text?.utf16.count == 5 {
            PFUser.logInWithUsernameInBackground(loginTextField.text!, password: passwordTextField.text!, block: { (user, error) -> Void in
                if error == nil && user != nil {
                    let homeViewController = HomeViewController()
                    PFInstallation.currentInstallation().channels = ["user\(PFUser.currentUser()!.username!)"]
                    self.navigationController?.pushViewController(homeViewController, animated: true)
                } else {
                    print("There was an error logging this phone in")
                }
                self.view.userInteractionEnabled = true
            })
        }
    }
    
    
    @IBAction func signupButtonTapped(sender: AnyObject) {
        dismissTextFields()
        self.view.userInteractionEnabled = false
        if loginTextField.text?.utf16.count == 5 && passwordTextField.text?.utf16.count == 5 {
            let newUser = PFUser()
            newUser.username = loginTextField.text!
            newUser.password = loginTextField.text!
            newUser.signUpInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil && success == true {
                    let homeViewController = HomeViewController()
                    self.presentViewController(homeViewController, animated: true, completion: nil)
                        PFInstallation.currentInstallation().channels = ["user\(PFUser.currentUser()!.username!)"]
                    PFInstallation.currentInstallation().saveInBackground()
                } else {
                    print("There was an error signing this phone up")
                }
                self.view.userInteractionEnabled = true
            })
        }
        
    }
}

