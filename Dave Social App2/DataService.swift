//
//  DataService.swift
//  Dave Social App2
//
//  Created by Dave Hofmann on 8/13/17.
//  Copyright © 2017 DaveApps. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper


// this goes into plist and gets URL for Firebase database
let DB_BASE = Database.database().reference()

// this is for the firebase database of users and posts

let STORAGE_BASE = Storage.storage().reference()
// this is for the firewbase storage of photos


class DataService {
    
    static let ds = DataService()
    // singleton accessible everywhere
    
     // common endpoints
    // DB References
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    // storage references
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    var REF_USERS_CURRENT: DatabaseReference {
        // let uid = KeychainWrapper.stringF
        let uid = KeychainWrapper.defaultKeychainWrapper.string(forKey: KEY_UID)
        // let user = REF_USERS.child(uid!)
        let user = REF_USERS.child(uid!)
        
        
        
        return user
        
    }
    
    
    var REF_POST_IMAGES: StorageReference {
        return _REF_POST_IMAGES
        }
        
    

    
    

    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        // userData is the provider information
        
        // reference where we want to write this data.  Won't wipe out data, just adds data
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
