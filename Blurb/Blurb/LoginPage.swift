//
//  LoginPage.swift
//  Blurb
//
//  Created by Kevin Nguyen on 5/12/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

import UIKit

class LoginPage: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBAction func loginButtonAction(sender: AnyObject) {
        BASE_REF.authUser(emailField.text!, password: passwordField.text!, withCompletionBlock: { (error, authData) in
            if error == nil {
                let uid = authData.uid
                self.performSegueWithIdentifier("loginSegue", sender: nil)
                print("Login successful with uid: \(uid)")
            } else {
                print("ERROR: Unable to sign in user")
            }
        })
        
    }
    
    @IBAction func unwindCreateAccountPage(segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomePage.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
