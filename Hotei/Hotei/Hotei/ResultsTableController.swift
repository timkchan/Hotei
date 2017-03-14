//
//  ResultsTableController.swift
//  Hotei
//
//  Created by Nick Robertson on 13/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit

class ResultsTableController: BaseTableViewController {
    
    var filterActivities = [Activities]()
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterActivities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        let activity = filterActivities[indexPath.row]
        configureCell(cell, forActivity:  activity)
        
        return cell
    }

}
