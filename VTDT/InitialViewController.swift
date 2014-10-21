//
//  ProfileViewController.swift
//  VTDT
//
//  Created by Sanchit Chadha on 10/19/14.
//  Copyright (c) 2014 Sanchit Chadha. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet var profileImage: FBProfilePictureView!
    @IBOutlet var profileName: UILabel!

    @IBOutlet var whoToDoButton: UIButton!
    @IBOutlet var whatToDoButton: UIButton!
    
    @IBOutlet var newsTableview: UITableView!
    var user: FBGraphUser!
    var newsFeedItems = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileName.text = user.first_name + " " + user.last_name
        profileName.font = UIFont(name: "GillSans-Bold", size: 24)
        profileName.textColor = UIColor.whiteColor()
        
//        self.detail.text = user.objectID //Store this in DB as username
        
        profileImage.profileID = user.objectID
        profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
        profileImage.clipsToBounds = true;
        
        let width:CGFloat = 3.0
        profileImage.layer.borderWidth = width
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor

        newsTableview.delegate = self;
        newsTableview.dataSource = self;
//        newsTableview.registerClass(NewsFeedTableViewCell.self, forCellReuseIdentifier: "newsFeedCell")
        newsTableview.layer.cornerRadius = 10;
        
        fetchNewsFeed()
        print (newsFeedItems)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(sender: AnyObject) {
        FBSession.activeSession().closeAndClearTokenInformation()
        performSegueWithIdentifier("exit", sender: self)
    }
//    func editProfileButton(sender: AnyObject) {
//        print("test")
//        //        performSegueWithIdentifier("exit", sender: self)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//        var vc = segue.destinationViewController as LoginViewController
    }
    
    //MARK: -Tableview methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return newsFeedItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var customCell:NewsFeedTableViewCell = newsTableview.dequeueReusableCellWithIdentifier("newsFeedCell", forIndexPath: indexPath) as NewsFeedTableViewCell
        
        var newsFeedRow:NSDictionary = newsFeedItems[indexPath.row]
        
        
        //name of user where userid --> newsFeedRow["user"]
        //use the userID to do a fetch to the user db table for first name, last name, profile picture
        var userID = user
        customCell.userName.text = userID.first_name + " " + userID.last_name
        
//        customCell.messageText.text = newsFeedRow["message"] as? String
        customCell.messageText.text = "hello this is a very long message about what i was doing at sharkey's last night.  it must be less than 140 characters or else it wont post."
        
        //profile pic of user based on user id
        
        customCell.userProfPic.profileID = userID.objectID
        customCell.userProfPic.layer.cornerRadius = customCell.userProfPic.frame.size.width / 2;
        customCell.userProfPic.clipsToBounds = true;
        
        var timeElement = newsFeedRow["timePosted"] as String
        var timeArray:[String] = timeElement.componentsSeparatedByString("T")[1].componentsSeparatedByString(":")
        
        let intTime = timeArray[0].toInt()
        if intTime > 12 {
            let newTime:Int = intTime! - 12
            customCell.barLocation.text = "at Sharkey's around \(newTime):\(timeArray[1]) pm"

        }
        else {
            customCell.barLocation.text = "at Sharkey's around \timeArray[0]:\timeArray[1] am"
        }
        
        return customCell
    }
    
    func fetchNewsFeed () -> () {

        
        //create url for restful request
        var url:NSURL = NSURL(string:"http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.newsfeed")

        var request:NSURLRequest = NSURLRequest(URL: url)
        
        //get jason
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
        
            
            //success!
            if (data.length > 0 && error == nil)
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
                        
                            var dict:NSDictionary = item as NSDictionary
                            self.newsFeedItems.append(dict)
                        }
                        
                        //populate tableview here with newFeeditems that get set asynchroniously above ^^^
                        //will not populate until all news feed items have been fetched.
                        //tableview methods will be called initially (when screen is loaded) but since method 
                        //is asynchronious, global newFeedItems array will still be empty
                        self.newsTableview.reloadData()

                    }
                }
                
            }
                
            //failure, process error
            else {
                print( "data was not fetched or error foundd\n")
            }

        })
        
    }
    
    

}
