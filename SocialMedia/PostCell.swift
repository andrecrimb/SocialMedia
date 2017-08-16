//
//  PostCell.swift
//  SocialMedia
//
//  Created by Andre Rosa on 03/08/17.
//  Copyright © 2017 Andre Rosa. All rights reserved.
//

import UIKit

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
    
    func configureCell(post: Post){
        
    }
    
}
