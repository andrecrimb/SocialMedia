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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                        if error != nil{
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
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil{
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
                print("ANDRE: unable to authenticate to firebase using facebook - \(String(describing: error))")
            } else {
                print("ANDRE: sucesss authenticate to firebase with facebook")
                if let user = user{
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
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

}

