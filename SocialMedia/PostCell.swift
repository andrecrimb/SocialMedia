//
//  PostCell.swift
//  SocialMedia
//
//  Created by Andre Rosa on 03/08/17.
//  Copyright © 2017 Andre Rosa. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

   
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var postPic: UIImageView!
    @IBOutlet weak var postDesc: UILabel!
    @IBOutlet weak var heart: UIImageView!
    @IBOutlet weak var heartCount: UILabel!
    
    var post: Post!
    var userLikeRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //cofiguring tapgesture recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        self.heart.addGestureRecognizer(tap)
        self.heart.isUserInteractionEnabled = true
    }
    
    
    //the second parameter string is to check if there`s a image in cash to bring back, if not download from firebase
    func configureCell(post: Post, img: UIImage? = nil){
        self.post = post
        userLikeRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        postPic.image = UIImage(named: post.imageUrl)
        postDesc.text = post.caption
        heartCount.text = "\(post.likes)"

        if img != nil{
            postPic.image = img
        } else{
            
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil{
                    print("\nANDRE: unable to download image from firebase storage\nERRO: \(String(describing: error))\n")
                } else{
                    print("\nANDRE: image downloaded from firebase storage\n")
                    if let imgData = data{
                        if let img = UIImage(data: imgData){
                            self.postPic.image = img
                            //save image in cache
                            TimelineVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
            
        }
        userLikeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.heart.image = UIImage(named: "heart")
            } else{
                self.heart.image = UIImage(named: "heart_fill")
            }
        })
    }
    
    
    func likeTapped(sender: UITapGestureRecognizer){
        userLikeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.heart.image = UIImage(named: "heart_fill")
                self.post.adjustLikes(addLike: true)
                self.userLikeRef.setValue(true)
            } else{
                self.heart.image = UIImage(named: "heart")
                self.post.adjustLikes(addLike: false)
                self.userLikeRef.removeValue()
            }
        })
    }
    
   
    
}
