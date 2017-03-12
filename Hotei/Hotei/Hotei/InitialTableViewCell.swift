//
//  InitialTableViewCell.swift
//  Hotei
//
//  Created by Akshay  on 12/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

import UIKit

class InitialTableViewCell: UITableViewCell {

    
    @IBOutlet weak var activityImage: UIImageView!
    
    @IBOutlet weak var activityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
