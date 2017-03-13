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
	
	let def = UserDefaults.standard
	var id: Int32 = 0
	
	
	// Context for CoreDate
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	// List of activities in database (will be updated by method initActivitiesInDataBase())
	var activities = [Activities]()
	
	// If database is empty, add some default activity. Else, show current availible activities.
	func initActivitiesInDataBase() -> [Activities]{
		
		var activities : [Activities] = []
		try? activities = context.fetch(Activities.fetchRequest())
		
		print(activities.count)
		
		if activities.count > 0 {
			
			print("Database: Activities not empty")
			return activities
			
		} else {
			let act1 = Activities(context: context)
			act1.setAll(name: "running")
			let act2 = Activities(context: context)
			act2.setAll(name: "swimming")
			let act3 = Activities(context: context)
			act3.setAll(name: "racing")
			let act4 = Activities(context: context)
			act4.setAll(name: "archery")
			let act5 = Activities(context: context)
			act5.setAll(name: "badminton")
			let act6 = Activities(context: context)
			act6.setAll(name: "ballet")
			let act7 = Activities(context: context)
			act7.setAll(name: "fencing")
			(UIApplication.shared.delegate as! AppDelegate).saveContext()
			
			print("Database: Activities Added")
			print(id);
			return [act1, act2, act3, act4, act5, act6, act7]
		}
	}
	
	// TableView Object (Showing list of activities)
	@IBOutlet weak var tableView: UITableView!
	
	
	// UIButton control for hapiness level
	@IBAction func hapinessLevel(_ sender: UIButton) {
		let date = Date()
		
		// Creating History entry and saving it
		let history = History(context: context)
		history.dateTime = date as NSDate
		history.activity = currentActivity
		history.rating = Int16(sender.tag)
		history.userID = id
		(UIApplication.shared.delegate as! AppDelegate).saveContext()
		
		// Post the record to server (userID is decleared in to top of FirstViewController)
		postToDataBase(UserId: id, activity: currentActivity, Rating: sender.tag)
		
		var histData : [History] = []
		try? histData = context.fetch(History.fetchRequest())
		
		
		
		let frequency = histData.count
		
		//fetchRequest.predicate = NSPredicate(format: "firstName == %@", firstName)

		
		// Print for debug
		print("Time: ", date)
		print("Happiness: ", sender.tag)
		print("Doing: ", currentActivity)
		print("Frequency", frequency)
		print("User Id", id)
		//print("Times so far: ", String(Int((history.activity?.frequency)!)))
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
	
	
	
	// Activity currently being selected by the user
	var currentActivity = "None"
	
	
	override func viewWillAppear(_ animated: Bool) {
		print("Prepare to init Activities Database")
		
		id = def.object(forKey: "userID") as! Int32
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
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	// If activity is selected, updated currentActivity
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		currentActivity = activities[indexPath.row].name!
		print("Selected: ", currentActivity)
	}
	
	
}
