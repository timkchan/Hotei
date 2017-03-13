//
//  InitialPreferenceViewController.swift
//  Hotei
//
//  Created by Akshay  on 12/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit
import CoreData



class InitialPreferenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var activityChoices = [Activities]()
    var preferences = [String]()
    var id: Int32 = 0
    let def = UserDefaults.standard


    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
  
    @IBAction func send(_ sender: Any) {
        
        if (preferences.isEmpty){
            //do not progress 
            //prompt user to select activity
        }
        else{
        let json = convertJsonActivitiesList()
        postUserActivityList(json: json)
        self.performSegue(withIdentifier: "historyNewUser", sender: sender)
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
        activityChoices = initActivitiesInDataBase()
        self.tbView.allowsMultipleSelection = true
        print(activityChoices.count)
        id = def.object(forKey: "userID") as! Int32

        
        
    }

    func initActivitiesInDataBase() -> [Activities]{
        
        var activities : [Activities] = []
        try? activities = context.fetch(Activities.fetchRequest())
        
        return activities
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityChoices.count
    }
    
    
    @IBOutlet weak var tbView: UITableView!


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tbView.dequeueReusableCell(withIdentifier: "preferenceCell", for: indexPath) as! InitialTableViewCell
        cell.activityImage.image = UIImage(named: activityChoices[indexPath.row].name!)
        cell.activityLabel.text = activityChoices[indexPath.row].name!
        cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.selectionStyle = .none // to prevent cells from being "highlighted"
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.selectionStyle = .gray
        preferences.append(activityChoices[indexPath.row].name!)
        print(activityChoices[indexPath.row].name!)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        self.preferences.remove(at: preferences.index(of: activityChoices[indexPath.row].name!)!)
    }
    
    
    
    
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        
//        return indexPath
//        
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
//    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
}
