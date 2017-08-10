//
//  RoundedImage.swift
//  SocialMedia
//
//  Created by Andre Rosa on 10/08/17.
//  Copyright © 2017 Andre Rosa. All rights reserved.
//

import UIKit

private var rounded = false

 extension UIImageView {
    @IBInspectable var RoundedImage: Bool{
        get{
            return rounded
        }
        set{
            rounded = newValue
            
            if rounded{
                self.layer.masksToBounds = true
                self.layer.cornerRadius = self.frame.size.width/2
            } else {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 0
            }
        }
    }
}
