//
//  RoundedTVC.swift
//  SocialMedia
//
//  Created by Andre Rosa on 03/08/17.
//  Copyright © 2017 Andre Rosa. All rights reserved.
//

import UIKit

private var rounded = false

extension UIView {

    @IBInspectable var Rounded: Bool{
        get{
            return rounded
        }
        set{
            rounded = newValue
            
            if rounded{
                self.layer.cornerRadius = 12
            } else{
                self.layer.cornerRadius = 0
            }
        }
    }
   
}
