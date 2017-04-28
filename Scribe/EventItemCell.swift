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
    
    private var targetEvent: Event?
    
    func updateCell(withEvent event:Event) {
        self.targetEvent = event
        self.layoutIfNeeded()
    }
    
    override func layoutIfNeeded() {
        if (self.targetEvent != nil) {
            self.eventNameLabel.text = self.targetEvent?.eventName
            if (targetEvent?.eventDescription?.isEmpty ?? true) {
                self.eventDescriptionLabel.text = NSLocalizedString("NoEventDescriptionAvailiable", comment: "")
            } else {
                self.eventDescriptionLabel.text = self.targetEvent?.eventDescription
            }
            self.eventStatusLabel.attributedText = UIUtil.string(forEventStatus: Int((targetEvent?.eventStatus)!))
            if (targetEvent?.eventTime != nil) {
                self.eventTimeLabel.text = DateFormatter.localizedString(from: targetEvent!.eventTime! as Date, dateStyle: .medium, timeStyle: .short)
            }
        }
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
