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


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        print("Start View Did Load in FeedVC")
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
    }
    
    
    
    @IBAction func signOutTapped(_ sender: AnyObject) {
        
        // need to sign out of firebase
        
        //  KeychainWrapper.removeObjectForKey(KEY_UID)
        let removeSuccessful: Bool = KeychainWrapper.standard.remove(key: KEY_UID)
        try! Auth.auth().signOut()
        
        print ("Dave: \(removeSuccessful)")
        
        
        performSegue(withIdentifier: "goToSignIn", sender: nil)    }
    
    
    
}
