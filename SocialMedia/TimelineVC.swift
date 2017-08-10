//
//  TimelineVC.swift
//  SocialMedia
//
//  Created by Andre Rosa on 03/08/17.
//  Copyright © 2017 Andre Rosa. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class TimelineVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
//class TimelineVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return (tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell)!
    }
    
    @IBAction func signOut(_ sender: Any) {
        let keyChainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("ANDRE: sign out keychain \(keyChainResult)")
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
        
    }

}
