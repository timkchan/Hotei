//
//  ViewController.swift
//  deletable
//
//  Created by Tim Kit Chan on 28/02/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    let a = (UIApplication.shared.delegate as! AppDelegate)
    let c = a.persistentData.viewContext
    

}

