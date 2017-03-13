//
//  ActivitiesTableViewController.swift
//  Hotei
//
//  Created by Nick Robertson on 13/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit

class ActivitiesTableViewController: UITableViewController, UISearchBarDelegate {
    
    var id: Int32 = 0
    let def = UserDefaults.standard
    var activities : [Activities] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
        //self.searchBarSetup()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    /*func searchBarSetup(){
        let searchBar = UISearchBar(frame: CGRect(x:0,y:0,width:(UIScreen.main.bounds.width),height:70))
        
        searchBar.delegate = self
        
        self.tableView.tableHeaderView = searchBar
    }*/
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchText.isEmpty{
            try? activities = context.fetch(Activities.fetchRequest())
        }
        
        else{
         activities = activities.filter({(act) -> Bool in
            return (act.name?.lowercased().contains(searchText.lowercased()))!
        })
    
        }
        self.tableView.reloadData()
    
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        id = def.object(forKey: "userID") as! Int32
        try? activities = context.fetch(Activities.fetchRequest())
        
        
        
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = activities[indexPath.row].name
        cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.selectionStyle = .none // to prevent cells from being "highlighted"
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        print(activities[indexPath.row].name!)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
}
