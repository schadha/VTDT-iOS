//
//  FriendRequestViewController.swift
//  VTDT
//
//  Copyright (c) 2014 Sanchit Chadha and Ragan Walker. All rights reserved.
//

import UIKit

class FriendRequestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var searchBar: UISearchBar!
    
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
        
        if currentFriendsArray.count > 0 {
                        
            for dict in currentFriendsArray {
                let friendDict = dict as! NSDictionary
                let friendID = friendDict["friend"] as! String
                let user = getData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.users/findByUsername/\(friendID)")[0] as! NSDictionary
                currentFriendNames += [user["name"] as! String]
            }
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "popToRoot:")
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
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
        
        let cell:UITableViewCell = requestTableView.dequeueReusableCellWithIdentifier("friendRequestCell", forIndexPath: indexPath) as UITableViewCell
        
        let requestName:String = filteredFriends[indexPath.row]["name"] as! String
        
        cell.textLabel?.text = requestName
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var params:Dictionary<String, AnyObject>
        let username:String = self.filteredFriends[indexPath.row]["username"] as! String
        params = ["user":self.myUserID, "friend":username]
        let friendName = filteredFriends[indexPath.row]["name"] as! String
        let alert = UIAlertController(title: "Send friend request?", message: "Are you sure you would like to add \(friendName) as a friend?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) in
            
          sendData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.friends", params: params, type: "POST")
            self.searchBar.text = ""
            self.filteredFriends = [NSDictionary]()
            self.requestTableView.reloadData()
        
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

    }

    func searchBar(searchBar: UISearchBar,
        textDidChange searchText: String)
    {
        
        self.filteredFriends = [NSDictionary]()
        //fast enumerations
        for userDict in unfilteredFriends {
            
            let userInfo = userDict as! NSDictionary
            let friendName:String = userInfo["name"] as! String
            
            if friendName.lowercaseString.rangeOfString(searchText) != nil && !currentFriendNames.contains(friendName) {
                self.filteredFriends += [userInfo]
                
            }
            
        }
        
        requestTableView.reloadData()
                
    }
    
}
