//
//  ProfileViewController.swift
//  VTDT
//
//  Created by Sanchit Chadha on 10/19/14.
//  Copyright (c) 2014 Sanchit Chadha. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate{

//    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet var profileImage: FBProfilePictureView!
    @IBOutlet var profileName: UILabel!
    
    
    @IBOutlet var detail: UILabel!
    @IBOutlet var whoToDoButton: UIButton!
    @IBOutlet var whatToDoButton: UIButton!
    
    @IBOutlet var newsTableview: UITableView!
    var user: FBGraphUser!
    
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
        
        newsTableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: "newsFeedCell")
        newsTableview.layer.cornerRadius = 10;
        
        fetchNewsFeed()

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
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("newsFeedCell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        
        return cell
    }
    
    func fetchNewsFeed () -> [NSDictionary] {
        
        //array that stores all the dictionaries containing newsfeed data
        var newsFeedDicts = [NSDictionary]()
        
        //create url for restful request
        var url:NSURL = NSURL(string:"http://localhost:8080/VTDT/webresources/com.group2.vtdt.newsfeed")
//        var url:NSURL = NSURL(string: "http://rest-service.guides.spring.io/greeting")

        var request:NSURLRequest = NSURLRequest(URL: url)
        
        //get jason
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
        
            /* Your code */
            
            if (data.length > 0 && error == nil)
            {
                //parse json into array
                var jsonResult: NSArray = NSJSONSerialization.JSONObjectWithData(data,
                    options:NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
                
                if (jsonResult.count == 0) {
                    print ("error parsing json file \n")
                }
                else {
                    for item in jsonResult {
                        
                        var dict:NSDictionary = item as NSDictionary
                        newsFeedDicts.append(dict)
                        
                    }
                }
            }
        })
        
        //return array

        return newsFeedDicts
    }
    
    

}
