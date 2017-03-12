//
//  InitialPreferenceViewController.swift
//  Hotei
//
//  Created by Akshay  on 12/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit
import CoreData

class InitialPreferenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var activityChoices = [Activities]()
    var preferences = [String]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityChoices = initActivitiesInDataBase()
        self.tbView.allowsMultipleSelection = true
        print(activityChoices.count)
    }
    
    func initActivitiesInDataBase() -> [Activities]{
        
        var activities : [Activities] = []
        try? activities = context.fetch(Activities.fetchRequest())
        
        return activities
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityChoices.count
    }
    
    
    @IBOutlet weak var tbView: UITableView!
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tbView.dequeueReusableCell(withIdentifier: "preferenceCell", for: indexPath) as! InitialTableViewCell
        cell.activityImage.image = UIImage(named: activityChoices[indexPath.row].name!)
        cell.activityLabel.text = activityChoices[indexPath.row].name!
        cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.selectionStyle = .none // to prevent cells from being "highlighted"
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.selectionStyle = .gray
        preferences.append(activityChoices[indexPath.row].name!)
        print(activityChoices[indexPath.row].name!)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        self.preferences.remove(at: preferences.index(of: activityChoices[indexPath.row].name!)!)
    }
    
    
    
    
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        
//        return indexPath
//        
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
//    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
}
