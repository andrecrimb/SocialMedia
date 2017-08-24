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
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
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
        startAnimation(type: true)
        //an if to create a constant
        guard let caption = postComment.text, caption != defaultCaption else{
            startAnimation(type: false)
            self.customAlert(message: "Caption must be entered")
            
            print("ANDRE: caption caption must be entered")
            return
        }
        guard let img = imagePreview.image, imageSelected == true else {
            
            startAnimation(type: false)
            self.customAlert(message: "Image must be entered")
            
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
                    self.startAnimation(type: false)
                    self.customAlert(message: "Unable to upload image")
                } else{
                    self.dismiss(animated: true, completion: nil)
                    print("ANDRE: successfully to upload image to firebase storage")
                    //this method returns the download link to image
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    
                    if let url = downloadURL{
                        self.postToFirebase(imgUrl: url)
                    }
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
    
    func postToFirebase(imgUrl: String){
        let post: Dictionary<String, AnyObject> = [
            "caption": postComment.text as AnyObject,
            "imageUrl": imgUrl as AnyObject,
            "likes": 0 as Int as AnyObject
        ]
        
        //create id automatically and put values on it rewrite values inside, different of when I create a new user
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
    }
    
    func customAlert(message: String){
        let alert = UIAlertController(title: "Ops..", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func startAnimation(type: Bool){
        self.view.endEditing(true)
        if type {
            self.spinner.startAnimating()
            self.sendBtn.isHidden = true
        } else {
            self.spinner.stopAnimating()
            self.sendBtn.isHidden = false
        }
        
    }
    
}
