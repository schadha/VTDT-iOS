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
    
    //get user json object for check in update
//    var jsonUser = NSDictionary[String]()

    var refreshControl:UIRefreshControl!

    @IBOutlet var newsFeedTable: UITableView!
    @IBOutlet var barImage: UIImageView!
//    @IBOutlet var barName: UILabel!
    
    @IBOutlet var newsButton: UIButton!
    @IBOutlet var specialsButton: UIButton!
    
    @IBOutlet var specialsLabel: UILabel!
    @IBOutlet var newsLabel: UILabel!
    
    @IBOutlet var checkInButton: UIButton!
    @IBOutlet var postButton: UIButton!
    @IBOutlet var barAddress: UILabel!
    @IBOutlet var barWebsite: UILabel!
    
    var switchTab = false
    
    var newsFeedItems = [NSDictionary]();
    var barInfo = NSDictionary();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpScreen()
                
        fetchNewsFeed()
        
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
        return newsFeedItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print ("called cell\n")
        var customCell:BarProfileCell = newsFeedTable.dequeueReusableCellWithIdentifier("barProfileCell", forIndexPath: indexPath) as BarProfileCell
        
        var newsFeedRow:NSDictionary = newsFeedItems[indexPath.row]
        
        
        if !switchTab {
            
            print("switch false\n")
            //name of user where userid --> newsFeedRow["user"]
            //use the userID to do a fetch to the user db table for first name, last name, profile picture
            //          var userID = user
            //        customCell.userName.text = userID.first_name + " " + userID.last_name
        
            customCell.messageText.text = newsFeedRow["message"] as? String
            customCell.messageText.text = "hello this is a very long message about what i was doing at sharkey's last night.  it must be less than 140 characters or else it wont post."
        
            //profile pic of user based on user id
        
            //        customCell.userProfPic.profileID = userID.objectID
            //        customCell.userProfPic.layer.cornerRadius = customCell.userProfPic.frame.size.width / 2;
            //        customCell.userProfPic.clipsToBounds = true;
        
            var timeElement = newsFeedRow["timePosted"] as String
            var timeArray:[String] = timeElement.componentsSeparatedByString("T")[1].componentsSeparatedByString(":")
        
            let intTime = timeArray[0].toInt()
            if intTime > 12 {
                let newTime:Int = intTime! - 12
                customCell.barLocation.text = "at Sharkey's around \(newTime):\(timeArray[1]) pm"
            
            }
            else {
                customCell.barLocation.text = "at Sharkey's around \(timeArray[0]):\(timeArray[1]) am"
            }
        
        }
        
        else {
            //configure specials cell
            print("here\n")
            customCell.specialName.text = "Pizza"
            customCell.specialDetails.text = "2 for 1 deals"
            customCell.specialDuration.text = "2 more hours"
        }
        
        return customCell
    }
    
    func fetchNewsFeed () {
        //create url for restful request
        var barName:String = barInfo["name"] as String
        var barString:String = "http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.newsfeed/findByBar/" + barName
        var fixedString = barString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        var url:NSURL = NSURL(string:fixedString!)!
        
        var request:NSURLRequest = NSURLRequest(URL: url)
        
        //get jason
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            
            //success!
            //add better error checking
            //set optional and if not do not reload data
            if (data?.length > 0 && error == nil)
            {
                
                //do this on main application thread
               // dispatch_async(dispatch_get_main_queue()) {
                    
                    //parse json into array
                    var jsonResult:NSArray = NSJSONSerialization.JSONObjectWithData(data,
                        options:NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
                    
                        if (jsonResult.count == 0) {
                            //handle json error here
                            print ("error parsing json file \n")
                        }
                        else {
                            
                            dispatch_async(dispatch_get_main_queue()) {
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
               // }
                
            }
                
                //failure, process error
            else {
                //show error pop up
//                print( "no news feed data for bar")
            }
            
        })
    
        
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
    @IBAction func newsClicked(sender: AnyObject) {
        
        newsLabel.hidden = false;
        specialsLabel.hidden = true;
        switchTab = false
        newsFeedTable.reloadData()
    }
    @IBAction func specialsClicked(sender: AnyObject) {
        
        newsLabel.hidden = true;
        specialsLabel.hidden = false;
        switchTab = true
        newsFeedTable.reloadData()
    }
    @IBAction func postClicked(sender: AnyObject) {
        
        performSegueWithIdentifier("postPage", sender: self)
    }
    @IBAction func checkInClicked(sender: AnyObject){
        
        if checkInButton.titleLabel!.text == "CHECK IN" {
            
            //add the bar to user check in value and check text lable to check out
            //json post to user table with new check in value
            checkInButton.setTitle("CHECK OUT", forState: UIControlState.Normal)
        }
        else {
            
            //remove the bar from user check in value and change text to check in
            //json post to user table with null check out value
            checkInButton.setTitle("CHECK IN", forState: UIControlState.Normal)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        var postPage: PostViewController = segue.destinationViewController  as PostViewController
        postPage.barInfo = self.barInfo
    }
    
    func popToRoot(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.navigationBarHidden = true
    }
    
    func setUpScreen () {
        barImage.layer.cornerRadius = barImage.frame.size.width / 2;
        barImage.clipsToBounds = true;
        let width:CGFloat = 3.0
        barImage.layer.borderWidth = width
        barImage.layer.borderColor = UIColor.whiteColor().CGColor
        
        //set bar labels
        barAddress.text = barInfo["address"] as? String
        
        //check to make sure they exist**
        let web:String = barInfo["website"] as String
        let phone:String = barInfo["phoneNumber"] as String
        
        //make website be a link that loads in a new web browser
        barWebsite.text = "\(phone)\n\(web)"
        
        newsFeedTable.delegate = self;
        newsFeedTable.dataSource = self;
        newsFeedTable.layer.cornerRadius = 10;
        
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
        
        //navication stuff
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "popToRoot:")
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        //set up navigation controller
        //        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),
        //            NSFontAttributeName: UIFont(name: "GillSans-Bold", size: 25)]
        //        self.navigationController?.navigationBar.titleTextAttributes = titleDict;
        
        self.title = barInfo["name"] as? String
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
    }


}
