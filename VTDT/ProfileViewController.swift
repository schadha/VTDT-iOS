//
//  ProfileViewController.swift
//  VTDT
//
//  Created by Ragan Walker on 10/21/14.
//  Copyright (c) 2014 Sanchit Chadha. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var name: String = ""
    var user: FBGraphUser!
    
    var refreshControl:UIRefreshControl!
    
    @IBOutlet var newsFeedTable: UITableView!
    @IBOutlet var profileImage: FBProfilePictureView!
    @IBOutlet var checkedInBar: UILabel!
    @IBOutlet var atLabel: UILabel!
    
    @IBOutlet var newsButton: UIButton!
    @IBOutlet var friendsButton: UIButton!
    
    @IBOutlet var friendButton: UIButton!
    @IBOutlet var newsLabel: UILabel!
    @IBOutlet var friendsLabel: UILabel!
    
    @IBOutlet var checkOutButton: UIButton!
    var switchTab = false
    
    var userInfo = NSDictionary()
    var newsFeedItems = [NSDictionary]()
    var friendsItems = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserInfo()
        
        setUpScreen()
        
        startFetchNews()
        
        startFetchFriends()
    }
    
    override func viewDidAppear(animated: Bool) {
        newsFeedItems = [NSDictionary]()
        startFetchNews()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if !switchTab {
            if newsFeedItems.count == 0 {
                return 1;
            } else {
                return newsFeedItems.count
            }
        }else {
            if friendsItems.count == 0 {
                return 1;
            } else {
                return friendsItems.count
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var customCell:UserProfileCell = newsFeedTable.dequeueReusableCellWithIdentifier("barProfileCell", forIndexPath: indexPath) as UserProfileCell
        
        if !switchTab {
            customCell.userInteractionEnabled = false;
            //hide unused elements
            customCell.atLabel.hidden = true
            customCell.friendLocation.hidden = true
            
            customCell.userProfPic.hidden = false
            customCell.messageText.hidden = false
            customCell.barLocation.hidden = false
            var newsFeedRow:NSDictionary = NSDictionary()
            
            if newsFeedItems.count != 0 {
                newsFeedRow = newsFeedItems[indexPath.row]
            } else {
                customCell.userName.text = "No News Feed Items"
                customCell.userProfPic.hidden = true
                customCell.messageText.hidden = true
                customCell.barLocation.hidden = true
                return customCell
            }
            
            customCell.messageText.text = newsFeedRow["message"] as? String
            
            customCell.userName.text = userInfo["name"] as? String
            
            //profile pic of user based on user id
            customCell.userProfPic.profileID = newsFeedRow["username"] as? String
            customCell.userProfPic.layer.cornerRadius = customCell.userProfPic.frame.size.width / 2;
            customCell.userProfPic.clipsToBounds = true;
            
            var barID: Int = newsFeedRow["bar"] as Int
            var bar: NSDictionary = getData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.bars/\(barID)").firstObject as NSDictionary
            var barLocation = bar["name"] as? String
            
            var timeElement = newsFeedRow["timePosted"] as String
            var postTime = getPostTimeAndLocation(timeElement, barLocation!)
            customCell.barLocation.text = "\(postTime) \(isToday(timeElement))"
        }
        else {
            
            //hide unused cells
            customCell.messageText.hidden = true
            customCell.barLocation.hidden = true
            
            customCell.atLabel.hidden = false
            customCell.friendLocation.hidden = false
            customCell.userProfPic.hidden = false
            
            var friendRow:NSDictionary = NSDictionary()
            
            if friendsItems.count != 0 {
                friendRow = friendsItems[indexPath.row]
            } else {
                customCell.userName.text = "No Friends"
                customCell.userProfPic.hidden = true
                customCell.atLabel.hidden = true
                customCell.friendLocation.hidden = true
                customCell.userInteractionEnabled = false;
                return customCell
            }
            
            
            //profile pic of user based on user id
            var friendUserID = friendRow["friend"] as? String
            var friend:NSDictionary = getData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.users/findByUsername/\(friendUserID!)").firstObject as NSDictionary
            
            if user.name == userInfo["name"] as String || user.name == friend["name"] as String {
                
                customCell.userInteractionEnabled = true;
            }
            else {
                customCell.userInteractionEnabled = false;
            }
            
            customCell.userProfPic.profileID = friend["username"] as? String
            customCell.userProfPic.layer.cornerRadius = customCell.userProfPic.frame.size.width / 2;
            customCell.userProfPic.clipsToBounds = true;
            
            customCell.userName.text = friend["name"] as? String;
            
            var barID: Int = friend["checkedInBar"] as Int
            var bar: [NSDictionary] = getData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.bars/\(barID)") as [NSDictionary]
            
            var barLocation = ""
            if (bar.count != 0) {
                barLocation = (bar[0] as NSDictionary)["name"] as String
            }
            
            if barLocation != "" {
                customCell.friendLocation.text = barLocation
            } else {
                customCell.friendLocation.text = "Home"
            }
        }
        
        return customCell
    }
    
    func parseNewsFeed (jsonResult: NSArray) -> () {
        
        var x = 0
        for item in jsonResult {
            
            if x < 25 {
                var dict:NSDictionary = item as NSDictionary
                self.newsFeedItems += [dict]
            }
            else {
                break
            }
            x++
        }
        
        //populate tableview here with newFeeditems that get set asynchroniously above ^^^
        //will not populate until all news feed items have been fetched.
        //tableview methods will be called initially (when screen is loaded) but since method
        //is asynchronious, global newFeedItems array will still be empty
        self.newsFeedTable.reloadData()
    }
    
    func startFetchNews () {
        var userID =  userInfo["username"] as? String
        var jupiter:String = "http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.newsfeed/findByUsername/\(userID!)"
        
        let result = getData(jupiter)
        self.parseNewsFeed(result)
    }
    
    func startFetchFriends(){
        var userID =  userInfo["username"] as? String
        var jupiter:String = "http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.friends/findByUser/\(userID!)"
        
        let result = getData(jupiter)
        self.parseFriends(result)
    }
    
    func parseFriends(jsonResult:NSArray) {
        for item in jsonResult {
            
            //need to make sure that we are only appending new items--
            //would it be worth it??
            var dict:NSDictionary = item as NSDictionary
            self.friendsItems.append(dict)
        }
        //populate tableview here with newFeeditems that get set asynchroniously above ^^^
        //will not populate until all news feed items have been fetched.
        //tableview methods will be called initially (when screen is loaded) but since method
        //is asynchronious, global newFeedItems array will still be empty
        self.newsFeedTable.reloadData()
        
    }
    
    func fetchUserInfo () {
        var jupiter:String = "http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.users/findByName/\(name)"
        let result: NSArray = getData(jupiter) as NSArray
        
        if (result.count != 0) {
            self.userInfo = result[0] as NSDictionary
        }
    }
    
    func refreshInvoked() {
        refresh(viaPullToRefresh: true)
    }
    
    func refresh(viaPullToRefresh: Bool = false) {
        
        //reset newsfeeditems
        newsFeedItems = [NSDictionary]()
        friendsItems = [NSDictionary]()
        //reload news feed data
        startFetchNews()
        startFetchFriends()
        
        if (viaPullToRefresh) {
            self.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func friendButtonClicked(sender: AnyObject) {
        
        performSegueWithIdentifier("requestView", sender: self)
    }
    
    @IBAction func newsClicked(sender: AnyObject) {
        
        newsLabel.hidden = false;
        friendsLabel.hidden = true;
        switchTab = false
        self.newsFeedTable.reloadData()
    }
    @IBAction func friendsClicked(sender: AnyObject) {
        
        newsLabel.hidden = true;
        friendsLabel.hidden = false;
        switchTab = true
        self.newsFeedTable.reloadData()
    }
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func checkOutClicked(sender: AnyObject) {
        
        //check out
        var checkedIn = userInfo["checkedInBar"] as? Int
        var id = userInfo["id"] as? Int
        
        var params:Dictionary<String, AnyObject>
        var barParams:Dictionary<String, AnyObject>
        var admin = userInfo["admin"] as? Int
        var name = userInfo["name"] as? String
        var username = userInfo["username"] as? String
        
        checkOutButton.setTitle("CHECK OUT", forState: UIControlState.Normal)
        
        var barID: Int = userInfo["checkedInBar"] as Int
        var barInfo: NSDictionary = getData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.bars/\(barID)")[0] as NSDictionary
        
        barParams = ["address":barInfo["address"] as String, "id":checkedIn!, "latitude":barInfo["latitude"] as Double, "longitude":barInfo["longitude"] as Double, "name":barInfo["name"] as String, "phoneNumber":barInfo["phoneNumber"] as String, "website":barInfo["website"] as String]
        
        sendData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.bars/\(checkedIn!)", barParams, "PUT")
        
        params = ["admin":admin!,"id":id!, "checkedInBar":100, "name":name!, "username":username!]
        
        sendData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.users/\(id!)", params, "PUT")
        
        checkOutButton.hidden = true
        checkedInBar.hidden = true
        atLabel.hidden = true
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell: UserProfileCell = tableView.cellForRowAtIndexPath(indexPath) as UserProfileCell
        name = cell.userName.text!;
        self.viewDidLoad()
        newsButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        
        refresh()
    }
    
    func setUpScreen () {
        var userID = userInfo["username"] as String
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        let width:CGFloat = 3.0
        profileImage.layer.borderWidth = width
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        profileImage.profileID = userID
        
        //set as delegate
        newsFeedTable.delegate = self;
        newsFeedTable.dataSource = self;
        newsFeedTable.layer.cornerRadius = 10
        
        friendButton.layer.cornerRadius = 10
        
        if user.name != userInfo["name"] as? String {
            friendButton.hidden = true;
        } else {
            friendButton.hidden = false;
        }
        
        
        var tableViewController = UITableViewController()
        tableViewController.tableView = newsFeedTable
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshInvoked", forControlEvents: UIControlEvents.ValueChanged)
        tableViewController.refreshControl = self.refreshControl
        
        //default table view settings
        newsLabel.hidden = false;
        friendsLabel.hidden = true;
        newsButton.layer.cornerRadius = 10;
        friendsButton.layer.cornerRadius = 10;
        checkOutButton.layer.cornerRadius = 10;
        
        var barID: Int = userInfo["checkedInBar"] as Int
        var bar: NSArray = getData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.bars/\(barID)")
        
        var barDict: NSDictionary = NSDictionary()
        
        if bar.count != 0 {
            barDict = bar.firstObject as NSDictionary
        }
        var barLocation = barDict["name"] as? String
        
        if barLocation != nil && user.name == userInfo["name"] as? String {
            checkedInBar.text = "\(barLocation!)";
        } else {
            checkedInBar.hidden = true
            atLabel.hidden = true
            checkOutButton.hidden = true
        }
        
        self.checkedInBar.layer.cornerRadius = 10
        
        self.title = userInfo["name"] as? String;
        
        self.automaticallyAdjustsScrollViewInsets = false;
        
        self.navigationController?.navigationBarHidden = false;
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "popToRoot:")
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "GillSans-Bold", size: 25)!]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        if (segue.identifier == "requestView") {
            
            var requestPage: FriendRequestViewController = segue.destinationViewController  as FriendRequestViewController
            requestPage.myUserID = user.objectID
        }
    }

    
    
}
