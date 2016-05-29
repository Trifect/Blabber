//
//  ExplorePage.swift
//  Blurb
//
//  Created by Kevin Nguyen on 5/12/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

import UIKit

class ExplorePage: UITableViewController {
    
//    let searchController = UISearchController(searchResultsController: nil)
    let ref = BASE_REF.childByAppendingPath("users")
//    var filteredUsers = [AnyObject]()

    @IBOutlet weak var explorePageNavBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        explorePageNavBar.topItem!.title = "Explore"
        
//         Setting up the search bar
//        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false
//        definesPresentationContext = true
//        tableView.tableHeaderView = searchController.searchBar
    }
    
//    func filterUsersForSearchText(searchText: String, scope: String = "All") {
//        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
//            let users = snapshot.children.filter { child in
//                let childString = child.objectForKey("username") as! String
//                return childString.lowercaseString.containsString(searchText.lowercaseString)
//            }
//            self.filteredUsers = users
//        }, withCancelBlock: { error in
//            print(error.description)
//        })
//    }
//    
//    func UISearchResultsUpdating() {
//        func updateSearchResultsForSearchController(searchController: UISearchController) {
//            filterContentForSearchText(searchController.searchBar.text!)
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
