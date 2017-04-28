//
//  EventItemCell.swift
//  Scribe
//
//  Created by Codetector on 2017/4/17.
//  Copyright © 2017年 Codetector. All rights reserved.
//

import UIKit

class EventItemCell: UITableViewCell {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventStatusLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    override func layoutIfNeeded() {
        NSLog("Layout")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
