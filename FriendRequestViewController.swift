//
//  FriendRequestViewController.swift
//  VTDT
//
//  Created by Ragan Walker on 11/3/14.
//  Copyright (c) 2014 Sanchit Chadha. All rights reserved.
//

import UIKit

class FriendRequestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var filteredFriends:[String] = [String]()
    
    var unfilteredFriends:NSArray = NSArray()
    
    @IBOutlet var requestTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestTableView.delegate = self
        requestTableView.dataSource = self
        
        unfilteredFriends = getData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.users")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    //MARK: -Tableview methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return filteredFriends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = requestTableView.dequeueReusableCellWithIdentifier("friendRequestCell", forIndexPath: indexPath) as UITableViewCell
        
        var requestName:String = filteredFriends[indexPath.row] as String
        
        cell.textLabel.text = requestName
        
        return cell
    }

    func searchBar(searchBar: UISearchBar,
        textDidChange searchText: String)
    {
        
        filteredFriends = [String]()
        //fast enumerations
        for userDict in unfilteredFriends {
            
            var friendName:String = userDict["name"] as String
            
            if friendName.lowercaseString.rangeOfString(searchText) != nil {
                filteredFriends += [friendName]
                
            }
            
        }
        
        requestTableView.reloadData()
                
    }
    
}
