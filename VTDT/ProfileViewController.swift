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
    
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
//        print (user)
        self.navigationController?.navigationBarHidden = false;
=======

>>>>>>> FETCH_HEAD
        self.title = user.name;
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "popToRoot:")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.navigationBarHidden = true;
    }
    
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }


}
