//
//  ProfileViewController.swift
//  VTDT
//
//  Created by Sanchit Chadha on 10/19/14.
//  Copyright (c) 2014 Sanchit Chadha. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var profileImage: FBProfilePictureView!
    @IBOutlet var profileName: UILabel!
    
    @IBOutlet var whoToDoButton: UIButton!
    @IBOutlet var whatToDoButton: UIButton!
    
    @IBOutlet var newsTableview: UITableView!
    
    var refreshControl:UIRefreshControl!
    
    var user: FBGraphUser!
    var newsFeedItems = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpScreen()
        
        fetchNewsFeed()
    }
    
    @IBAction func logout(sender: AnyObject) {
        FBSession.activeSession().closeAndClearTokenInformation()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        var customCell:NewsFeedTableViewCell = newsTableview.dequeueReusableCellWithIdentifier("newsFeedCell", forIndexPath: indexPath) as NewsFeedTableViewCell
        
        var newsFeedRow:NSDictionary = newsFeedItems[indexPath.row]
        
        var userID = newsFeedRow["username"] as? String
        var user:NSDictionary = fetchUser(userID!)
        
        customCell.userName.text = user["name"] as? String
        customCell.messageText.text = newsFeedRow["message"] as? String
        
        customCell.userProfPic.profileID = userID
        customCell.userProfPic.layer.cornerRadius = customCell.userProfPic.frame.size.width / 2;
        customCell.userProfPic.clipsToBounds = true;
        
        var timeElement = newsFeedRow["timePosted"] as String
        customCell.barLocation.text = getPostTime(timeElement)
        
        
        return customCell
    }
    
    
    @IBAction func detailClicked(sender: AnyObject) {
        
        performSegueWithIdentifier("profileView", sender: self)
    }
    @IBAction func whatClicked(sender: AnyObject) {
        
        performSegueWithIdentifier("whatView", sender: self)
    }
    
    @IBAction func whoClicked(sender: AnyObject) {
        
        performSegueWithIdentifier("whoView", sender: self)
    }
    
    func refreshInvoked() {
        
        refresh(viaPullToRefresh: true)
    }
    
    func refresh(viaPullToRefresh: Bool = false) {
        
        //reset newsfeeditems
        newsFeedItems = [NSDictionary]()
        //reload news feed data
        fetchNewsFeed()
        
        if (viaPullToRefresh) {
            self.refreshControl?.endRefreshing()
        }
    }
    // # RESTFUL CALLS ===========================================================
    
    func fetchNewsFeed () -> () {
        var local = "http://localhost:8080/VTDT/webresources/com.group2.vtdt.newsfeed/sorted"
        var jupiter = "http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.newsfeed/sorted"
        
        var jsonResult: NSArray = RestfulFunctions.getData(local)
        
        if (jsonResult.count == 0) {
            //handle json error here
            print ("error parsing json file \n")
        }
        else {
            
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
            self.newsTableview.reloadData()
            
        }
    }
    
    func fetchUser(userID: String) -> NSDictionary {
        var local = "http://localhost:8080/VTDT/webresources/com.group2.vtdt.users/findByUsername/\(userID)"
        var jupiter = "http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.users/findByUsername/\(userID)"
        
        var jsonResult: NSArray = RestfulFunctions.getData(local)
        
        if (jsonResult.count == 0) {
            //handle json error here
            print ("error parsing json file \n")
            return NSDictionary()
        }
        else {
            return jsonResult[0] as NSDictionary;
        }
    }
    
    //GET TIME FUNCTION
    
    func getPostTime(timeElement:String) -> String {
        var timeArray:[String] = timeElement.componentsSeparatedByString("T")[1].componentsSeparatedByString(":")
        
        let intTime = timeArray[0].toInt()
        if intTime > 12 {
            let newTime:Int = intTime! - 12
            return "at Sharkey's around \(newTime):\(timeArray[1]) pm"
            
        }
        else {
            return "at Sharkey's around \(timeArray[0]):\(timeArray[1]) am"
        }
    }
    
    func setUpScreen() {
        
        profileName.text = user.first_name + " " + user.last_name
        profileImage.profileID = user.objectID
        profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
        profileImage.clipsToBounds = true;
        
        let width:CGFloat = 3.0
        profileImage.layer.borderWidth = width
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        
        whatToDoButton.layer.cornerRadius = 10;
        whoToDoButton.layer.cornerRadius = 10;
        
        newsTableview.delegate = self;
        newsTableview.dataSource = self;
        newsTableview.layer.cornerRadius = 10;
        
        //set up refresh controller
        var tableViewController = UITableViewController()
        tableViewController.tableView = newsTableview
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshInvoked", forControlEvents: UIControlEvents.ValueChanged)
        tableViewController.refreshControl = self.refreshControl
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        
        if (segue.identifier == "profileView") {
            var profilePage: ProfileViewController = segue.destinationViewController  as ProfileViewController
            profilePage.user = self.user;
        }
        else if segue.identifier == "whatView" {
            var barsPage: BarsViewController = segue.destinationViewController as BarsViewController
            
            barsPage.user = self.user;
        }
        else if segue.identifier == "whoView" {
            var friendsPage: FriendsViewController = segue.destinationViewController as FriendsViewController
            
        }
        
        
    }
    
}
