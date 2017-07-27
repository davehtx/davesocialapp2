//
//  FeedVC.swift
//  Dave Social App2
//
//  Created by Dave Hofmann on 7/25/17.
//  Copyright © 2017 DaveApps. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper


class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func signInTapped(_ sender: AnyObject) {
        
        // need to sign out of firebase
        
        //  KeychainWrapper.removeObjectForKey(KEY_UID)
        let removeSuccessful: Bool = KeychainWrapper.standard.remove(key: KEY_UID)
        try! Auth.auth().signOut()
        
        print ("Dave: \(removeSuccessful)")
        
        
        performSegue(withIdentifier: "goToSignIn", sender: nil)    }
    
    
    
}
