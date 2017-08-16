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
    
    var posts = [Post]()
    
    
    override func viewDidLoad() {
        print("Start View Did Load in FeedVC")
            print("Print the database URL \(DB_BASE)")
       // print("Print the REFPOSTS database URL \()")
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // this is a listener for posts
       
      
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) -> Void in
            // Do things with snapshot here
            
            //  print(snapshot.value as Any)
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        print("KEY: \(key)")
                        
                        let post = Post(postKey: key, postData: postDict)
                        
                        print("POST: \(post)")
                        self.posts.append(post)
                        
                        
                    }
                }
            }
            
            self.tableView.reloadData()
            
            })
        
    
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("DAVE: Number of posts: \(posts.count)")
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        print("DAVE: Post caption \(post.caption)")
        

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
