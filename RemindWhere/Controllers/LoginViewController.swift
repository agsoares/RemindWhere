//
//  LoginViewController.swift
//  RemindWhere
//
//  Created by Adriano Soares on 19/04/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.frame = CGRectMake(self.view.frame.width*0.2,
                                       self.view.frame.height*0.75,
                                       self.view.frame.width*0.6, 40)
        self.view.addSubview(loginButton)
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let user = PFUser.currentUser() {
            self.performSegueWithIdentifier("autoLoginSegue", sender: nil)
        }
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        PFFacebookUtils.logInInBackgroundWithAccessToken (FBSDKAccessToken.currentAccessToken(), block: {
            (user, error) in
            if let user = user {
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        })
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
