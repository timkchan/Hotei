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
    
    @IBAction func getRecommendation(_ sender: Any) {

        self.getRecommendation()
        
    }
    
    func getRecommendation() {
        
        let userURL: String = "http://hoteiapi20170303100733.azurewebsites.net/GetUserRecommendation?userID=\(id)&numRec=1"

        var urlRequest = URLRequest(url: URL(string: userURL)!)

        var responses = [String]()
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
            if error != nil{
                print(error!)
                return
            }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data!) as! [String]
                responses = json
                
                if(responses.isEmpty){
                    DispatchQueue.main.async {
                        self.recommendation.text = "No Recommendation"                    }
                }
                else{
                    
                    DispatchQueue.main.async {
                        self.recommendation.text = responses[0]
                    }
                
                }
            }
            catch let error{
                print(error)
            }
        }
        
        
        task.resume()
        
    }

    // MARK: - Navigation


}
