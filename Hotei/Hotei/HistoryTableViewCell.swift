//
//  HistoryTableViewCell.swift
//  Hotei
//
//  Created by Akshay  on 14/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var activityImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
