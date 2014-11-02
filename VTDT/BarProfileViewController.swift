//
//  BarsViewController.swift
//  VTDT
//
//  Created by Ragan Walker on 10/23/14.
//  Copyright (c) 2014 Sanchit Chadha. All rights reserved.
//

import UIKit

class BarProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user: FBGraphUser!
    
    var refreshControl:UIRefreshControl!
    
    @IBOutlet var newsFeedTable: UITableView!
    @IBOutlet var barImage: UIImageView!
    
    @IBOutlet var newsButton: UIButton!
    @IBOutlet var specialsButton: UIButton!
    
    @IBOutlet var specialsLabel: UILabel!
    @IBOutlet var newsLabel: UILabel!
    
    @IBOutlet var checkInButton: UIButton!
    @IBOutlet var postButton: UIButton!
    @IBOutlet var barAddress: UILabel!
    @IBOutlet var barWebsite: UILabel!
    @IBOutlet var barPhone: UILabel!
    
    var switchTab = false
    
    var newsFeedItems = [NSDictionary]()
    var specialItems = [NSDictionary]()
    var barInfo = NSDictionary()
    var userInfo = NSDictionary()
    
    private let queue = dispatch_queue_create("serial-worker", DISPATCH_QUEUE_SERIAL)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInfo = getData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.users/findByUsername/\(user.objectID!)")[0] as NSDictionary
        
        setUpScreen()
        
        startFetchNews()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        newsButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        newsFeedItems = [NSDictionary]()
        startFetchNews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if !switchTab {
            return newsFeedItems.count
        } else {
            return specialItems.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var customCell:BarProfileCell = newsFeedTable.dequeueReusableCellWithIdentifier("barProfileCell", forIndexPath: indexPath) as BarProfileCell
        
        if !switchTab {
            
            //hide unused elements
            customCell.specialName.hidden = true
            customCell.specialDetails.hidden = true
            customCell.specialDuration.hidden = true
            
            customCell.messageText.hidden = false
            customCell.barLocation.hidden = false
            customCell.userName.hidden = false
            customCell.userProfPic.hidden = false
            
            
            var newsFeedRow:NSDictionary = newsFeedItems[indexPath.row]
            
            var userID = newsFeedRow["username"] as? String
            var user:NSDictionary = getData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.users/findByUsername/\(userID!)")[0] as NSDictionary
            
            customCell.userName.text = user["name"] as? String
            
            customCell.messageText.text = newsFeedRow["message"] as? String
            
            //profile pic of user based on user id
            customCell.userProfPic.profileID = userID
            customCell.userProfPic.layer.cornerRadius = customCell.userProfPic.frame.size.width / 2;
            customCell.userProfPic.clipsToBounds = true;
            
            var barLocation = barInfo["name"] as? String
            
            var timeElement = newsFeedRow["timePosted"] as String
            customCell.barLocation.text = getPostTimeAndLocation(timeElement, barLocation:barLocation!)
            
        }
            
        else {
            
            //hide unused cells
            //configure specials cell
            customCell.messageText.hidden = true
            customCell.barLocation.hidden = true
            customCell.userName.hidden = true
            customCell.userProfPic.hidden = true
            
            customCell.specialName.hidden = false
            customCell.specialDetails.hidden = false
            customCell.specialDuration.hidden = false
            
            var specialsRow:NSDictionary = specialItems[indexPath.row]
            
            var price = specialsRow["price"] as Double
            var priceString = NSString(format: "Price:  $%1.2f", price) as String
            
            
            customCell.specialName.text = specialsRow["menuItem"] as? String
            customCell.specialDetails.text = priceString
            var startTime = getTime(specialsRow["startTime"] as String)
            var endTime = getTime(specialsRow["endTime"] as String)
            
            customCell.specialDuration.text = "from \(startTime) to \(endTime) today"
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
    
    func getTime(time:String) -> String {
        var timeArray:[String] = time.componentsSeparatedByString("T")[1].componentsSeparatedByString(":")
        
        let intTime = timeArray[0].toInt()
        if intTime > 12 {
            let newTime:Int = intTime! - 12
            return "\(newTime):\(timeArray[1]) pm"
            
        }
        else {
            return "\(timeArray[0]):\(timeArray[1]) am"
        }
        
    }
    
    func parseNewsFeed (jsonResult: NSArray) -> () {
        
        if (jsonResult.count == 0) {
            
            //show error pop up
            var alert = UIAlertController(title: "Oops!", message: "We couldn't find any news feed data for this bar.", preferredStyle: UIAlertControllerStyle.Alert)
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
    
    func parseSpecials (jsonResult: NSArray) -> () {
        
        if (jsonResult.count == 0) {
            
            //show error pop up
            var alert = UIAlertController(title: "Oops!", message: "We couldn't find any specials data for this bar.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        else {
            
            var dateFormatter:NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "E"
            let today:String = dateFormatter.stringFromDate(NSDate())
            
            for item in jsonResult {
                var dict:NSDictionary = item as NSDictionary
                
                var days: String = dict["days"] as String
                
                if (days.rangeOfString(today) != nil) {
                    self.specialItems += [dict]
                }
                
            }
            
            //populate tableview here with newFeeditems that get set asynchroniously above ^^^
            //will not populate until all news feed items have been fetched.
            //tableview methods will be called initially (when screen is loaded) but since method
            //is asynchronious, global newFeedItems array will still be empty
            self.newsFeedTable.reloadData()
        }
    }
    
    func startFetchNews () {
        
        let barId = barInfo["id"] as Int
        
        var jupiter:String = "http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.newsfeed/findByBar/\(barId)"
        let result = getData(jupiter)
        self.parseNewsFeed(result)
    }
    
    func startFetchSpecials () {
        let barId = barInfo["id"] as Int
        
        var jupiter:String = "http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.specials/findByBar/\(barId)"
        
        //        dispatch_async(queue) {
        let result = getData(jupiter)
        //            dispatch_async(dispatch_get_main_queue()) {
        self.parseSpecials(result)
        //            }
        
        //        }
    }
    
    func refreshInvoked() {
        
        refresh(viaPullToRefresh: true)
    }
    
    func refresh(viaPullToRefresh: Bool = false) {
        
        //reload news feed data
        if !switchTab {
            newsFeedItems = [NSDictionary]()
            startFetchNews()
        } else {
            specialItems = [NSDictionary]()
            startFetchSpecials()
        }
        
        if (viaPullToRefresh) {
            self.refreshControl?.endRefreshing()
        }
    }
    @IBAction func newsClicked(sender: AnyObject) {
        
        newsLabel.hidden = false;
        specialsLabel.hidden = true;
        switchTab = false
        refresh()
    }
    @IBAction func specialsClicked(sender: AnyObject) {
        
        newsLabel.hidden = true;
        specialsLabel.hidden = false;
        switchTab = true
        refresh()
    }
    @IBAction func postClicked(sender: AnyObject) {
        
        performSegueWithIdentifier("postPage", sender: self)
    }
    @IBAction func checkInClicked(sender: AnyObject){
        viewDidLoad()
        var checkedIn = userInfo["checkedInBar"] as? Int
        var id = userInfo["id"] as? Int
        var barID = barInfo["id"] as? Int
        var params:Dictionary<String, AnyObject>
        var admin = userInfo["admin"] as? Int
        if admin == nil {
            admin = 0
        }
        
        if checkedIn == barID {
            params = ["admin":admin!,"id":id!, "checkedInBar":100, "name":user.name, "username":user.objectID]
            checkInButton.setTitle("CHECK IN", forState: UIControlState.Normal)
        } else {
            params = ["admin":admin!,"id":id!, "checkedInBar":barID!, "name":user.name, "username":user.objectID]
            checkInButton.setTitle("CHECK OUT", forState: UIControlState.Normal)
        }
        sendData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.users/\(id!)", params, "PUT")
        
//        if checkInButton.titleLabel!.text == "CHECK IN" {
//            //add the bar to user check in value and check text lable to check out
//            //json post to user table with new check in value
//            checkInButton.setTitle("CHECK OUT", forState: UIControlState.Normal)
//            
//        }
//        else {
//            
//            //remove the bar from user check in value and change text to check in
//            //json post to user table with null check out value
//            checkInButton.setTitle("CHECK IN", forState: UIControlState.Normal)
//        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        var postPage: PostViewController = segue.destinationViewController  as PostViewController
        postPage.barInfo = self.barInfo
        postPage.user = self.user
        
    }
    
    func popToRoot(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setUpScreen () {
        barImage.layer.cornerRadius = barImage.frame.size.width / 2;
        barImage.clipsToBounds = true;
        let width:CGFloat = 3.0
        barImage.layer.borderWidth = width
        barImage.layer.borderColor = UIColor.whiteColor().CGColor
        barImage.image = UIImage(named: (barInfo["name"] as String)+".png")
        
        //set bar labels
        barAddress.text = barInfo["address"] as? String
        
        //check to make sure they exist**
        let web:String = barInfo["website"] as String
        let phone:String = barInfo["phoneNumber"] as String
        
        //make website be a link that loads in a new web browser
        barWebsite.text = "\(web)"
        barPhone.text = "\(phone)"
        
        //set as delegate
        newsFeedTable.delegate = self;
        newsFeedTable.dataSource = self;
        newsFeedTable.layer.cornerRadius = 10;
        
        var checkedIn = userInfo["checkedInBar"] as? Int
        var barID = barInfo["id"] as? Int
        if checkedIn == barID {
            checkInButton.setTitle("CHECK OUT", forState: UIControlState.Normal)
        } else {
            checkInButton.setTitle("CHECK IN", forState: UIControlState.Normal)
        }
        
        checkInButton.layer.cornerRadius = 10;
        postButton.layer.cornerRadius = 10;
        
        var tableViewController = UITableViewController()
        tableViewController.tableView = newsFeedTable
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshInvoked", forControlEvents: UIControlEvents.ValueChanged)
        tableViewController.refreshControl = self.refreshControl
        
        //default table view settings
        newsLabel.hidden = false;
        specialsLabel.hidden = true;
        newsButton.layer.cornerRadius = 10;
        specialsButton.layer.cornerRadius = 10;
        
        
        //set up navigation controller
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "GillSans-Bold", size: 25)!]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict;
        
        self.title = barInfo["name"] as? String
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "popToRoot:")
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    
}
