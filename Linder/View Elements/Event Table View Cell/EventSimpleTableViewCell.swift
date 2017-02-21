//
//  EventSimpleTableViewCell.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 2. 13..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit
import Nuke

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
            self._event = new
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
        
        // 이미지 경로
        if let url =  event.thumbnailURL {
            Nuke.loadImage(with: url, into: backgroundImageView!)
        }
        else {
            // TODO : Defalt Event Background Asset needed
            self.backgroundImageView.image = #imageLiteral(resourceName: "323x63_kakao")
        }
        
        eventNameLabel.text = event.title
        // TODO : How to make String corresponding calendar objects.
        
        if let startDate = event.startedAt {
            startDateLabel.text = String(date: startDate)
        }
        if let endDate = event.endedAt {
            endDateLabel.text = String(date: endDate)
        }
        locationLabel.text = String(locationList: event.locations)
    }
}
