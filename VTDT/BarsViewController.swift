//
//  BarsViewController.swift
//  VTDT
//
//  Created by Ragan Walker on 10/23/14.
//  Copyright (c) 2014 Sanchit Chadha. All rights reserved.
//

import UIKit

class BarsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user: FBGraphUser!

    @IBOutlet var barTable: UITableView!
    var barDict = [NSDictionary]()
    var currBar = NSDictionary()    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
<<<<<<< HEAD
        barImage.layer.cornerRadius = barImage.frame.size.width / 2;
        barImage.clipsToBounds = true;
        let width:CGFloat = 3.0
        barImage.layer.borderWidth = width
        barImage.layer.borderColor = UIColor.whiteColor().CGColor
        
        newsFeedTable.delegate = self
        newsFeedTable.dataSource = self
        newsFeedTable.layer.cornerRadius = 10
        
        var tableViewController = UITableViewController()
        tableViewController.tableView = newsFeedTable
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshInvoked", forControlEvents: UIControlEvents.ValueChanged)
        tableViewController.refreshControl = self.refreshControl
        
        //default table view settings
        newsLabel.hidden = false
        specialsLabel.hidden = true
        newsButton.layer.cornerRadius = 10
        specialsButton.layer.cornerRadius = 10
        
        self.navigationController?.navigationBarHidden = false
        
=======
        //navigation setup
        self.navigationController?.navigationBarHidden = false
>>>>>>> ragan-3
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "popToRoot:")
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        
<<<<<<< HEAD
        fetchNewsFeed()
    }
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.navigationBarHidden = true
=======
        getBarData()
        barTable.delegate = self;
        barTable.dataSource = self;
        barTable.layer.cornerRadius = 10;
        // Do any additional setup after loading the view.
>>>>>>> ragan-3
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
        return barDict.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = barTable.dequeueReusableCellWithIdentifier("barCell", forIndexPath: indexPath) as UITableViewCell
        var barItem = barDict[indexPath.row]
        cell.textLabel.text = barItem["name"] as? String
        //cell.imageView.image = barItem["logo"] as UIImage
        cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width / 2;
        cell.imageView.clipsToBounds = true;
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currBar = barDict[indexPath.row]
        performSegueWithIdentifier("barPage", sender: self)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
       var barPage: BarProfileViewController = segue.destinationViewController  as BarProfileViewController
        barPage.barInfo = currBar
        barPage.user = self.user
    }
    
    func popToRoot(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.navigationBarHidden = true
    }

    
    func getBarData() {
        
        var url:NSURL = NSURL(string:"http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.bars")!
        
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
                        for item in jsonResult {
                            
                            //need to make sure that we are only appending new items--
                            //would it be worth it??
                            var dict:NSDictionary = item as NSDictionary
                            self.barDict.append(dict)
                        }
                        
                        //populate tableview here with newFeeditems that get set asynchroniously above ^^^
                        //will not populate until all news feed items have been fetched.
                        //tableview methods will be called initially (when screen is loaded) but since method
                        //is asynchronious, global newFeedItems array will still be empty
<<<<<<< HEAD
//                        print (self.newsFeedItems)
                        self.newsFeedTable.reloadData()
=======
                        self.barTable.reloadData()
>>>>>>> ragan-3
                        
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
