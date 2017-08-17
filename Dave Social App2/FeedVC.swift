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


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var imageAdd: CircleView!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    

    
    
    
    override func viewDidLoad() {
        print("Start View Did Load in FeedVC")
            print("Print the database URL \(DB_BASE)")
       // print("Print the REFPOSTS database URL \()")
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        imagePicker =  UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        // this is a listener for posts
       
      
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) -> Void in
            // Do things with snapshot here
            
            //  print(snapshot.value as Any)
            
            self.posts = [] // THIS IS THE NEW LINE

            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshot {
                    print("snapshot: \(snapshot)")
                    
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
        
        print("DAVE: Number of posts is: \(posts.count)")
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]

        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.configureCell(post: post)
            print("DAVE: Post caption \(post.caption)")
            print("DAVE: Post ImageUrl \(post.imageUrl)")
            return cell
        } else {
            return PostCell()
            
        }

       
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            
            
        } else {
            print("DAVE a valid image was not selected")
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func addimageTapped(_ sender: UITapGestureRecognizer) {
    
        print("addimageTapped")
         present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    @IBAction func signOutTapped(_ sender: AnyObject) {
        
        // need to sign out of firebase
        
        //  KeychainWrapper.removeObjectForKey(KEY_UID)
        let removeSuccessful: Bool = KeychainWrapper.standard.remove(key: KEY_UID)
        try! Auth.auth().signOut()
        
        print ("Dave: \(removeSuccessful)")
        
        
        performSegue(withIdentifier: "goToSignIn", sender: nil)    }
    
    
    
}
