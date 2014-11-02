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
    
    var refreshControl:UIRefreshControl!
    
    @IBOutlet var newsFeedTable: UITableView!
    @IBOutlet var profileImage: FBProfilePictureView!
    @IBOutlet var checkedInBar: UILabel!
    
    @IBOutlet var newsButton: UIButton!
    @IBOutlet var friendsButton: UIButton!
    
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
            return newsFeedItems.count
        }else {
            return friendsItems.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var customCell:UserProfileCell = newsFeedTable.dequeueReusableCellWithIdentifier("barProfileCell", forIndexPath: indexPath) as UserProfileCell
        
        if !switchTab {
            customCell.userInteractionEnabled = false;
            //hide unused elements
            customCell.atLabel.hidden = true
            customCell.friendLocation.hidden = true
            
            customCell.messageText.hidden = false
            customCell.barLocation.hidden = false
            
            var newsFeedRow:NSDictionary = newsFeedItems[indexPath.row]
            
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
            customCell.barLocation.text = getPostTimeAndLocation(timeElement, barLocation:barLocation!)
        }
        else {
            customCell.userInteractionEnabled = true;
            //hide unused cells
            //configure specials cell
            customCell.messageText.hidden = true
            customCell.barLocation.hidden = true
            
            customCell.atLabel.hidden = false
            customCell.friendLocation.hidden = false
            
            
            var friendRow:NSDictionary = friendsItems[indexPath.row]
            
            //profile pic of user based on user id
            var friendUserID = friendRow["friend"] as? String
            var friend:NSDictionary = getData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.users/findByUsername/\(friendUserID!)").firstObject as NSDictionary
            
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
            //get specials data here
        }
        
        return customCell
    }
    
    func getPostTimeAndLocation(timeElement:String, barLocation:String) -> String {
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        var timeArray:[String] = timeElement.componentsSeparatedByString("T")
        var time = dateFormatter.dateFromString(timeArray[1])
        
        dateFormatter.dateFormat = "h:mm a"
        var timePosted = dateFormatter.stringFromDate(time!)
        
        return "at \(barLocation) around \(timePosted)"
    }
    
    func parseNewsFeed (jsonResult: NSArray) -> () {
        
        if (jsonResult.count == 0) {
            
            //show error pop up
            var alert = UIAlertController(title: "Oops!", message: "We couldn't find any news feed data for this user.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
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
            self.newsFeedTable.reloadData()
        }
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
        
        if (jsonResult.count == 0) {
            //handle json error here
//            var alert = UIAlertController(title: "Oops!", message: "We had trouble fetching your friends.", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            
            //do this on main application thread
            
            for item in jsonResult {
                
                //need to make sure that we are only appending new items--
                //would it be worth it??
                var dict:NSDictionary = item as NSDictionary
                self.friendsItems.append(dict)
            }
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
        
        if (result.count == 0) {
            
            //show error pop up
            var alert = UIAlertController(title: "Oops!", message: "We couldn't find any data for this user.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        else {
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
    @IBAction func newsClicked(sender: AnyObject) {
        
        newsLabel.hidden = false;
        friendsLabel.hidden = true;
        switchTab = false
        newsFeedTable.reloadData()
    }
    @IBAction func specialsClicked(sender: AnyObject) {
        
        newsLabel.hidden = true;
        friendsLabel.hidden = false;
        switchTab = true
        newsFeedTable.reloadData()
    }
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func checkOutClicked(sender: AnyObject) {
        
        //check out
        var checkedIn = userInfo["checkedInBar"] as? Int
        var id = userInfo["id"] as? Int
//        var barID = barInfo["id"] as? Int
        var params:Dictionary<String, AnyObject>
        var admin = userInfo["admin"] as? Int
        if admin == nil {
            admin = 0
        }
        var name = userInfo["name"] as String
        var username = userInfo["username"] as String
        
        params = ["admin":admin!,"id":id!, "checkedInBar":100, "name":name, "username":username]
        
        sendData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.users/\(id!)", params, "PUT")
        
        checkOutButton.hidden = true
        checkedInBar.hidden = true
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell: UserProfileCell = tableView.cellForRowAtIndexPath(indexPath) as UserProfileCell
        name = cell.userName.text!;
        self.viewDidLoad()
        newsButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        refresh()
    }
    
    //    // MARK: - Navigation
    //
    //    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    //        // Get the new view controller using segue.destinationViewController.
    //        // Pass the selected object to the new view controller.
    //    }
    
    func setUpScreen () {
        var userID = userInfo["username"] as String
        println(userID)
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        let width:CGFloat = 3.0
        profileImage.layer.borderWidth = width
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        profileImage.profileID = userID
        
        //set as delegate
        newsFeedTable.delegate = self;
        newsFeedTable.dataSource = self;
        newsFeedTable.layer.cornerRadius = 10;
        
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
        
        var barID: Int = userInfo["checkedInBar"] as Int
        var bar: NSArray = getData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.bars/\(barID)")
        
        var barDict: NSDictionary = NSDictionary()
        
        if bar.count != 0 {
            var barDict: NSDictionary = bar.firstObject as NSDictionary
        }
        var barLocation = barDict["name"] as? String
        
        if barLocation != nil {
            checkedInBar.text = "Currently at \(barLocation)";
        } else {
            checkedInBar.hidden = true
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
    
    
}
