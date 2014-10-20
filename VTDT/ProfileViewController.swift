//
//  ProfileViewController.swift
//  VTDT
//
//  Created by Sanchit Chadha on 10/19/14.
//  Copyright (c) 2014 Sanchit Chadha. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate {

//    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet var profileImage: FBProfilePictureView!
    @IBOutlet var profileName: UILabel!
    
    
    @IBOutlet var detail: UILabel!
    @IBOutlet var whoToDoButton: UIButton!
    @IBOutlet var whatToDoButton: UIButton!
    
    @IBOutlet var tableView: UITableView!
    
    var user: FBGraphUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileName.text = user.first_name + " " + user.last_name
        self.detail.text = user.objectID //Store this in DB as username
        self.profileImage.profileID = user.objectID
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
    
    

}
