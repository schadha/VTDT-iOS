//
//  FriendRequestViewController.swift
//  VTDT
//
//  Created by Ragan Walker on 11/3/14.
//  Copyright (c) 2014 Sanchit Chadha. All rights reserved.
//

import UIKit

class FriendRequestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myUserID:String = ""
    var filteredFriends:[NSDictionary] = [NSDictionary]()
//    var params:Dictionary<String, AnyObject> = 
    
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
        
        var requestName:String = filteredFriends[indexPath.row]["name"] as String
        
        cell.textLabel.text = requestName
        
        return cell
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        var params:Dictionary<String, AnyObject>
        var username:String = self.filteredFriends[indexPath.row]["username"] as String
        params = ["user":self.myUserID, "friend":username]
        
        var alert = UIAlertController(title: "Send friend request?", message: "Are you sure you would like to send \(filteredFriends[indexPath.row]) a friend request?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) in sendData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.friends", params, "POST") }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

    }

    func searchBar(searchBar: UISearchBar,
        textDidChange searchText: String)
    {
        
        filteredFriends = [NSDictionary]()
        //fast enumerations
        for userDict in unfilteredFriends {
            
            println(userDict)
            var friendName:String = userDict["name"] as String
            
            if friendName.lowercaseString.rangeOfString(searchText) != nil {
//                filteredFriends += [userDict]
                
            }
            
        }
        
        requestTableView.reloadData()
                
    }
    
}
