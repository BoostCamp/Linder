//
//  CalendarTableViewCell.swift
//  Linder
//
//  Created by 박종훈 on 2017. 2. 7..
//  Copyright © 2017년 Linder. All rights reserved.
//

import UIKit

let calendarTableViewCellHeight: CGFloat = 160

class CalendarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var channelThumbnailView: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    
    @IBOutlet weak var calendarNameLabel: UILabel!
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func set(channel: Channel, event: Event) {
        backgroundImageView.image = event.thumbnail
        channelThumbnailView.image = channel.thumbnail
        channelNameLabel.text = channel.title
        calendarNameLabel.text = event.title
        // TODO : How to make String corresponding calendar objects.
        
        if let startDate = event.startDate {
            startDateLabel.text = String(date: startDate)
        }
        if let endDate = event.endDate {
            endDateLabel.text = String(date: endDate)
        }
        locationLabel.text = String(locationList: event.locationList)
    }
    
}
