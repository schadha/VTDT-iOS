//
//  FriendsViewController.swift
//  VTDT
//
//  Copyright (c) 2014 Sanchit Chadha and Ragan Walker. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var friendsTableview: UITableView!
    
    var refreshControl:UIRefreshControl!
    
    var newsFeedItems = [NSDictionary]()
    
    var bars = [NSDictionary]()
    var currBar = NSDictionary()
    
    var friends = [NSDictionary]()
    var currFriend = NSDictionary()
    var user: FBGraphUser!
    
    private let queue = dispatch_queue_create("serial-worker", DISPATCH_QUEUE_SERIAL)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsTableview.delegate = self;
        friendsTableview.dataSource = self;
        friendsTableview.layer.cornerRadius = 10;
        
        
        var tableViewController = UITableViewController()
        tableViewController.tableView = friendsTableview
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshInvoked", forControlEvents: UIControlEvents.ValueChanged)
        tableViewController.refreshControl = self.refreshControl
                
        setupNavBar()
        
        startFetchOnlineFriends(self.user.objectID)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.navigationBarHidden = true;
    }
    
    func setupNavBar() {
        self.automaticallyAdjustsScrollViewInsets = false;
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBarHidden = false;
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "popToRoot:")
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        
        self.title = "Who To Do"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "GillSans-Bold", size: 25)!]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict;
    }
    
    //MARK: -Tableview methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if newsFeedItems.count == 0 {
            return 1;
        } else {
            return newsFeedItems.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var customCell:FriendTableViewCell = friendsTableview.dequeueReusableCellWithIdentifier("friendFeedCell", forIndexPath: indexPath) as FriendTableViewCell
        //                    customCell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
        var newsFeedRow:NSDictionary = NSDictionary()
        
        customCell.userProfPic.hidden = false
        customCell.barLocation.hidden = false
        customCell.atLabel.hidden = false
        customCell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
        
        if newsFeedItems.count != 0 {
            newsFeedRow = newsFeedItems[indexPath.row]
        } else {
            customCell.userName.text = "No Friends Are Checked In"
            customCell.userProfPic.hidden = true
            customCell.barLocation.hidden = true
            customCell.atLabel.hidden = true
            customCell.accessoryType = UITableViewCellAccessoryType.None
            return customCell
        }
        
        //profile pic of user based on user id
        var friendUserID = newsFeedRow["friend"] as? String
        var friend:NSDictionary = getData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.users/findByUsername/\(friendUserID!)").firstObject as NSDictionary
        
        customCell.userProfPic.profileID = friend["username"] as? String
        customCell.userProfPic.layer.cornerRadius = customCell.userProfPic.frame.size.width / 2;
        customCell.userProfPic.clipsToBounds = true;
        
        customCell.userName.text = friend["name"] as? String;
        
        var barID: Int = friend["checkedInBar"] as Int
        var bar: NSArray = getData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.bars/\(barID)")
        
        var barDict: NSDictionary = NSDictionary()
        
        if bar.count != 0 {
            barDict = bar[0] as NSDictionary
        }
        var barLocation = barDict["name"] as? String
        
        if barLocation != nil {
            customCell.barLocation.text = barLocation
        } else {
            customCell.barLocation.text = "No Bar"
        }
        
        friends.append(friend)
        bars.append(barDict)
        
        return customCell
    }
    
    func refreshInvoked() {
        
        refresh(viaPullToRefresh: true)
    }
    
    func refresh(viaPullToRefresh: Bool = false) {
        
        //reset newsfeeditems
        newsFeedItems = [NSDictionary]()
        //reload news feed data
        startFetchOnlineFriends(self.user.objectID)
        
        if (viaPullToRefresh) {
            self.refreshControl?.endRefreshing()
        }
    }
    
    func startFetchOnlineFriends (userID: String){
        
        var jupiter:String = "http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.friends/findOnline/\(userID)"
        
        dispatch_async(queue) {
            let result = getData(jupiter)
            dispatch_async(dispatch_get_main_queue()) {
                self.parseOnlineFriends(result)
            }
            
        }
    }
    
    func parseOnlineFriends(jsonResult:NSArray) {
        //do this on main application thread
        
        for item in jsonResult {
            
            //need to make sure that we are only appending new items--
            //would it be worth it??
            var dict:NSDictionary = item as NSDictionary
            self.newsFeedItems.append(dict)
        }
        
        //populate tableview here with newFeeditems that get set asynchroniously above ^^^
        //will not populate until all news feed items have been fetched.
        //tableview methods will be called initially (when screen is loaded) but since method
        //is asynchronious, global newFeedItems array will still be empty
        self.friendsTableview.reloadData()
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currFriend = friends[indexPath.row]
        performSegueWithIdentifier("profileView", sender: self)
        
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        currBar = bars[indexPath.row]
        if currBar.count != 0 {
            performSegueWithIdentifier("barView", sender: self)
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "profileView" {
            var profilePage: ProfileViewController = segue.destinationViewController  as ProfileViewController
            profilePage.name = currFriend["name"] as String;
            profilePage.user = user;
        }
        else if segue.identifier == "barView" {
            var barPage: BarProfileViewController = segue.destinationViewController  as BarProfileViewController
            barPage.barInfo = currBar
            barPage.user = user
        }
    }
    
}
