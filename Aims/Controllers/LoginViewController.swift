//
//  LoginViewController.swift
//  Aims
//
//  Created by Yilun Liu on 12/16/15.
//  Copyright © 2015 Yilun Liu. All rights reserved.
//

import UIKit
import ParseUI
import CocoaLumberjackSwift

class LoginViewController: PFLogInViewController, PFLogInViewControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.fields.subtractInPlace(PFLogInFields.DismissButton)
        self.delegate = self
        self.signUpController = SignupViewController()
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - PFLogInViewControllerDelegate
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        DDLogError("User Failed to Login in with Error \(error)")
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        DDLogInfo("User Logged in with user \(user)")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = storyBoard.instantiateInitialViewController()!
        UIApplication.sharedApplication().keyWindow?.rootViewController = rootViewController
    }
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        return true
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        
    }
    

}
