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
    var userID = -1

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
            print("error; too many chars\n")
        }
        else {
            //post data
            
            //get the current time
            
//            var url:String = "http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.newsfeed"
            var url:String = "http://localhost:8080/VTDT/webresources/com.group2.vtdt.newsfeed"
            var input:Dictionary<String, AnyObject> = ["username":"10152362398270868", "message":postMessage, "timePosted":"2014-10-30T10:19:02", "bar":2]
            RestfulFunctions.postData(url, params:input)
            
            self.navigationController?.popViewControllerAnimated(true)

        }
    }
    @IBOutlet var textFieldTapped: [UITextView]!
    
    func setUpScreen () {
        
        self.postButton.hidden = true
        self.postField.delegate = self
        self.postButton.layer.cornerRadius = 10;
        self.postField.layer.cornerRadius = 10;
        self.automaticallyAdjustsScrollViewInsets = false
        
    }


}
