//
//  NewPostVC.swift
//  SocialMedia
//
//  Created by Andre Rosa on 03/08/17.
//  Copyright © 2017 Andre Rosa. All rights reserved.
//

import UIKit

class NewPostVC: UIViewController {
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var postComment: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
   
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func submitPost(_ sender: UIButton) {
    }
    @IBAction func imagePicker(_ sender: UIButton) {
        
    }
}
