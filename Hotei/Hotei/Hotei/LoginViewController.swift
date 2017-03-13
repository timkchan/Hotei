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

    @IBOutlet weak var errorMessage: UILabel!
    
    @IBAction func registerButton(_ sender: UIButton) {
        
        // Unwrap and bind name.
        // Do nothing if name is not entered.
        guard let name = userName.text, name != "" else {
            print("Name empty")
            return
        }
        
        let userID  =  abs(name.hash) / 4294967296
        let pass = password.text
        
        let userURL: String = "http://hoteiapi20170303100733.azurewebsites.net/getUserProfile?userId=\(userID)&password=\(pass!)&register=true"
        defaults.set(userID, forKey: "userID")
        
        completeLogin(userURL: userURL, sender: sender)
        

    }
    
    // Storing UserID
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    //let urlString = String("http://hoteiapi20170303100733.azurewebsites.net/getUserProfile?userId=\(id)&password=\(pass)&")
    
    
    // When Login button is tapped.
    @IBAction func loginBtn(_ sender: UIButton) {
        
        // Unwrap and bind name.
        // Do nothing if name is not entered.
        guard let name = userName.text, name != "" else {
            print("Name empty")
            return
        }
        
        let userID  =  abs(name.hash) / 4294967296
        
        let pass = password.text
        
        let userURL: String = "http://hoteiapi20170303100733.azurewebsites.net/getUserProfile?userId=\(userID)&password=\(pass!)&register=false"
        
        defaults.set(userID, forKey: "userID")

        completeLogin(userURL: userURL, sender: sender)
        
        
        // Save userID to UserDefault
        
        
//        // Perform Segue to Activity page
//        print("userID: \(userID)")
//        performSegue(withIdentifier: "loginSegue", sender: sender)
    }
    
    
    func completeLogin(userURL: String, sender: UIButton){
        
        var code: Int = 1
        var status: Int = 1
        
        var urlRequest = URLRequest(url: URL(string: userURL)!)
        
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        
        let task = URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
            if error != nil{
                print(error!)
                return
            }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data!) as! [String: AnyObject]
                code = json["code"] as! Int
                status = json["status"] as! Int
                
                DispatchQueue.main.async {
                    switch code{
                    case 1:
                        self.errorMessage.text = "User Name or Password is Incorrect"
                        break
                    case 2:
                        self.errorMessage.text = "User Already Exists, Try Another Login"
                        break
                    default:
                        //case 0
                        if(status == 0){
                            self.performSegue(withIdentifier: "coldstart", sender: self)
                            
                        }
                        else{
                            self.performSegue(withIdentifier: "loginSegue", sender: sender)
                        }
                    }
                }
                
            }
            catch let error{
                print(error)
            }
            
        }
        
        task.resume()
        

        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    


    override func viewDidAppear(_ animated: Bool) {
        print("Trying Auto Login")
        // If user has logged in (userID exist in UserDefaults)
        //login()
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
