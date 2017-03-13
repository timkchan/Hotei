//
//  FirstViewController.swift
//  Hotei
//
//  Created by Tim Kit Chan on 01/02/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//
import UIKit
import CoreData

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
	
	let def = UserDefaults.standard
	var id: Int32 = 0
	
    @IBOutlet weak var searchBar: UISearchBar!
	
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
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
		
		if searchText.isEmpty{
			try? activities = context.fetch(Activities.fetchRequest())
		}
			
		else{
			activities = activities.filter({(act) -> Bool in
				return (act.name?.lowercased().contains(searchText.lowercased()))!
			})
			
			if activities.isEmpty{
				
				let act1 = Activities(context: context)
				act1.setAll(name: "Add Activity")
				
				activities = [act1]

			}
			
		}
		self.tableView.reloadData()
		
	}

	
	// TableView Object (Showing list of activities)
	@IBOutlet weak var tableView: UITableView!
	
	
	
	
	override func viewWillAppear(_ animated: Bool) {
		id = def.object(forKey: "userID") as! Int32
		activities = initActivitiesInDataBase()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	
	// Number of Rows
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return activities.count
	}
	
	// Return Cells
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
		cell.textLabel?.text = activities[indexPath.row].name
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		

		
		let popovervc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbpopupid") as! PopUpViewController
		popovervc.id = id
		popovervc.currentActivity = activities[indexPath.row].name
		self.addChildViewController(popovervc)
		popovervc.view.frame = self.view.frame
		self.view.addSubview(popovervc.view)
		popovervc.didMove(toParentViewController: self)
		
		
		
		
	}

	
	
}
