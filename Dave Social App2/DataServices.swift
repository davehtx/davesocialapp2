//
//  DataServices.swift
//  Dave Social App2
//
//  Created by Dave Hofmann on 8/13/17.
//  Copyright © 2017 DaveApps. All rights reserved.
//

import Foundation

import Firebase

// this goes into plist and gets URL for Firebase database
let DB_BASE = Database.database().reference()




class DataService {
    

    
    

    
    static let ds = DataService()
    // singleton accessible everywhere
    
     // common endpoints
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: DatabaseReference {
        return _REF_POSTS
        
        
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }

    
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
        
        
        
    }

    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        // userData is the provider information
        
        // reference where we want to write this data.  Won't wipe out data, just adds data
        REF_USERS.child(uid).updateChildValues(userData)
        
        
        
    }
    
}
