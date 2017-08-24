//
//  ViewController.swift
//  SocialMedia
//
//  Created by Andre Rosa on 01/08/17.
//  Copyright © 2017 Andre Rosa. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation(type: false)
    }
    //só é possivel realizar segues diretas no view didappear
    override func viewDidAppear(_ animated: Bool) {
        checkAlreadyAuthenticate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func entrarPress(_ sender: UIButton) {
        startAnimation(type: true)
        if let email = emailField.text, let password = passwordField.text{
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil{
                    print("ANDRE: Email athenticated with firebase")
                    if let user = user{
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else{
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        self.startAnimation(type: false)
                        
                        if error != nil{
                            self.customAlert(message: "Unable to authenticate with facebook")
                            print("ANDRE: unable to authentica with firebase using email and password")
                        } else{
                            print("ANDRE: Successfully authenticate with firebase using email and password")
                            if let user = user{
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }

    @IBAction func facebookBtnPress(_ sender: UIButton) {
        startAnimation(type: true)
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            self.startAnimation(type: false)
            if error != nil{
                self.customAlert(message: "Unable to authenticate with facebook")
                print("ANDRE: unable to authenticate using facebook - \(String(describing: error))")
            } else if result?.isCancelled == true {
                print("ANDRE: user cancel authentication with facebook")
            } else{
                print("ANDRE: sucess to authenticate with facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil{
                self.customAlert(message: "Unable to authenticate with facebook, email already in use")
                print("ANDRE: unable to authenticate to firebase using facebook - \(String(describing: error))")
            } else {
                print("ANDRE: sucesss authenticate to firebase with facebook")
                if let user = user{
                    let userData = [
                        "provider": credential.provider,
                        "profileImg": user.photoURL!.absoluteString,
                        "userName": user.displayName
                    ]
                   
                 //   let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData as! Dictionary<String, String>)
                }
                
            }
        })
    }
    

    func completeSignIn(id: String, userData: Dictionary<String, String>){
        DataService.ds.createFirbaseDBUser(uid: id, userData: userData)
        let keyChainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("ANDRE: Data saved in keychain - \(keyChainResult)")
        performSegue(withIdentifier: TO_TIMELINE, sender: nil)
    }
    
    func checkAlreadyAuthenticate(){
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            performSegue(withIdentifier: TO_TIMELINE, sender: nil)
        }
        
    }
    
    func startAnimation(type: Bool){
        self.view.endEditing(true)
        if type {
            self.spinner.startAnimating()
            self.signInBtn.isEnabled = false
        } else {
            self.spinner.stopAnimating()
            self.signInBtn.isEnabled = true
        }
        
    }
    
    //This will hide the keyboard touching outside
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func customAlert(message: String){
        let alert = UIAlertController(title: "Ops..", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

