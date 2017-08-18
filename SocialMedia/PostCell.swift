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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
    //the second parameter string is to check if there`s a image in cash to bring back, if not download from firebase
    func configureCell(post: Post, img: UIImage? = nil){
        postPic.image = UIImage(named: post.imageUrl)
        postDesc.text = post.caption
        heartCount.text = "\(post.likes)"
        
        if post.likes > 0{
            heart.image = UIImage(named: "heart_fill")
        } else{
            heart.image = UIImage(named: "heart")
        }
        
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
        
    }
    
}
