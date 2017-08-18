//
//  NewPostVC.swift
//  SocialMedia
//
//  Created by Andre Rosa on 03/08/17.
//  Copyright © 2017 Andre Rosa. All rights reserved.
//

import UIKit

class NewPostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var postComment: UITextView!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        //habilita o picker para editar as imangens
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
    }
   
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func submitPost(_ sender: UIButton) {
    }
    @IBAction func imagePicker(_ sender: UIButton) {
       
        present(imagePicker, animated: true, completion: nil)
    }
    
    //configura o picker para que a imagem do IBOutlet receba a imagem do picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imagePreview.image = image
        } else{
            print("ANDRE: a valid image wasn`t selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //This will hide the keyboard touching outside
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
