//
//  EmotionViewController.swift
//  Hotei
//
//  Created by Sangeetha on 13/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit
import CoreData

class EmotionViewController: UIViewController {
    
    let def = UserDefaults.standard
    var id: Int32 = 0
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        id = def.object(forKey: "userID") as! Int32
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func happy(_ sender: Any) {
        rate(score: 1)
    }

    @IBAction func neutral(_ sender: Any) {
        rate(score: 0)
    }
    
    @IBAction func sad(_ sender: Any) {
        rate(score: -1)
    }
    
    func rate(score:Int16){
        let history = History(context: context)
        let date = Date()
        
        history.dateTime = date as NSDate
        history.activity = "Emotion"
        history.rating = score
        history.userID = id
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        // Print for debug
        print("Time: ", date)
        print("User Id", id)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
