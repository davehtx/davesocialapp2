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
import SwiftKeychainWrapper

//  import SwiftKeychainWrapper


class SignInVC: UIViewController {

    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.defaultKeychainWrapper.string(forKey: KEY_UID) {
            
            print("DAve ID found in keychain")
            
            performSegue(withIdentifier: "goToFeed", sender: nil)
            
        }

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
                print("Dave Successfully authenticated with firebase")
                
                if let user = user {
                    let userData = ["provider": credential.provider]
                    
                    self.completeSignIn(id: user.uid, userData: userData)
                }
                
            }
    })
        
        
    }
    
    
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            
            // Auth.auth()?.signIn(withEmail: )
           // FIRAuth.auth()?.signInWithEmail()
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    // good name and password
                    print("username is \(user)")
                    print("pwd is \(pwd)")
                    print("Dave Email User Authenticated with firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                    

                }  else {
                    // user doesn't exist or password wrong
                    print("Dave we will try to create a new user.  Firebase returns an error if user already exists")
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Dave something is wrong with login to firebase with email")
                            print("error is \(error)")
                            
                        } else {
                            print("Dave user successfully authenticated with Firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
    }
    
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("KeyChainWrapper function run \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
        
    }
}


