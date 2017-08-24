//
//  Post.swift
//  SocialMedia
//
//  Created by Andre Rosa on 03/08/17.
//  Copyright © 2017 Andre Rosa. All rights reserved.
//

import Foundation
import Firebase

class Post{
    
    private var _caption: String!
    private var _imageUrl: String!
    private var _postKey: String!
    private var _likes: Int!
    private var _postRef: FIRDatabaseReference!
    
    var caption: String{
        if _caption == nil{
            _caption = ""
        }
        return _caption
    }
    
    var imageUrl: String{
        if _imageUrl == nil{
            _imageUrl = ""
        }
        return _imageUrl
    }
    
    var postKey: String{
        if _postKey == nil{
            _postKey = ""
        }
        return _postKey
    }
    
    var likes: Int{
        if _likes == nil{
            _likes = 0
        }
        return _likes
    }
    
    
    init(postKey: String, postData: Dictionary<String, AnyObject>){
        self._postKey = postKey
        
        
        if let caption = postData["caption"] as? String{
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String{
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int{
            self._likes = likes
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
        
    }
    
    func adjustLikes(addLike: Bool){
        if addLike{
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
    
    
}
