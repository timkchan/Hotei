//
//  FirstViewController.swift
//  Hotei
//
//  Created by Tim Kit Chan on 01/02/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // TableView Object (List of activities)
    @IBOutlet weak var tableView: UITableView!
    
    // UIButton control for hapiness level
    @IBAction func hapinessLevel(_ sender: UIButton) {
        let date = Date()
        print("Time: ", date)
        print("Happiness: ", sender.tag)
        print("Doing: ", currentActivity)
        
    }
    
    // List of activities and their description and image
    var activityNames = ["Running", "Swimmging", "Doing Homework"]
    var activityDescriptions = ["haha", "lala", "papa"]
    var activityImages = [UIImage(named: "running"), UIImage(named: "swimming"), UIImage(named: "racing")]
    
    // Activity being selected by the user
    var currentActivity = "None"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        cell.photo.image = activityImages[indexPath.row]
        cell.nameLabel.text = activityNames[indexPath.row]
        cell.descriptionLabel.text = activityDescriptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            if (indexPathForSelectedRow == indexPath) {
                tableView.deselectRow(at: indexPath, animated: false)
                print("Deselected: ", currentActivity)
                currentActivity = "None"
                return nil
            }
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentActivity = activityNames[indexPath.row]
        print("Selected: ", currentActivity)
    }


}

