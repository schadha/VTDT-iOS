//
//  LoginViewController.swift
//  VTDT
//
//  Copyright (c) 2014 Sanchit Chadha and Ragan Walker. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, FBLoginViewDelegate {
    
    
    @IBOutlet var loginView: FBLoginView!
    var user: FBGraphUser!
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        
        self.navigationController?.navigationBarHidden = true;
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        counter = 0
    }
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        self.user = user
        if (counter == 0) {
            performSegueWithIdentifier("initialPage", sender: self)
        }
        counter++;
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "initialPage") {
            var homePage: InitialViewController = segue.destinationViewController as InitialViewController
            
            var input:Dictionary<String, AnyObject> = ["checkedInBar":100, "name":user.name, "username":user.objectID, "admin":0]
            sendData("http://jupiter.cs.vt.edu/VTDT-1.0/webresources/com.group2.vtdt.users", input, "POST")
            
            homePage.user = self.user;
        }
    }
    
}
