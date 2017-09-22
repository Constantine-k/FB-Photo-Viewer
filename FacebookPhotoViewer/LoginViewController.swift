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
    
    /// Facebook login button
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.readPermissions = ["email", "user_photos"];
        loginButton.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if FBSDKAccessToken.current() != nil {
            performSegue(withIdentifier: "ShowAlbums", sender: nil)
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error == nil {
            performSegue(withIdentifier: "ShowAlbums", sender: nil)
        } else {
            print("Error: \(error!.localizedDescription)")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

