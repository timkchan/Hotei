//
//  SecondViewController.swift
//  Hotei
//
//  Created by Tim Kit Chan on 01/02/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit
import UserNotifications


class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView2: UITableView!
    
    // Context for CoreDate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Variable to store history loaded from CoreData.
    var history : [History] = []
    
    // Function to fetch history from coreData
    func getData() {
        do {
            try history = context.fetch(History.fetchRequest())
        } catch {
            print("Fetch Failed")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch data and load into tableView.
        
        getData()
        tableView2.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = history[indexPath.row].activity
        return cell
    }
    
        
    func stressNotification(_ activity: String){
        let content = UNMutableNotificationContent()
        content.title = "You Seem Stressed"
        content.sound = UNNotificationSound.default()
        content.body = "Why don't you try \(activity)"
        content.categoryIdentifier = "stressDetection"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "stress", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }


}

