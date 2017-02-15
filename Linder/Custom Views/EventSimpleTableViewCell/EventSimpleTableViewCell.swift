//
//  EventSimpleTableViewCell.swift
//  Pastel
//
//  Created by 박종훈 on 2017. 2. 13..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

class EventSimpleTableViewCell: UITableViewCell {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var maskingView: UIView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var cornerRadius: CGFloat = 8.0
    
    private var _event: Event = Event()
    var event: Event {
        get {
            return _event
        }
        set (new) {
           set(event: new)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundImageView.layer.cornerRadius = cornerRadius
        backgroundImageView.layer.masksToBounds = true
        maskingView.layer.cornerRadius = cornerRadius
        maskingView.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func set(event: Event) {
        backgroundImageView.image = event.thumbnail
        eventNameLabel.text = event.title
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
