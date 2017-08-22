//
//  NewPostVC.swift
//  SocialMedia
//
//  Created by Andre Rosa on 03/08/17.
//  Copyright © 2017 Andre Rosa. All rights reserved.
//

import UIKit
import Firebase

class NewPostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var postComment: UITextView!
    
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    let defaultCaption = "Say something about this pic"
    
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
        //an if to create a constant
        guard let caption = postComment.text, caption != defaultCaption else{
            print("ANDRE: caption caption must be entered")
            return
        }
        guard let img = imagePreview.image, imageSelected == true else {
            print("ANDRE: an image must be entered")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2){
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metadata){ (metadata, error) in
                if error != nil{
                    print("ANDRE: unable to upload image to firebase storage \(String(describing: error))")
                } else{
                    print("ANDRE: successfully to upload image to firebase storage")
                    //this method returns the download link to image
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                }
            }

        }
        
    }
    @IBAction func imagePicker(_ sender: UIButton) {
       
        present(imagePicker, animated: true, completion: nil)
    }
    
    //configura o picker para que a imagem do IBOutlet receba a imagem do picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imagePreview.image = image
            imageSelected = true
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
