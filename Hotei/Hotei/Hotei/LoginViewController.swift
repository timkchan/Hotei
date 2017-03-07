//
//  LoginViewController.swift
//  Hotei
//
//  Created by Tim Kit Chan on 06/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let defaults = UserDefaults.standard

    @IBOutlet weak var userName: UITextField!
    @IBAction func loginBtn(_ sender: UIButton) {
        
        // Unwrap and bind name
        guard let name = userName.text, name != "" else {
            print("Name enpty")
            return
        }

        // Compute User ID
        let userID = abs(name.hash)
        
        // Save userID to UserDefault
        defaults.set(userID, forKey: "userID")
        
        // Perform Segue
        performSegue(withIdentifier: "loginSegue", sender: sender)
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        print("Auto Login Try")
        performSegue(withIdentifier: "loginSegue", sender: self)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Tap away to hide keyboard.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Tap return to hide keyboard.
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    

    

    // MARK: - Navigation

    // Stop performing segue automatically
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("checking")
        if identifier == "loginSegue" {
            print("checking")
            // If user has logged in (userIF exist in UserDefaults)
            if let userID = defaults.object(forKey: "userID") {
                print("userID: \(userID)")
                return true
            } else {
                print("userID: not set")
                return false
            }
        }
        return true
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
