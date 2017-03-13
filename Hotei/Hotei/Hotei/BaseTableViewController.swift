//
//  BaseTableViewController.swift
//  Hotei
//
//  Created by Nick Robertson on 13/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureCell(_ cell: UITableViewCell, forActivity activity: Activities) {
        cell.textLabel?.text = activity.name
    
}
}
