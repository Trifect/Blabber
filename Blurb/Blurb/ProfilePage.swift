//
//  ProfilePage.swift
//  Blurb
//
//  Created by Kevin Nguyen on 5/12/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

import UIKit

class ProfilePage: UIViewController {
    
    @IBOutlet weak var profilePageNavBar: UINavigationBar!

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var bioTextField: UITextField!
    
    @IBAction func editBioAction(sender: AnyObject) {
        if BASE_REF.authData != nil {
            let userRef = BASE_REF.childByAppendingPath("users").childByAppendingPath(BASE_REF.authData.uid)
            if bioTextField.text != "" {
                userRef.updateChildValues(["bio": bioTextField.text!])
            }
            print(userRef)
        } else {
            print("no user signed in")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        profilePageNavBar.topItem!.title = "Profile"
        
        if BASE_REF.authData != nil {
            let userRef = BASE_REF.childByAppendingPath("users").childByAppendingPath(BASE_REF.authData.uid)
            print(userRef)
            userRef.observeEventType(.Value, withBlock: { snapshot in
                print(snapshot.value)
                self.usernameLabel.text = (snapshot.value.objectForKey("username") as! String)
                self.bioLabel.text = (snapshot.value.objectForKey("bio") as! String)
                }, withCancelBlock: { error in
                    print(error.description)
            })
        } else {
            print("no user signed in")
        }
    
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
