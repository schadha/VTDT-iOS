//
//  ProfileViewController.swift
//  VTDT
//
//  Created by Ragan Walker on 10/21/14.
//  Copyright (c) 2014 Sanchit Chadha. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var user: FBGraphUser!
    var name: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpScreen()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //    // MARK: - Navigation
    //
    //    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    //        // Get the new view controller using segue.destinationViewController.
    //        // Pass the selected object to the new view controller.
    //    }
    
    func setUpScreen () {
        
        if user != nil {
            self.title = user.name
        } else {
            self.title = name;   
        }
        
        self.navigationController?.navigationBarHidden = false;
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "popToRoot:")
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "GillSans-Bold", size: 25)!]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict;
    }
    
    
}
