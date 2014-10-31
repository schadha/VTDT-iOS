//
//  FriendsViewController.swift
//  VTDT
//
//  Created by Sanchit Chadha on 10/23/14.
//  Copyright (c) 2014 Sanchit Chadha. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var friendsTableview: UITableView!
    
    var refreshControl:UIRefreshControl!
    
    var newsFeedItems = [NSDictionary]()
    
    var user: FBGraphUser!
    
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
        
        fetchOnlineFriends(self.user.objectID)

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
            NSFontAttributeName: UIFont(name: "GillSans-Bold", size: 25)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict;
    }
    
    //MARK: -Tableview methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return newsFeedItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var customCell:FriendTableViewCell = friendsTableview.dequeueReusableCellWithIdentifier("friendFeedCell", forIndexPath: indexPath) as FriendTableViewCell
        
        var newsFeedRow:NSDictionary = newsFeedItems[indexPath.row]
        
        
        //name of user where userid --> newsFeedRow["user"]
        //use the userID to do a fetch to the user db table for first name, last name, profile picture
//        var userID = user
//        customCell.userName.text = userID.first_name + " " + userID.last_name
        
//        customCell.messageText.text = newsFeedRow["message"] as? String
        //        customCell.messageText.text = "hello this is a very long message about what i was doing at sharkey's last night.  it must be less than 140 characters or else it wont post."
        
        //profile pic of user based on user id
        var friendUserID = newsFeedRow["friend"] as? String
        var friend:NSDictionary = RestfulFunctions.getData("http://localhost:8080/VTDT/webresources/com.group2.vtdt.users/findByUsername/",param: friendUserID!).firstObject as NSDictionary
        
        customCell.userProfPic.profileID = friend["username"] as? String
        customCell.userProfPic.layer.cornerRadius = customCell.userProfPic.frame.size.width / 2;
        customCell.userProfPic.clipsToBounds = true;
        
        customCell.userName.text = friend["name"] as? String;
        var barID: Int = friend["checkedInBar"] as Int
        var bar: NSDictionary = RestfulFunctions.getData("http://localhost:8080/VTDT/webresources/com.group2.vtdt.bars/", param: barID).firstObject as NSDictionary
        var barLocation = bar["name"] as? String
        customCell.barLocation.text = barLocation
        
        return customCell
    }
    
    func refreshInvoked() {
        
        refresh(viaPullToRefresh: true)
    }
    
    func refresh(viaPullToRefresh: Bool = false) {
        
        //reset newsfeeditems
        newsFeedItems = [NSDictionary]()
        //reload news feed data
        fetchOnlineFriends(self.user.objectID)
        
        if (viaPullToRefresh) {
            self.refreshControl?.endRefreshing()
        }
    }
    
    func fetchOnlineFriends (userID: String) -> () {
        var local = "http://localhost:8080/VTDT/webresources/com.group2.vtdt.friends/findOnline/"
        var jupiter = "http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.friends/findOnline/"
        
        var jsonResult: NSArray = RestfulFunctions.getData(local, param: userID)
        
        if (jsonResult.count == 0) {
            //handle json error here
            print ("error parsing json file \n")
        }
        else {
            
            for item in jsonResult {
                    var dict:NSDictionary = item as NSDictionary
                    self.newsFeedItems += [dict]
            }
            
            //populate tableview here with newFeeditems that get set asynchroniously above ^^^
            //will not populate until all news feed items have been fetched.
            //tableview methods will be called initially (when screen is loaded) but since method
            //is asynchronious, global newFeedItems array will still be empty
            self.friendsTableview.reloadData()
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

}
