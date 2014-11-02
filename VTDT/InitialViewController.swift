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
    var dummyarray:NSArray = NSArray()
    
    private let queue = dispatch_queue_create("serial-worker", DISPATCH_QUEUE_SERIAL)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpScreen()
        startFetchNews()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true;
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
        var user:NSDictionary = getData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.users/findByUsername/\(userID!)")[0] as NSDictionary
        
        customCell.userName.text = user["name"] as? String
        
        customCell.messageText.text = newsFeedRow["message"] as? String
        customCell.userProfPic.profileID = newsFeedRow["username"] as? String
        customCell.userProfPic.layer.cornerRadius = customCell.userProfPic.frame.size.width / 2;
        customCell.userProfPic.clipsToBounds = true;
        
        var barID: Int = newsFeedRow["bar"] as Int
        var bar: NSDictionary = getData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.bars/\(barID)").firstObject as NSDictionary
        var barLocation = bar["name"] as? String
        
        var timeElement = newsFeedRow["timePosted"] as String
        customCell.barLocation.text = getPostTimeAndLocation(timeElement, barLocation:barLocation!)

        
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
        startFetchNews()
        
        if (viaPullToRefresh) {
            self.refreshControl?.endRefreshing()
        }
    }
    
    // # RESTFUL CALLS ===========================================================
    
    func parseNewsFeed (jsonResult: NSArray) -> () {
        
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
    
    func startFetchNews () {
        
        var jupiter:String = "http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.newsfeed/sorted"
        
//        dispatch_async(queue) {
            let result = getData(jupiter)
//            dispatch_async(dispatch_get_main_queue()) {
                self.parseNewsFeed(result)
//            }
        
//        }
    }

    
    //get request to get user first and last name based on userid
    
    
    //GET TIME FUNCTION
    
    func getPostTimeAndLocation(timeElement:String, barLocation:String) -> String {
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        var timeArray:[String] = timeElement.componentsSeparatedByString("T")
        var time = dateFormatter.dateFromString(timeArray[1])
        
        dateFormatter.dateFormat = "h:mm a"
        var timePosted = dateFormatter.stringFromDate(time!)
        
        return "at \(barLocation) around \(timePosted)"
    }
    
    func setUpScreen() {
        
        profileName.text = user.first_name + " " + user.last_name
        profileImage.profileID = user.objectID
        println(user.objectID)
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
            profilePage.name = self.user.name
        }
        else if segue.identifier == "whatView" {
            var barsPage: BarsViewController = segue.destinationViewController as BarsViewController
            barsPage.user = self.user
        }
        else if segue.identifier == "whoView" {
            var friendsPage: FriendsViewController = segue.destinationViewController as FriendsViewController
            friendsPage.user = self.user
            
        }
    }

}


