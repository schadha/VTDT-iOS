//
//  PostViewController.swift
//  VTDT
//
//  Created by Ragan Walker on 10/28/14.
//  Copyright (c) 2014 Sanchit Chadha. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITextViewDelegate {
    
    var barInfo = NSDictionary()
    var user: FBGraphUser!

    @IBOutlet var postButton: UIButton!
    @IBOutlet var postField: UITextView!
    
    override func viewDidLoad() {
        
        //if post field is empty, post button is invisible
        super.viewDidLoad()
        setUpScreen()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(textView: UITextView,
        shouldChangeTextInRange range: NSRange,
        replacementText text: String) -> Bool {
            
            if text == "\n" {
                textView.resignFirstResponder()
                self.postButton.hidden = false
            }
            
        return true
            
    }
    
    @IBAction func postClicked(sender: AnyObject) {
        
        var postMessage:String = postField.text
        if countElements(postMessage) > 140 {
            //launch action sheet with error message
            var alert = UIAlertController(title: "Oops!", message: "Your message must be less than 140 characters.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
        else {
            //post data
           var url:String = "http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.newsfeed"
            let barID:Int = barInfo["id"] as Int
            
            var dateFormatter:NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss"
            var timePosted:String = dateFormatter.stringFromDate(NSDate())
            

        var input:Dictionary<String, AnyObject> = ["username":user.objectID, "message":postMessage, "bar":barID, "id":1, "timePosted":timePosted]

            sendData(url, input, "POST")
            
            self.navigationController?.popViewControllerAnimated(true)

        }
    }
    
    func popToRoot(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setUpScreen () {
        self.title = "Post to Newsfeed"
        self.postButton.hidden = true
        self.postField.delegate = self
        self.postButton.layer.cornerRadius = 10;
        self.postField.layer.cornerRadius = 10;
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "popToRoot:")
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        
    }


}
