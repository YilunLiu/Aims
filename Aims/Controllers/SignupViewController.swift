//
//  SignupViewController.swift
//  Aims
//
//  Created by Yilun Liu on 12/16/15.
//  Copyright © 2015 Yilun Liu. All rights reserved.
//

import UIKit
import ParseUI
import CocoaLumberjackSwift

class SignupViewController: PFSignUpViewController, PFSignUpViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        self.delegate = self
        self.minPasswordLength = 6
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
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        DDLogError("User failed to sign up with error \(error)")
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        DDLogInfo("User signed in with user \(user)")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = storyBoard.instantiateInitialViewController()!
        UIApplication.sharedApplication().keyWindow?.rootViewController = rootViewController
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [String : String]) -> Bool {
        return true
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        
    }

}
