//
//  DataService.swift
//  SocialMedia
//
//  Created by Andre Rosa on 14/08/17.
//  Copyright © 2017 Andre Rosa. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let STORE_BASE = FIRStorage.storage().reference()
let DB_BASE = FIRDatabase.database().reference()

class DataService {
    
    static let ds = DataService()
    
    // DB References
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    //Storage References
    private var _REF_POST_IMAGES = STORE_BASE.child("post-pics")
    
    
    var REF_BASE: FIRDatabaseReference{
        return _REF_BASE
    }
    var REF_POSTS: FIRDatabaseReference{
        return _REF_POSTS
    }
    var REF_USERS: FIRDatabaseReference{
        return _REF_USERS
    }
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
        
    }
    
    var REF_POST_IMAGES: FIRStorageReference{
        return _REF_POST_IMAGES
    }
    
    func createFirbaseDBUser(uid: String, userData: Dictionary<String, String>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
}
