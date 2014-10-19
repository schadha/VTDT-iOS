//
//  LoginViewController.swift
//  VTDT
//
//  Created by Sanchit Chadha on 10/19/14.
//  Copyright (c) 2014 Sanchit Chadha. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, FBLoginViewDelegate {

    
    @IBOutlet var loginView: FBLoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        //get prof pic and store in db
        //get user first and last name and store in db
        print ("here")
    }
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        
        //when logged in call to segue to profile screen
        performSegueWithIdentifier("newsFeedCell", sender: self)
        
    }
    
    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        
        //if error display message and ask user to log in again
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//        if = "newsFeedCell" {
            print ("segue complete")
//        }
    }

}
