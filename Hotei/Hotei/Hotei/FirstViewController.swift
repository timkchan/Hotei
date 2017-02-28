//
//  FirstViewController.swift
//  Hotei
//
//  Created by Tim Kit Chan on 01/02/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // List of activities and their description and image
    var activityNames = ["Running", "Swimmging", "Racing", "Archery", "Badminton", "Ballet", "Fencing"]
    var activityDescriptions = ["haha", "lala", "papa", "dada", "fafa", "kaka", "tata"]
    var activityImages = [#imageLiteral(resourceName: "running"), #imageLiteral(resourceName: "swimming"), #imageLiteral(resourceName: "racing"), #imageLiteral(resourceName: "archery"), #imageLiteral(resourceName: "badminton"), #imageLiteral(resourceName: "ballet"), #imageLiteral(resourceName: "fencing")]
    
    // TableView Object (Showing list of activities)
    @IBOutlet weak var tableView: UITableView!
    
    // Context for CoreDate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // UIButton control for hapiness level
    @IBAction func hapinessLevel(_ sender: UIButton) {
        let date = Date()
		
		// Creating History entry and saving it
		let history = History(context: context)
		history.dateTime = date as NSDate
		history.nameOfActivities = currentActivity
		history.rating = Int16(sender.tag)
		(UIApplication.shared.delegate as! AppDelegate).saveContext()
		
		// Print for debug
        print("Time: ", date)
        print("Happiness: ", sender.tag)
        print("Doing: ", currentActivity)
    }
    
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
    
    // Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityNames.count
    }
    
    // Return Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        cell.photo.image = activityImages[indexPath.row]
        cell.nameLabel.text = activityNames[indexPath.row]
        cell.descriptionLabel.text = activityDescriptions[indexPath.row]
        return cell
    }
    
    // Deselect activity if selected
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
    
    // If activity is selected, updated currentActivity
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentActivity = activityNames[indexPath.row]
        print("Selected: ", currentActivity)
    }


}

