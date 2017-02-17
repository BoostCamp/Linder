//
//  ScheduleCalendarViewCell.swift
//  Pastel
//
//  Created by 박종훈 on 2017. 2. 10..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

let scheduleCalendarViewCellHeight: CGFloat = 85

class ScheduleCalendarViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    private var _schedule: Schedule?
    
    var schedule: Schedule? {
        set (new) {
            _schedule = new
            titleLabel.text = new?.name
            startLabel.text = new?.startedAt.toTimeString()
            endLabel.text = new?.endedAt.toTimeString()
            locationLabel.text = new?.location
            addButton.isHidden = new is UserSchedule
        }
        get {
            return _schedule
        }
    }
    
    var isRecommanded: Bool {
        get {
            if let schedule = self._schedule {
                return schedule is RecommandedSchedule
            } else {
                return false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.layer.borderWidth = 0.1
        //self.layer.borderColor = UIColor.darkGray.cgColor

    }
    
    @IBAction func addButtonTouchUpInside(_ sender: UIButton) {
        sender.isHighlighted = true
        debugPrint("TODO : Add to User's Local Calendar")
    }
}
