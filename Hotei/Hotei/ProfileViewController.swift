//
//  ProfileViewController.swift
//  Hotei
//
//  Created by Tim Kit Chan on 07/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    let defaults = UserDefaults.standard
    var loggedIn = true
    var id: Int32 = 0

    @IBAction func logoutBtn(_ sender: UIBarButtonItem) {
        print("Logging out")
        defaults.removeObject(forKey: "userID")
        loggedIn = false
        print("Logged out")
        performSegue(withIdentifier: "logoutSegue", sender: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        id = defaults.object(forKey: "userID") as! Int32
    }
    
    @IBOutlet weak var recommendation: UILabel!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}
    
    @IBAction func logout(_ sender: Any) {
        self.performSegue(withIdentifier: "logoutSegue", sender: sender)

    }
    
    
    // MARK: - Navigation


}
