//
//  ViewController.swift
//  Dave Social App2
//
//  Created by Dave Hofmann on 7/5/17.
//  Copyright © 2017 DaveApps. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
//  import SwiftKeychainWrapper


class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func facebookBtn(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        print("I'm in the facebookBtn function")
        
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("DAVE: Unable to authenticate with Facebook - \(error)")
                
            } else if result?.isCancelled == true {
                print("Dave: User cancelled Facebook Auth")
            } else {
                print("Dave - Auth with facebook successful")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                //  let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
                
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                
                print("Dave unable to authenticate with firebase - \(error)")
                
            } else {
                print("Successfully authenticated with firebase")
            }
    })
    }
}

