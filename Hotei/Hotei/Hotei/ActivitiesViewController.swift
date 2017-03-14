//
//  ActivitiesViewController.swift
//  Hotei
//
//  Created by Tim Kit Chan on 01/02/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//
import UIKit
import CoreData
import UserNotifications


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
			activities.sort { $0.name! < $1.name! }
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
				activities.sort { $0.name! < $1.name! }
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
		emotionNotificationAction()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		UNUserNotificationCenter.current().delegate = self
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	func emotionNotificationAction(){
		let content = UNMutableNotificationContent()
		//content.subtitle = "How Are You Feeling?"
		content.sound = UNNotificationSound.default()
		content.body = "How Are You Feeling?"
		content.categoryIdentifier = "emotionRequest"
		
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
		
		let request = UNNotificationRequest(identifier: "timeUp", content: content, trigger: trigger)
		UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
	}
	
    
	// Number of Rows
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return activities.count
	}
	
	
	// Return Cells
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
		cell.selectionStyle = .none
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
	
	func setEmotionFromNotif(date: Date, rating: Int16){
		
		// Creating History entry and saving it
		let history = History(context: context)
		history.dateTime = date as NSDate
		history.activity = "none"
		history.rating = rating
		history.userID = id
		(UIApplication.shared.delegate as! AppDelegate).saveContext()
		
		// Post the record to server (userID is decleared in to top of FirstViewController)
		postToDataBase(UserId: id, activity: "none", Rating: Int(rating))
		print("emotion registered and app not open")
	}
	
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

	

}


extension ActivitiesViewController: UNUserNotificationCenterDelegate{
	//	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
	//		completionHandler([.alert])
	//	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		let date = Date()
		switch response.actionIdentifier {
			
		case "happy":
			setEmotionFromNotif(date: date, rating: 1)
		//
		case "neutral":
			setEmotionFromNotif(date: date, rating: 0)
			
		case "sad":
			setEmotionFromNotif(date: date, rating: -1)
			
			
		default:
			//			let sb = UIStoryboard(name: "Main", bundle: nil)
			//			let otherVC = sb.instantiateViewController(withIdentifier: "tabVC") as! UITabBarController
			//			let window = UIApplication.shared.keyWindow
			//
			//			window?.rootViewController = otherVC
			
			
			break
		}
		
		completionHandler()
		
	}
	
	
}


