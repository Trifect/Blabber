//
//  HomePage.swift
//  Blurb
//
//  Created by Kevin Nguyen on 5/12/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

import UIKit
import CoreLocation

let prof = "Nagoogin"

class HomePage: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var blabTextField: UITextField!
    
    @IBOutlet weak var blabTableView: UITableView!
    
    @IBOutlet weak var homePageNavBar: UINavigationBar!

    @IBOutlet weak var blurbButton: UIButton!
    
    // Sets the length limit of a blab to 40 characters, unfortunately including spaces.
    @IBAction func textFieldAction(sender: AnyObject) {
        let maxLength = 40
        if blabTextField.text?.characters.count > maxLength {
            blabTextField.deleteBackward()
        }
    }
    var blabList = [Blab]()
    
    // This function returns a string for the date given an NSDate date
    func getTimeStamp(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        return dateFormatter.stringFromDate(date)
    }
    
    let refreshControl = UIRefreshControl()
    
    func updateTimeStamp(time: NSDate) -> String {
        let currentTime = NSDate()
        let timeInterval = currentTime.timeIntervalSinceDate(time)
        let timeStamp : String
        if timeInterval < 3600 {
            if Int(timeInterval) < 60 {
                if Int(timeInterval) == 1 {
                    timeStamp = "1 second ago"
                } else {
                    timeStamp = String(Int(timeInterval)) + " seconds ago"
                }
            } else if Int(timeInterval / 60) == 1 {
                timeStamp =  "1 minute ago"
            } else {
                timeStamp = String(Int(timeInterval / 60)) + " minutes ago"
            }
        } else if Int(timeInterval) < 86400 {
            if Int(timeInterval / 3600) == 1 {
                timeStamp = "1 hour ago"
            } else {
                timeStamp = String(Int(timeInterval / 3600)) + " hours ago"
            }
        } else if Int(timeInterval) < 604800 {
            if Int(timeInterval / 86400) == 1 {
                timeStamp = "1 day ago"
            } else {
                timeStamp = String(Int(timeInterval / 86400)) + " days ago"
            }
        } else {
            timeStamp = getTimeStamp(time)
        }
        return timeStamp
    }
    
// Blab button did touch action
    @IBAction func blabButtonAction(sender: AnyObject) {
        if (blabTextField.text != "") {
            // Saves the time of blab submission
            // let profileName = prof
            let ref = BASE_REF.childByAppendingPath("users/\(BASE_REF.authData.uid)")
            ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
                let profileName = snapshot.value.objectForKey("username") as! String
                
                let timeInterval = NSDate().timeIntervalSince1970
                let newBlab = Blab(profileName: profileName, blabString: self.blabTextField.text!, parent: nil, timeInterval: timeInterval)
                
                // Appends a new Blab object to the blabList array
                self.blabList.insert(newBlab, atIndex: 0)
                // userBlabList.insert(newBlab, atIndex: 0)
                
                // Sets the textField back to empty view
                self.blabTextField.text = ""
                
                self.dismissKeyboard()
                
                // Updates the table view with the new added row
                self.blabTableView.reloadData()
                
                // Writes the newBlab to Firebase
                self.writeToFirebase(newBlab)
            })
        }
    }
    
    func writeToFirebase(blab: Blab) {
        // Observe single event, don't keep updating
        BASE_REF.childByAppendingPath("blabs").observeSingleEventOfType(.Value, withBlock: { snapshot in
            let childCount = snapshot.childrenCount
            let newBlab = ["user": String(blab.profileName), "blabString": String(blab.blabString), "timeStamp": Double(blab.timeInterval), "parent": String(blab.parent), "influence": 0]
            BASE_REF.childByAppendingPath("blabs/blab\(childCount)").setValue(newBlab)
            BASE_REF.childByAppendingPath("users/\(BASE_REF.authData.uid)/blabs/blab\(childCount)").setValue(true)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homePageNavBar.topItem!.title = "Home Feed"
        
        blurbButton.layer.cornerRadius = 5
        
        refreshControl.backgroundColor = UIColor.groupTableViewBackgroundColor()
        refreshControl.tintColor = UIColor(red:0.0, green:0.545, blue:0.271, alpha:1.0)
        
        self.refreshControl.addTarget(self, action: #selector(HomePage.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)

        self.blabTableView.addSubview(self.refreshControl)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomePage.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let ref = BASE_REF.childByAppendingPath("blabs")
        ref.observeEventType( .Value, withBlock: { snapshot in
            var newItems = [Blab]()
            for child in snapshot.children {
                // Construct a blab from data
                let user = child.value.objectForKey("user") as! String
                let blabString = child.value.objectForKey("blabString") as! String
                let timeInterval = child.value.objectForKey("timeStamp") as! Double
                let parent = child.value.objectForKey("parent") as? Blab
                let blab = Blab(profileName: user, blabString: blabString, parent: parent, timeInterval: timeInterval)
                newItems.insert(blab, atIndex: 0)
            }
            self.blabList = newItems
            self.blabTableView.reloadData()
        }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Need to add call to function that retrieves newest blabs from database
        
        self.blabTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blabList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let blabbedCell = self.blabTableView.dequeueReusableCellWithIdentifier("bCell", forIndexPath: indexPath) as! blabCell
        
        blabbedCell.usernameLabel.text = blabList[indexPath.row].profileName
        blabbedCell.blabLabel.text = blabList[indexPath.row].blabString
        
        let ref = BASE_REF.childByAppendingPath("users/\(BASE_REF.authData.uid)")
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if self.blabList[indexPath.row].profileName == snapshot.value.objectForKey("username") as! String {
                // If you are the poster, then the text of the blab is in medium weight and app green
                blabbedCell.blabLabel.textColor = UIColor(red:0.0, green:0.545, blue:0.271, alpha:1.0)
                blabbedCell.blabLabel.font = UIFont(name: "AvenirNext-Medium", size: 14.0)
            } else {
                blabbedCell.blabLabel.textColor = UIColor.blackColor()
                blabbedCell.blabLabel.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
            }
        })
        
        // Checks if cell is the first of the user's blabs, then highlight it in green. It's too bad this control flow block has to be separate from the one above because otherwise it won't exhaustively check all the cells.
        
//        if blabList[indexPath.row] == userBlabList[0] {
//            blabbedCell.backgroundColor = UIColor(red: 0.867, green: 0.988, blue: 0.867, alpha: 1.0)
//        } else {
//            blabbedCell.backgroundColor = UIColor.whiteColor()
//        }
        
        blabbedCell.timeStampLabel.text = updateTimeStamp(NSDate(timeIntervalSince1970: blabList[indexPath.row].timeInterval))
        
        return blabbedCell
    }
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.separatorInset = UIEdgeInsetsZero
//        cell.layoutMargins = UIEdgeInsetsZero
//    }
    
}
