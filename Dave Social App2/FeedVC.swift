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
    
    @IBOutlet weak var captionField: FancyField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    var imageSelected = false
    

    
    
    
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
        
        // try to force blank to start
        captionField.text = ""
        captionField.resignFirstResponder()
        
       
       
      
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
            

            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                
                cell.configureCell(post: post)
                return cell
            } else {
                
                cell.configureCell(post: post, img: nil)
                print("DAVE: Post caption \(post.caption)")
                print("DAVE: Post ImageUrl \(post.imageUrl)")
            }
            return cell
            
        } else {
            return PostCell()
        }
 
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
            
        } else {
            print("DAVE a valid image was not selected")
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func addimageTapped(_ sender: UITapGestureRecognizer) {
    
        print("addimageTapped")
         present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    
    @IBAction func postBtnTapped(_ sender: Any) {
        // grab image and post to upload to firebase
        // need a guard statement to check conditions
        guard let caption = captionField.text, caption != "" else {
            print ("DAVE: Caption must be entered")
            return
        }
        guard  let img = imageAdd.image, imageSelected == true else {
            print("an image must be selected")
            return
        }
        // we have an image and caption at this point
        
        // if let imgData = UIImageJPEGRepresentation(img, 0.2) {
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
           
           
            //  DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metadata) { metadata, error in
                DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("DAVE: Unable to upload image to Firebasee storage")
            
                } else {
                    print("DAVE successfully uploaded images to firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imgUrl: url)
                    }
                    
                    
                }
        }
    }
    }
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, AnyObject> = [
            // have to match firebase
            "caption": captionField.text! as AnyObject,
            "imageUrl": imgUrl as AnyObject,
            "likes": 0 as AnyObject
        ]
        // create auto id for post
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        // reset the image back to add image icon
        imageAdd.image = UIImage(named: "add-image")
        
        tableView.reloadData()
        
        
    }
    
    @IBAction func signOutTapped(_ sender: AnyObject) {
        
        // need to sign out of firebase
        
        //  KeychainWrapper.removeObjectForKey(KEY_UID)
        let removeSuccessful: Bool = KeychainWrapper.standard.remove(key: KEY_UID)
        try! Auth.auth().signOut()
        
        print ("Dave: \(removeSuccessful)")
        
        
        performSegue(withIdentifier: "goToSignIn", sender: nil)    }
    
    
    
}
