//
//  HistoryTableViewController.swift
//  Hotei
//
//  Created by Akshay  on 14/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    let def = UserDefaults.standard
    var id : Int32 = 0;
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var history : [History] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        id = def.object(forKey: "userID") as! Int32
        print(id)
        history = getData()
        //history.sort { $0.dateTime?.timeIntervalSince1970 > $1.dateTime?.timeIntervalSince1970 }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    
    func getData() -> [History]{
        var history : [History] = []
        
        do {
            try history = context.fetch(History.fetchRequest())
            
            history = history.filter({(hist) -> Bool in
                return (hist.userID == id)
                
            })
        } catch {
            print("Fetch Failed")
        }
        
        return history
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return history.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath) as! HistoryTableViewCell
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = history[indexPath.row].activity
        return cell
        
        //cell.activityLabel.text = history[indexPath.row].activity
        //cell.activityImage.image = UIImage(named: history[indexPath.row].activity!)
        //let date = history[indexPath.row].dateTime as! Date
        //cell.timeLabel.text = date.timeIntervalSince197
        
        
        
        
        // Configure the cell...
        
        return cell
    }

}
