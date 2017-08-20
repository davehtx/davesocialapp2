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

    var post: Post!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
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
            
    }
    
    
    
}
