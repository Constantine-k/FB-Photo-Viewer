//
//  ViewController.swift
//  FacebookPhotoViewer
//
//  Created by Konstantin Konstantinov on 9/14/17.
//  Copyright © 2017 Konstantin Konstantinov. All rights reserved.
//

import UIKit

import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Facebook login button
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["email", "user_photos"];
        loginButton.delegate = self
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
            print("User is logged in")
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("Completed login")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

