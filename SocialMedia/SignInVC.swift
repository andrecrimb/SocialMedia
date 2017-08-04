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

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnPress(_ sender: UIButton) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil{
                print("ANDRE: unable to authenticate - \(String(describing: error))")
            } else if result?.isCancelled == true {
                print("ANDRE: user cancel authentication")
            } else{
                
                print("ANDRE: sucess to authenticate")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credential)
                
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil{
                print("ANDRE: unable to authenticate to firebase - \(String(describing: error))")
            } else {
                print("ANDRE: sucesss authenticate to firebase")
            }
        })
    }
    

}

