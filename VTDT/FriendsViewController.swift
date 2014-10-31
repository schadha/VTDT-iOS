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
        
        fetchNewsFeed()

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
        
        customCell.userProfPic.profileID = "10152362398270868"
        customCell.userProfPic.layer.cornerRadius = customCell.userProfPic.frame.size.width / 2;
        customCell.userProfPic.clipsToBounds = true;
        
        var timeElement = newsFeedRow["timePosted"] as String
        print(timeElement);
        var timeArray:[String] = timeElement.componentsSeparatedByString("T")[1].componentsSeparatedByString(":")
        
        let intTime = timeArray[0].toInt()
        if intTime > 12 {
            let newTime:Int = intTime! - 12
            customCell.barLocation.text = "at Sharkey's around \(newTime):\(timeArray[1]) pm"
            
        }
        else {
            customCell.barLocation.text = "at Sharkey's around \(timeArray[0]):\(timeArray[1]) am"
        }
        
        return customCell
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
    
    func fetchNewsFeed () -> () {
        
        //create url for restful request
        //        var url:NSURL = NSURL(string:"http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.users")
        var url:NSURL = NSURL(string:"http://localhost:8080/VTDT/webresources/com.group2.vtdt.friends")
        /*
        {
        "username": "10152362398270868",
        "id": 1,
        "profile_picture": "NULL",
        "checked_in_bar": 1,
        "name": "Sanchit Chadha"
        }
        */
        var request:NSURLRequest = NSURLRequest(URL: url)
        
        //get jason
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            
            //success!
            if (data != nil && error == nil)
            {
                
                //do this on main application thread
                dispatch_async(dispatch_get_main_queue()) {
                    
                    //parse json into array
                    var jsonResult: NSArray = NSJSONSerialization.JSONObjectWithData(data,
                        options:NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
                    
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
                        }
                        
                        //populate tableview here with newFeeditems that get set asynchroniously above ^^^
                        //will not populate until all news feed items have been fetched.
                        //tableview methods will be called initially (when screen is loaded) but since method
                        //is asynchronious, global newFeedItems array will still be empty
                        self.friendsTableview.reloadData()
                        
                    }
                }
                
            }
                
                //failure, process error
            else {
                print( "data was not fetched or error foundddd\n")
            }
            
        })
        
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
