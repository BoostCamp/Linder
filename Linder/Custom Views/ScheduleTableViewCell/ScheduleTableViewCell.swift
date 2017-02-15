//
//  ScheduleTableViewCell.swift
//  Pastel
//
//  Created by 박종훈 on 2017. 2. 10..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

let scheduleTableViewCellHeight: CGFloat = 86

class ScheduleTableViewCell: UITableViewCell {

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
    }

    @IBAction func addButtonTouchUpInside(_ sender: Any) {
        debugPrint("TODO : Add to User's Local Calendar")
    }
}
