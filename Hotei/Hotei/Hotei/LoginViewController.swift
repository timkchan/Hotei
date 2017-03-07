//
//  LoginViewController.swift
//  Hotei
//
//  Created by Tim Kit Chan on 06/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // User Defaults for UserID
    let defaults = UserDefaults.standard

    // Storing UserID
    @IBOutlet weak var userName: UITextField!
    
    // When Login button is tapped.
    @IBAction func loginBtn(_ sender: UIButton) {
        
        // Unwrap and bind name.
        // Do nothing if name is not entered.
        guard let name = userName.text, name != "" else {
            print("Name enpty")
            return
        }

        // Compute User ID.
        let userID = abs(name.hash)
        
        // Save userID to UserDefault
        defaults.set(userID, forKey: "userID")
        
        // Perform Segue to Activity page
        print("userID: \(userID)")
        performSegue(withIdentifier: "loginSegue", sender: sender)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func viewDidAppear(_ animated: Bool) {
        print("Trying Auto Login")
        // If user has logged in (userID exist in UserDefaults)
        login()
    }
    
    // Function to AutoLogin (if user hasn't signed out)
    func login() {
        if let userID = defaults.object(forKey: "userID") {
            print("Logged in!")
            print("userID: \(userID)")
            performSegue(withIdentifier: "loginSegue", sender: self)
        } else {
            print("userID: not set")
        }
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
