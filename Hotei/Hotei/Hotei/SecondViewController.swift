//
//  SecondViewController.swift
//  Hotei
//
//  Created by Tim Kit Chan on 01/02/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView2: UITableView!
    
    // Context for CoreDate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var history : [History] = []
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
        getData()
        tableView2.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = history[indexPath.row].nameOfActivities
        return cell
    }


}

