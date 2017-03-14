//
//  ActivitiesViewController.swift
//  Hotei
//
//  Created by Tim Kit Chan on 01/02/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//
import UIKit
import CoreData


class ActivitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
	
	let def = UserDefaults.standard
	var id: Int32 = 0
	
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var customActivityButton: UIButton!
	
	
	// Context for CoreDate
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
			guard let csvPath = Bundle.main.path(forResource: "activities", ofType: "csv") else { return []}
			
			do {
				let csvData = try String(contentsOfFile: csvPath, encoding: String.Encoding.utf8)
				let array = csvData.components(separatedBy: "\n")
				
				for item in array{
					if(item != ""){
					let act = Activities(context: context)
					act.setAll(name: item)
					(UIApplication.shared.delegate as! AppDelegate).saveContext()
					}
				}
				try? activities = context.fetch(Activities.fetchRequest())
				return activities
			
			}catch{
				print(error)
			}
			
		}
		return []
	}
	
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
	

	
	override func viewWillAppear(_ animated: Bool) {
		id = def.object(forKey: "userID") as! Int32
		activities = initActivitiesInDataBase()
		activities.sort { $0.name! < $1.name! }
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
        let cell = UITableViewCell()
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
	
    @IBAction func addActivity(_ sender: Any) {
        let popovervc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbpopupid") as! PopUpViewController
        popovervc.id = id
        popovervc.currentActivity = "Add Activity"
        self.addChildViewController(popovervc)
        popovervc.view.frame = self.view.frame
        self.view.addSubview(popovervc.view)
        popovervc.didMove(toParentViewController: self)

        
    }
	

}
