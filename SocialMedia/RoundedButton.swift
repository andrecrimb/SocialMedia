//
//  RoundedButton.swift
//  SocialMedia
//
//  Created by Andre Rosa on 03/08/17.
//  Copyright © 2017 Andre Rosa. All rights reserved.
//

import UIKit

private var roundedBtn = false

extension UIButton {

    @IBInspectable var roundedButton: Bool{
        get{
            return roundedBtn
        }
        set{
            roundedBtn = newValue
            
            if roundedBtn{
                self.layer.cornerRadius = 6.0
            } else{
                self.layer.cornerRadius = 0.0
            }
            
        }
    }
}
