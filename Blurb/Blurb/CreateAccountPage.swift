//
//  CreateAccountPage.swift
//  Blurb
//
//  Created by Kevin Nguyen on 5/25/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountPage: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func signUpButtonAction(sender: AnyObject) {
        BASE_REF.createUser(emailField.text!, password: passwordField.text!, withValueCompletionBlock: { (error, result) in
            if error == nil {
                let uid = result["uid"] as! String
                let user = ["username" : self.usernameField.text!, "bio" : ""]
                BASE_REF.childByAppendingPath("users/\(uid)").setValue(user)
                print("Successfully created a user with uid: \(uid)")
            } else {
                print("ERROR: Sign up error")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomePage.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

