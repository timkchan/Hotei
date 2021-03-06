//
//  InitPrefTableViewController.swift
//  Hotei
//
//  Created by Nick Robertson on 13/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit

class InitPrefTableViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var preferences = [String]()
    var id: Int32 = 0
    let def = UserDefaults.standard
    var activities : [Activities] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.allowsMultipleSelection = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func doneinit(_ sender: Any) {
        
        if (preferences.isEmpty){
            //do not progress
            //prompt user to select activity
        }
        else{
            let json = convertJsonActivitiesList()
            postUserActivityList(json: json)
            self.performSegue(withIdentifier: "newuserprofile", sender: sender)
        }
    }
    
    func postUserActivityList(json:String) {
        //send a new user profile up to server
        // create post request
        let url = URL(string: "http://hoteiapi20170303100733.azurewebsites.net/generateNewUserProfile")!
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = json.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
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
    
    
    func convertJsonActivitiesList() -> String{
        var json:String = "{\"UserId\":" + String(id)+",\"Activities\" : ["
        
        
        for object in preferences {
            json = json + "{\"Activity\" : " + "\"" + object + "\", \"Rating\" : " + String(1.0) + "},"
        }
        json = json.substring(to: json.index(before: json.endIndex))
        
        json = json + "]}"
        
        return json
    }

    
    override func viewWillAppear(_ animated: Bool) {
        id = def.object(forKey: "userID") as! Int32
        activities = initActivitiesInDataBase()
    }
    
    func initActivitiesInDataBase() -> [Activities]{
        
        var activities : [Activities] = []
        try? activities = context.fetch(Activities.fetchRequest())
        
        print(activities.count)
        
        if activities.count > 0 {
            
            print("Database: Activities not empty")
            return activities
            
        } else {
            guard let csvPath = Bundle.main.path(forResource: "activities", ofType: "csv") else { return []}
            
            do {
                let csvData = try String(contentsOfFile: csvPath, encoding: String.Encoding.utf8)
                let array = csvData.components(separatedBy: "\n")
                
                for item in array{
                    let act = Activities(context: context)
                    act.setAll(name: item)
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
                try? activities = context.fetch(Activities.fetchRequest())
                return activities
                
            }catch{
                print(error)
            }
            
        }
        return []
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = activities[indexPath.row].name
        cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.selectionStyle = .none // to prevent cells from being "highlighted"

        return cell
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        preferences.append(activities[indexPath.row].name!)
        print(activities[indexPath.row].name!)
    }
    
     func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        self.preferences.remove(at: preferences.index(of: activities[indexPath.row].name!)!)
    }
}
