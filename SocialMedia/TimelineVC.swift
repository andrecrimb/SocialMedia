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
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshot{
                    print("\(snap)")
                    if let dictPost = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let post = Post(postKey: key, postData: dictPost)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell{
            let postCell = posts[indexPath.row]
            cell.configureCell(post: postCell)
            return cell
        } else{
            return UITableViewCell()
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        let keyChainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("ANDRE: sign out keychain \(keyChainResult)")
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
        
    }

}
