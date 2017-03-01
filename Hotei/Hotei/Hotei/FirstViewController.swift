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
	
	// Context for CoreDate
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	// List of activities in database (will be updated by method initActivitiesInDataBase())
	var activities = [Activities]()
	
	// If database is empty, add some default activity. Else, show current availible activities.
	func initActivitiesInDataBase() -> [Activities]{
		
		var activities : [Activities] = []
		try? activities = context.fetch(Activities.fetchRequest())
		
		if activities.count > 0 {
			
			print("Database: Activities not empty")
			return activities
			
		} else {
			
			let act1 = Activities(context: context)
			act1.setAll(name: "running", frequency: 0)
			let act2 = Activities(context: context)
			act2.setAll(name: "swimming", frequency: 0)
			let act3 = Activities(context: context)
			act3.setAll(name: "racing", frequency: 0)
			let act4 = Activities(context: context)
			act4.setAll(name: "archery", frequency: 0)
			let act5 = Activities(context: context)
			act5.setAll(name: "badminton", frequency: 0)
			let act6 = Activities(context: context)
			act6.setAll(name: "ballet", frequency: 0)
			let act7 = Activities(context: context)
			act7.setAll(name: "fencing", frequency: 0)
			(UIApplication.shared.delegate as! AppDelegate).saveContext()
			
			print("Database: Activities Added")
			return [act1, act2, act3, act4, act5, act6, act7]
		}
	}
	
    // List of activities and their description and image
    var activityDescriptions = [1488276342, 1487376342, 1488300342, 1481376342, 1488376342, 1485322342, 1488457342]

	
	// Reference time since 1970 to generate fake last done.
	let dateRed = 1488376342
	


	
    // TableView Object (Showing list of activities)
    @IBOutlet weak var tableView: UITableView!
    
	
    
    // UIButton control for hapiness level
    @IBAction func hapinessLevel(_ sender: UIButton) {
        let date = Date()
		
		// Creating History entry and saving it
		let history = History(context: context)
		history.dateTime = date as NSDate
		history.activity = Activities.doActivity(name: currentActivity, context: context)
		history.rating = Int16(sender.tag)
		(UIApplication.shared.delegate as! AppDelegate).saveContext()
		tableView.reloadData()
		
		// Print for debug
        print("Time: ", date)
        print("Happiness: ", sender.tag)
        print("Doing: ", currentActivity)
		print("Times so far: ", String(Int((history.activity?.frequency)!)))
    }
    
    // Activity being selected by the user
    var currentActivity = "None"
	

	
	override func viewWillAppear(_ animated: Bool) {
		print("Prepare to init Activities Database")
		activities = initActivitiesInDataBase()
	}
	
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
        return activities.count
    }
    
    // Return Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
		cell.photo.image = UIImage(named: activities[indexPath.row].name!)
        cell.nameLabel.text = activities[indexPath.row].name
        cell.descriptionLabel.text = String(Int(activities[indexPath.row].frequency))
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
        currentActivity = activities[indexPath.row].name!
        print("Selected: ", currentActivity)
    }


}

