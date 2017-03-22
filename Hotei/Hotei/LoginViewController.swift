//
//  LoginViewController.swift
//  Hotei
//
//  Created by Tim Kit Chan on 06/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // User Defaults for UserID
    let defaults = UserDefaults.standard

    @IBOutlet weak var errorMessage: UILabel!
    
    @IBAction func registerButton(_ sender: UIButton) {
        self.loadingSign.isHidden = false;
        self.loadingSign.startAnimating();
        // Unwrap and bind name.
        // Do nothing if name is not entered.
        guard let name = userName.text, name != "" else {
            print("Name empty")
            return
        }
        
        let userID  =  abs(name.hash) / 4294967296
        let pass = password.text
        
        // Storing UserID
        defaults.set(userID, forKey: "userID")
        
        let userURL: String = "http://hoteiapi20170303100733.azurewebsites.net/getUserProfile?userId=\(userID)&password=\(pass!)&register=true"
        completeLogin(userURL: userURL, sender: sender)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var loadingSign: UIActivityIndicatorView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    // When Login button is tapped.
    @IBAction func loginBtn(_ sender: UIButton) {
        self.loadingSign.isHidden = false;
        self.loadingSign.startAnimating();
        // Unwrap and bind name.
        // Do nothing if name is not entered.
        guard let name = userName.text, name != "" else {
            print("Name empty")
            return
        }
        
        let userID  =  abs(name.hash) / 4294967296
        
        let pass = password.text
        
        let userURL: String = "http://hoteiapi20170303100733.azurewebsites.net/getUserProfile?userId=\(userID)&password=\(pass!)&register=false"
        
        // Save userID to UserDefault
        defaults.set(userID, forKey: "userID")

        completeLogin(userURL: userURL, sender: sender)
    }
    
    // Loggin in (register if needed)
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
                    default:    //case 0
                        
                        // For auto login
                        let loggedIn = 1
                        self.defaults.set(loggedIn, forKey: "loggedIn")
                        
                        if(status == 0){
                            
                            self.performSegue(withIdentifier: "coldstart", sender: self)
                        }
                        else{
                            self.performSegue(withIdentifier: "loginSegue", sender: sender)
                        }
                    }
                    self.loadingSign.isHidden = true;
                    self.loadingSign.stopAnimating();
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
        self.loadingSign.isHidden = true;
        self.userName.delegate = self;
        self.password.delegate = self;
        // Do any additional setup after loading the view.
    }

    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }


    override func viewDidAppear(_ animated: Bool) {
        print("Trying Auto Login")
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // If user has logged in ('loggedIn' exists in UserDefaults)
        autoLogin()
    }
    
    
    // Function to AutoLogin (if user hasn't signed out)
    func autoLogin() {
        if defaults.object(forKey: "loggedIn") != nil {
            print("Logged in!")
            performSegue(withIdentifier: "loginSegue", sender: self)
        } else {
            print("loggedIn: not set")
        }
    }

    // Tap away to hide keyboard.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    



    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
