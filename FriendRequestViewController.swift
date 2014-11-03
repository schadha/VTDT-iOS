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
    var filteredFriends = [NSDictionary]()
    var unfilteredFriends:NSArray = NSArray()
    var currentFriendsArray:NSArray = NSArray()
    var currentFriendNames = [String]()
    
    @IBOutlet var requestTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestTableView.delegate = self
        requestTableView.dataSource = self
        
        unfilteredFriends = getData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.users")
        currentFriendsArray = getData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.friends/findByUser/\(myUserID)")
        for dict in currentFriendsArray {
            var friendID = dict["friend"] as String
            var user:NSArray = getData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.users/findByUsename/\(friendID)")
//            var friendName:String = user[0][
            currentFriendNames += [user[0]["name"] as String]
        }
        
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var params:Dictionary<String, AnyObject>
        var username:String = self.filteredFriends[indexPath.row]["username"] as String
        params = ["user":self.myUserID, "friend":username]
        var friendName = filteredFriends[indexPath.row]["name"] as String
        var alert = UIAlertController(title: "Send friend request?", message: "Are you sure you would like to add \(friendName) as a friend?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) in sendData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.friends", params, "POST") }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

    }

    func searchBar(searchBar: UISearchBar,
        textDidChange searchText: String)
    {
        
        self.filteredFriends = [NSDictionary]()
        //fast enumerations
        for userDict in unfilteredFriends {
            
            var userInfo = userDict as NSDictionary
            var friendName:String = userInfo["name"] as String
            
            if friendName.lowercaseString.rangeOfString(searchText) != nil && !contains(currentFriendNames, friendName) {
                self.filteredFriends += [userInfo]
                
            }
            
        }
        
        requestTableView.reloadData()
                
    }
    
}
