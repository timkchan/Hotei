//
//  FirstViewController.swift
//  Hotei
//
//  Created by Tim Kit Chan on 01/02/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var activityNames = ["Running", "Swimmging", "Doing Homework"]
    var activityDescriptions = ["haha", "lala", "papa"]
    var activityImages = [UIImage(named: "running"), UIImage(named: "swimming"), UIImage(named: "racing")]
    
    
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


}

