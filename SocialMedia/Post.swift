//
//  Post.swift
//  SocialMedia
//
//  Created by Andre Rosa on 03/08/17.
//  Copyright © 2017 Andre Rosa. All rights reserved.
//

import Foundation

class Post{
    
    private var _userPicture: String!
    private var _userName: String!
    private var _postPicture: String!
    private var _postDescription: String!
    private var _likes: String!
    
    var userPicture: String{
        if _userPicture == nil{
            _userPicture = ""
        }
        return _userPicture
    }
    
    var userName: String{
        if _userName == nil{
            _userName = ""
        }
        return _userName
    }
    
    var postPicture: String{
        if _postPicture == nil{
            _postPicture = ""
        }
        return _postPicture
    }
    
    var postDescription: String{
        if _postDescription == nil{
            _postDescription = ""
        }
        return _postDescription
    }
    
    
    
}
