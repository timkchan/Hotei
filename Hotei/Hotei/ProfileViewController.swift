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
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var bpm: UILabel!
    @IBOutlet weak var perWeek: UILabel!

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
        if(id != 4533){
            name.text = "NA"
            age.text = "NA"
            height.text = "NA"
            weight.text = "NA"
            bpm.text = "NA"
            perWeek.text = "NA"
            picture.image = UIImage(named: "unknown")
        }
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
