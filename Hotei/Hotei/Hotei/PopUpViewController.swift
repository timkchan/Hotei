//
//  PopUpViewController.swift
//  Hotei
//
//  Created by Nick Robertson on 13/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    var currentActivity : String?
    var id : Int32?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    @IBOutlet weak var titleActivity: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var activityInput: UITextField!

    override func viewWillAppear(_ animated: Bool) {
        if(currentActivity == "Add Activity"){
            activityInput.isHidden = false;
        
        }else{
            activityInput.isHidden = true;
        
        }
        errormsg.isHidden = true
        titleActivity.text = currentActivity


    }
    
    @IBOutlet weak var errormsg: UILabel!
    
    @IBAction func hapinessLevel(_ sender: UIButton) {
        
        
        if ((activityInput.text?.isEmpty)! && !activityInput.isHidden){
            
            DispatchQueue.main.async {
                
                self.errormsg.text = "Please enter an activity"
            
            }
            
        }
        else{
        
            if(!(activityInput.text?.isEmpty)!){
                currentActivity = activityInput.text
            }
            
            let date = Date()
            
            // Creating History entry and saving it
            let history = History(context: context)
            history.dateTime = date as NSDate
            history.activity = currentActivity
            history.rating = Int16(sender.tag)
            history.userID = id!
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            
            postToDataBase(UserId: id!, activity: currentActivity!, Rating: sender.tag)
            
            removeAnimate()
        
        
        }
        
    }
    
    
    // Function to POST user activity record
    func postToDataBase(UserId: Int32, activity: String, Rating: Int) {
        
        let json: [String: Any] = ["UserId": UserId,
                                   "Activity": activity,
                                   "Rating": Rating]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://hoteiapi20170303100733.azurewebsites.net/UserPerformActivity")!
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
    }


 
    func showAnimate(){
    
        self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1
            self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
            
        });
    
    }
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
        
            self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished: Bool) in
            if(finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
