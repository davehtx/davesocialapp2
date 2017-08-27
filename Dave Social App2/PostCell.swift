//
//  PostCell.swift
//  Dave Social App2
//
//  Created by Dave Hofmann on 8/12/17.
//  Copyright © 2017 DaveApps. All rights reserved.
//

import UIKit
import Firebase


class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    var post: Post!
     // let likesRef = DataService.ds.REF_USERS_CURRENT.child("likes")
    // not sure why he changes this
    var likesRef: DatabaseReference!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // UITapGestureRecognizer(target: <#T##Any?#>, action: Selector?)
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true

    }

    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        
        // likesRef = DataService.ds.REF_USERS_CURRENT.child("likes")
        likesRef = DataService.ds.REF_USERS_CURRENT.child("likes").child(post.postKey)
        
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        // download images
        if img != nil {
            print("Image is not nil")
            self.postImg.image = img
        } else  {
            // image not in cache - download it
            print("in else loop because image not in cache")
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            print("ref is \(ref)")
            
            ref.getData(maxSize: 10 * 1024 * 1024, completion: { (data, error) in
                print("After refData line - error message is: \(error)")
                print("After refData line - Data message is: \(data)")
                if error != nil {
                    print("Dave Unable to download image from firebase storage \(img)")
                } else {
                    print("dave image downloaded \(img)")
                    
                    if let imgData = data {
                        
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                            
                        }
                    }
                    
                    
                }
            })
                
            
        }
        
        // let likesRef = DataService.ds.REF_USERS_CURRENT.child("likes")
        // get a single event of the number of likes from database
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                // if not set then use empty heart
                self.likeImg.image = UIImage (named: "empty-heart")
                print("  ")
                //print("DAVE this one is NOT liked \(likesRef)")
            } else {
                self.likeImg.image = UIImage(named: "filled-heart")
                print("  ")
               // print("DAVE this one is liked \(likesRef)")
                
            }
    })
    
    }
    
        func likeTapped(sender: UITapGestureRecognizer) {
            
            print("DAVE the Like button tapped")
            likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? NSNull {
                    // if not set to Like then use filled heart
                    self.likeImg.image = UIImage (named: "filled-heart")
                    
                    self.post.adjustLikes(addLike: true)
                    self.likesRef.setValue(true)
                    
                    
                } else {
                    self.likeImg.image = UIImage(named: "empty-heart")
                    self.post.adjustLikes(addLike: false)
                    self.likesRef.removeValue()
                    
                }
            })

            
        }
        
        
    
    
    
    
}
