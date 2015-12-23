//
//  MineViewController.swift
//  Aims
//
//  Created by Yilun Liu on 12/17/15.
//  Copyright © 2015 Yilun Liu. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class MineViewController: UITableViewController {

    @IBOutlet weak var profilePictureImageView: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = PFUser.currentUser()?.username
        emailLabel.text = PFUser.currentUser()?.email
        profilePictureImageView.image = UIImage(named: "default_profile_picture")
    }
    
    
    @IBAction func logoutPressed(sender: AnyObject) {
        
        PFUser.logOut()
        let rootViewController = LoginViewController()
        UIApplication.sharedApplication().keyWindow?.rootViewController = rootViewController
    }
    
    
}
